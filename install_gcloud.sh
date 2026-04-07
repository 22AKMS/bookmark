#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

CLOUD_SQL_PROXY_BIN="$(command -v cloud-sql-proxy || true)"
if [[ -z "$CLOUD_SQL_PROXY_BIN" && -x /usr/bin/cloud-sql-proxy ]]; then
  CLOUD_SQL_PROXY_BIN="/usr/bin/cloud-sql-proxy"
fi

cleanup() {
  if [[ -n "${PROXY_PID:-}" ]]; then
    kill "$PROXY_PID" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

log() {
  printf '\n[%s] %s\n' "$(date '+%H:%M:%S')" "$*"
}

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "Required command not found: $1"
}

prompt_default() {
  local var_name="$1"
  local prompt_text="$2"
  local default_value="${3:-}"
  local secret="${4:-0}"
  local value=""

  while true; do
    if [[ "$secret" == "1" ]]; then
      if [[ -n "$default_value" ]]; then
        read -r -s -p "$prompt_text [$default_value]: " value || true
      else
        read -r -s -p "$prompt_text: " value || true
      fi
      printf '\n'
    else
      if [[ -n "$default_value" ]]; then
        read -r -p "$prompt_text [$default_value]: " value || true
      else
        read -r -p "$prompt_text: " value || true
      fi
    fi

    if [[ -z "$value" ]]; then
      value="$default_value"
    fi

    if [[ -n "$value" ]]; then
      printf -v "$var_name" '%s' "$value"
      return 0
    fi

    echo "Value is required."
  done
}

password_ok() {
  local password="$1"
  local username_lc="$2"
  local lowered
  lowered="$(printf '%s' "$password" | tr '[:upper:]' '[:lower:]')"

  [[ ${#password} -ge 10 ]] || return 1
  [[ "$password" =~ [a-z] ]] || return 1
  [[ "$password" =~ [A-Z] ]] || return 1
  [[ "$password" =~ [0-9] ]] || return 1
  [[ "$password" =~ [^[:alnum:]] ]] || return 1
  [[ "$lowered" != *"$username_lc"* ]] || return 1
  return 0
}

prompt_password() {
  local var_name="$1"
  local prompt_text="$2"
  local username_ref="$3"
  local password confirm username_lc
  username_lc="$(printf '%s' "$username_ref" | tr '[:upper:]' '[:lower:]')"

  while true; do
    read -r -s -p "$prompt_text: " password || true
    printf '\n'
    read -r -s -p "Confirm password: " confirm || true
    printf '\n'

    [[ "$password" == "$confirm" ]] || { echo "Passwords did not match."; continue; }
    password_ok "$password" "$username_lc" || {
      echo "Password must be at least 10 characters and include uppercase, lowercase, number, symbol, and not contain the username."
      continue
    }

    printf -v "$var_name" '%s' "$password"
    return 0
  done
}

wait_for_service_account() {
  local email="$1"
  for _ in {1..20}; do
    if gcloud iam service-accounts describe "$email" --project "$PROJECT_ID" >/dev/null 2>&1; then
      return 0
    fi
    sleep 3
  done
  return 1
}

add_binding_if_missing() {
  local member="$1"
  local role="$2"
  for _ in {1..10}; do
    if gcloud projects add-iam-policy-binding "$PROJECT_ID" \
      --member="$member" \
      --role="$role" \
      --quiet >/dev/null 2>&1; then
      return 0
    fi
    sleep 3
  done
  fail "Failed to grant IAM role $role to $member"
}

wait_for_url() {
  local url="$1"
  local attempts=30
  local delay=5
  for ((i=1; i<=attempts; i++)); do
    if curl -fsS "$url" >/dev/null 2>&1; then
      return 0
    fi
    sleep "$delay"
  done
  return 1
}

start_proxy() {
  local port="$1"
  [[ -n "$CLOUD_SQL_PROXY_BIN" ]] || fail "cloud-sql-proxy not found."
  "$CLOUD_SQL_PROXY_BIN" "$INSTANCE_CONNECTION_NAME" --port "$port" >/tmp/cloud-sql-proxy.log 2>&1 &
  PROXY_PID=$!
  sleep 5
  kill -0 "$PROXY_PID" >/dev/null 2>&1 || {
    cat /tmp/cloud-sql-proxy.log >&2 || true
    fail "Cloud SQL Auth Proxy failed to start."
  }
}

ensure_firestore_database() {
  while true; do
    if gcloud firestore databases describe --project "$PROJECT_ID" --database "$FIRESTORE_DB" >/dev/null 2>&1; then
      echo "Firestore database $FIRESTORE_DB already exists."
      return 0
    fi

    local output rc
    set +e
    output="$(gcloud firestore databases create \
      --project "$PROJECT_ID" \
      --database="$FIRESTORE_DB" \
      --location="$REGION" \
      --edition=standard \
      --type=firestore-native 2>&1)"
    rc=$?
    set -e

    if [[ $rc -eq 0 ]]; then
      return 0
    fi

    echo "$output"
    if grep -q "not available in project" <<<"$output"; then
      echo "That Firestore database ID was recently deleted or is temporarily unavailable. Choose a new Firestore database ID."
      prompt_default FIRESTORE_DB "Firestore database ID" "books-app"
      continue
    fi

    fail "Failed to create Firestore database."
  done
}

attach_cloudsql_to_function_service() {
  local function_name="$1"
  local service_name
  service_name="$(gcloud functions describe "$function_name" \
    --project "$PROJECT_ID" \
    --gen2 \
    --region "$REGION" \
    --format='value(serviceConfig.service)' | awk -F/ '{print $NF}')"

  [[ -n "$service_name" ]] || fail "Could not determine backing Cloud Run service for $function_name"

  gcloud run services update "$service_name" \
    --project "$PROJECT_ID" \
    --region "$REGION" \
    --add-cloudsql-instances "$INSTANCE_CONNECTION_NAME" >/dev/null
}

write_manifest() {
  cat > .gcloud-deploy.env <<MANIFEST
PROJECT_ID=$PROJECT_ID
REGION=$REGION
APP_SERVICE=$APP_SERVICE
AVG_FUNCTION=$AVG_FUNCTION
TREND_FUNCTION=$TREND_FUNCTION
SQL_INSTANCE=$INSTANCE
FIRESTORE_DB=$FIRESTORE_DB
APP_SA=$APP_SA
MANIFEST
}

require_cmd gcloud
require_cmd curl
require_cmd psql
require_cmd node

if [[ ! -f package.json || ! -d db || ! -d functions ]]; then
  fail "Run this from the project root that contains package.json, db/, and functions/."
fi

DEFAULT_PROJECT="$(gcloud config get-value project 2>/dev/null || true)"
DEFAULT_ACCOUNT="$(gcloud config get-value account 2>/dev/null || true)"

prompt_default PROJECT_ID "Google Cloud project ID" "$DEFAULT_PROJECT"
prompt_default REGION "Region" "us-central1"
prompt_default INSTANCE "Cloud SQL instance name" "bookfinder-sql"
prompt_default DB_NAME "PostgreSQL database name" "bookfinder"
prompt_default DB_USER "PostgreSQL app user" "appuser"
prompt_password DB_PASSWORD "PostgreSQL app user password" "$DB_USER"
prompt_password POSTGRES_PASSWORD "PostgreSQL postgres admin password" "postgres"
prompt_default FIRESTORE_DB "Firestore database ID" "books-app"
prompt_default APP_SERVICE "Cloud Run service name" "bookfinder-app"
prompt_default APP_SA "Service account name" "bookfinder-sa"
prompt_default AVG_FUNCTION "Average-rating function name" "updateAverageRating"
prompt_default TREND_FUNCTION "Trending function name" "rebuildTrending"
prompt_default APP_USER_ID "Demo app user ID" "demo-user"

log "Using project $PROJECT_ID"
gcloud config set project "$PROJECT_ID" >/dev/null

log "Enabling required APIs"
gcloud services enable \
  run.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  artifactregistry.googleapis.com \
  sqladmin.googleapis.com \
  firestore.googleapis.com >/dev/null

log "Ensuring Firestore database exists"
ensure_firestore_database

log "Ensuring Cloud SQL instance exists"
if gcloud sql instances describe "$INSTANCE" --project "$PROJECT_ID" >/dev/null 2>&1; then
  echo "Cloud SQL instance $INSTANCE already exists."
else
  gcloud sql instances create "$INSTANCE" \
    --project "$PROJECT_ID" \
    --database-version=POSTGRES_16 \
    --edition=ENTERPRISE \
    --cpu=2 \
    --memory=7680MB \
    --region="$REGION" \
    --enable-password-policy \
    --password-policy-min-length=10 \
    --password-policy-complexity=COMPLEXITY_DEFAULT \
    --password-policy-reuse-interval=3 \
    --password-policy-disallow-username-substring \
    --password-policy-password-change-interval=1h
fi

log "Setting postgres admin password"
gcloud sql users set-password postgres \
  --project "$PROJECT_ID" \
  --instance="$INSTANCE" \
  --password="$POSTGRES_PASSWORD" >/dev/null

log "Ensuring PostgreSQL database exists"
if gcloud sql databases describe "$DB_NAME" --project "$PROJECT_ID" --instance="$INSTANCE" >/dev/null 2>&1; then
  echo "Database $DB_NAME already exists."
else
  gcloud sql databases create "$DB_NAME" --project "$PROJECT_ID" --instance="$INSTANCE" >/dev/null
fi

log "Ensuring app user exists with the chosen password"
if gcloud sql users list --project "$PROJECT_ID" --instance="$INSTANCE" --format='value(name)' | grep -Fxq "$DB_USER"; then
  gcloud sql users set-password "$DB_USER" --project "$PROJECT_ID" --instance="$INSTANCE" --password="$DB_PASSWORD" >/dev/null
else
  gcloud sql users create "$DB_USER" --project "$PROJECT_ID" --instance="$INSTANCE" --password="$DB_PASSWORD" >/dev/null
fi

INSTANCE_CONNECTION_NAME="$(gcloud sql instances describe "$INSTANCE" --project "$PROJECT_ID" --format='value(connectionName)')"
export INSTANCE_CONNECTION_NAME

PROXY_PORT=9470
log "Starting Cloud SQL Auth Proxy"
start_proxy "$PROXY_PORT"

export DB_HOST=127.0.0.1
export DB_PORT="$PROXY_PORT"
export DB_USER
export DB_NAME
export PGPASSWORD="$POSTGRES_PASSWORD"

log "Granting database privileges"
psql -h 127.0.0.1 -p "$PROXY_PORT" -U postgres -d "$DB_NAME" <<SQL
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
GRANT USAGE, CREATE ON SCHEMA public TO $DB_USER;
SQL

export PGPASSWORD="$DB_PASSWORD"
log "Applying schema"
psql -v ON_ERROR_STOP=1 -h 127.0.0.1 -p "$PROXY_PORT" -U "$DB_USER" -d "$DB_NAME" -f db/schema-postgres.sql >/dev/null

log "Seeding data"
psql -v ON_ERROR_STOP=1 -h 127.0.0.1 -p "$PROXY_PORT" -U "$DB_USER" -d "$DB_NAME" -f db/seed-postgres.sql >/dev/null
BOOK_COUNT="$(psql -t -A -h 127.0.0.1 -p "$PROXY_PORT" -U "$DB_USER" -d "$DB_NAME" -c 'SELECT COUNT(*) FROM books;')"
echo "Books in database: $BOOK_COUNT"

log "Hydrating Google Books covers"
node scripts/hydrateGoogleBooksCovers.js || echo "Warning: Google Books cover hydration did not fully complete."

log "Ensuring Firestore client targets the selected database"
python3 - <<'PY'
from pathlib import Path
p = Path('lib/firestoreStore.js')
text = p.read_text()
needle = '    if (process.env.FIRESTORE_PROJECT_ID) {\n      options.projectId = process.env.FIRESTORE_PROJECT_ID;\n    }\n'
insert = needle + '    if (process.env.FIRESTORE_DATABASE_ID) {\n      options.databaseId = process.env.FIRESTORE_DATABASE_ID;\n    }\n'
if 'options.databaseId' not in text and needle in text:
    text = text.replace(needle, insert)
    p.write_text(text)
PY

SA_EMAIL="${APP_SA}@${PROJECT_ID}.iam.gserviceaccount.com"
log "Ensuring service account exists"
if gcloud iam service-accounts describe "$SA_EMAIL" --project "$PROJECT_ID" >/dev/null 2>&1; then
  echo "Service account $SA_EMAIL already exists."
else
  gcloud iam service-accounts create "$APP_SA" --project "$PROJECT_ID" --display-name="Book app service account" >/dev/null
fi
wait_for_service_account "$SA_EMAIL" || fail "Service account did not become visible in time."

log "Granting IAM roles"
add_binding_if_missing "serviceAccount:$SA_EMAIL" "roles/cloudsql.client"
add_binding_if_missing "serviceAccount:$SA_EMAIL" "roles/datastore.user"

log "Deploying Cloud Run service"
gcloud run deploy "$APP_SERVICE" \
  --project "$PROJECT_ID" \
  --source . \
  --region "$REGION" \
  --allow-unauthenticated \
  --service-account "$SA_EMAIL" \
  --add-cloudsql-instances "$INSTANCE_CONNECTION_NAME" \
  --set-env-vars "APP_USER_ID=$APP_USER_ID,FIRESTORE_PROJECT_ID=$PROJECT_ID,FIRESTORE_DATABASE_ID=$FIRESTORE_DB,INSTANCE_CONNECTION_NAME=$INSTANCE_CONNECTION_NAME,DB_NAME=$DB_NAME,DB_USER=$DB_USER,DB_PASSWORD=$DB_PASSWORD"

log "Deploying function $AVG_FUNCTION"
gcloud functions deploy "$AVG_FUNCTION" \
  --project "$PROJECT_ID" \
  --gen2 \
  --runtime=nodejs22 \
  --region="$REGION" \
  --source=functions/updateAverageRating \
  --entry-point=updateAverageRating \
  --trigger-http \
  --allow-unauthenticated \
  --service-account="$SA_EMAIL" \
  --set-env-vars "INSTANCE_CONNECTION_NAME=$INSTANCE_CONNECTION_NAME,DB_NAME=$DB_NAME,DB_USER=$DB_USER,DB_PASSWORD=$DB_PASSWORD"
attach_cloudsql_to_function_service "$AVG_FUNCTION"

log "Deploying function $TREND_FUNCTION"
gcloud functions deploy "$TREND_FUNCTION" \
  --project "$PROJECT_ID" \
  --gen2 \
  --runtime=nodejs22 \
  --region="$REGION" \
  --source=functions/rebuildTrending \
  --entry-point=rebuildTrending \
  --trigger-http \
  --allow-unauthenticated \
  --service-account="$SA_EMAIL" \
  --set-env-vars "INSTANCE_CONNECTION_NAME=$INSTANCE_CONNECTION_NAME,DB_NAME=$DB_NAME,DB_USER=$DB_USER,DB_PASSWORD=$DB_PASSWORD"
attach_cloudsql_to_function_service "$TREND_FUNCTION"

AVG_URL="$(gcloud functions describe "$AVG_FUNCTION" --project "$PROJECT_ID" --gen2 --region "$REGION" --format='value(serviceConfig.uri)')"
TREND_URL="$(gcloud functions describe "$TREND_FUNCTION" --project "$PROJECT_ID" --gen2 --region "$REGION" --format='value(serviceConfig.uri)')"

log "Updating Cloud Run with function URLs"
gcloud run services update "$APP_SERVICE" \
  --project "$PROJECT_ID" \
  --region "$REGION" \
  --update-env-vars "AVG_RATING_FUNCTION_URL=$AVG_URL,TRENDING_FUNCTION_URL=$TREND_URL"

APP_URL="$(gcloud run services describe "$APP_SERVICE" --project "$PROJECT_ID" --region "$REGION" --format='value(status.url)')"
write_manifest

log "Smoke testing deployment"
if wait_for_url "$APP_URL/api/books?sort=title"; then
  curl -fsS "$APP_URL/api/books?sort=title" | head -c 400 && echo
else
  echo "Warning: /api/books did not respond successfully in time."
fi

cat <<DONE

Finished.

App URL: $APP_URL
Average rating function: $AVG_URL
Trending function: $TREND_URL
Cloud SQL instance: $INSTANCE
Firestore database: $FIRESTORE_DB
Active gcloud account: ${DEFAULT_ACCOUNT:-unknown}

DONE

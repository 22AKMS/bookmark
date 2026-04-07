#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

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
  local value=""

  while true; do
    if [[ -n "$default_value" ]]; then
      read -r -p "$prompt_text [$default_value]: " value || true
    else
      read -r -p "$prompt_text: " value || true
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

prompt_yes_no() {
  local var_name="$1"
  local prompt_text="$2"
  local default_value="${3:-y}"
  local value=""
  while true; do
    read -r -p "$prompt_text [${default_value^^}/$([[ "$default_value" == "y" ]] && echo N || echo Y)]: " value || true
    value="${value:-$default_value}"
    value="$(printf '%s' "$value" | tr '[:upper:]' '[:lower:]')"
    case "$value" in
      y|yes) printf -v "$var_name" 'y'; return 0 ;;
      n|no) printf -v "$var_name" 'n'; return 0 ;;
      *) echo "Please answer y or n." ;;
    esac
  done
}

resource_exists() {
  "$@" >/dev/null 2>&1
}

choose_existing_service() {
  local target="$1"
  if resource_exists gcloud run services describe "$target" --project "$PROJECT_ID" --region "$REGION"; then
    printf '%s' "$target"
    return 0
  fi
  local candidates=()
  local name
  while IFS= read -r name; do
    [[ -n "$name" ]] || continue
    candidates+=("$name")
  done < <(gcloud run services list --project "$PROJECT_ID" --region "$REGION" --format='value(metadata.name)' | grep -E '^(bookmark-app|bookfinder-app)$' || true)
  if [[ ${#candidates[@]} -eq 1 ]]; then
    printf '%s' "${candidates[0]}"
    return 0
  fi
  printf '%s' "$target"
}

choose_existing_sql() {
  local target="$1"
  if resource_exists gcloud sql instances describe "$target" --project "$PROJECT_ID"; then
    printf '%s' "$target"
    return 0
  fi
  local candidates=()
  local name
  while IFS= read -r name; do
    [[ -n "$name" ]] || continue
    candidates+=("$name")
  done < <(gcloud sql instances list --project "$PROJECT_ID" --format='value(name)' | grep -E '^(bookmark-sql|bookfinder-sql)$' || true)
  if [[ ${#candidates[@]} -eq 1 ]]; then
    printf '%s' "${candidates[0]}"
    return 0
  fi
  printf '%s' "$target"
}

choose_existing_firestore() {
  local target="$1"
  if resource_exists gcloud firestore databases describe --project "$PROJECT_ID" --database "$target"; then
    printf '%s' "$target"
    return 0
  fi
  local candidates=()
  local name
  while IFS= read -r name; do
    [[ -n "$name" ]] || continue
    candidates+=("$name")
  done < <(gcloud firestore databases list --project "$PROJECT_ID" --format='value(name)' | sed 's#.*/databases/##' | grep -E '^(books-app|\(default\))$' || true)
  if [[ ${#candidates[@]} -eq 1 ]]; then
    printf '%s' "${candidates[0]}"
    return 0
  fi
  printf '%s' "$target"
}

require_cmd gcloud

if [[ -f .gcloud-deploy.env ]]; then
  # shellcheck disable=SC1091
  source .gcloud-deploy.env
fi

CURRENT_PROJECT="${PROJECT_ID:-$(gcloud config get-value project 2>/dev/null || true)}"
CURRENT_ACCOUNT="$(gcloud config get-value account 2>/dev/null || true)"

prompt_default PROJECT_ID "Google Cloud project ID" "${CURRENT_PROJECT:-}"
prompt_default REGION "Region" "${REGION:-us-central1}"
prompt_default APP_SERVICE "Cloud Run service name" "${APP_SERVICE:-bookmark-app}"
prompt_default AVG_FUNCTION "Average-rating function name" "${AVG_FUNCTION:-updateAverageRating}"
prompt_default TREND_FUNCTION "Trending function name" "${TREND_FUNCTION:-rebuildTrending}"
prompt_default SQL_INSTANCE "Cloud SQL instance name" "${INSTANCE:-bookmark-sql}"
prompt_default FIRESTORE_DB "Firestore database ID" "${FIRESTORE_DB:-books-app}"
prompt_default APP_SA "Service account name to optionally delete" "${APP_SA:-bookmark-sa}"
prompt_yes_no DELETE_SERVICE_ACCOUNT "Also delete the app service account?" "y"

log "Active gcloud account: ${CURRENT_ACCOUNT:-unknown}"
log "Using project: $PROJECT_ID"
gcloud config set project "$PROJECT_ID" >/dev/null

APP_SERVICE="$(choose_existing_service "$APP_SERVICE")"
SQL_INSTANCE="$(choose_existing_sql "$SQL_INSTANCE")"
FIRESTORE_DB="$(choose_existing_firestore "$FIRESTORE_DB")"

cat <<OUT

This will permanently delete these resources from project '$PROJECT_ID':
  - Cloud Run service: $APP_SERVICE
  - Cloud Function (gen2): $AVG_FUNCTION
  - Cloud Function (gen2): $TREND_FUNCTION
  - Cloud SQL instance: $SQL_INSTANCE
  - Firestore database: $FIRESTORE_DB
OUT

if [[ "$DELETE_SERVICE_ACCOUNT" == "y" ]]; then
  echo "  - Service account: ${APP_SA}@${PROJECT_ID}.iam.gserviceaccount.com"
fi

echo
read -r -p "Type DELETE to continue: " CONFIRM
[[ "$CONFIRM" == "DELETE" ]] || fail "Cancelled."

log "Deleting Cloud Run service if it exists"
if resource_exists gcloud run services describe "$APP_SERVICE" --project "$PROJECT_ID" --region "$REGION"; then
  gcloud run services delete "$APP_SERVICE" --project "$PROJECT_ID" --region "$REGION" --quiet
else
  echo "Cloud Run service not found: $APP_SERVICE"
fi

log "Deleting Cloud Functions if they exist"
if resource_exists gcloud functions describe "$AVG_FUNCTION" --project "$PROJECT_ID" --gen2 --region "$REGION"; then
  gcloud functions delete "$AVG_FUNCTION" --project "$PROJECT_ID" --gen2 --region "$REGION" --quiet
else
  echo "Function not found: $AVG_FUNCTION"
fi

if resource_exists gcloud functions describe "$TREND_FUNCTION" --project "$PROJECT_ID" --gen2 --region "$REGION"; then
  gcloud functions delete "$TREND_FUNCTION" --project "$PROJECT_ID" --gen2 --region "$REGION" --quiet
else
  echo "Function not found: $TREND_FUNCTION"
fi

log "Deleting Cloud SQL instance if it exists"
if resource_exists gcloud sql instances describe "$SQL_INSTANCE" --project "$PROJECT_ID"; then
  gcloud sql instances patch "$SQL_INSTANCE" --project "$PROJECT_ID" --no-deletion-protection --quiet >/dev/null 2>&1 || true
  gcloud sql instances delete "$SQL_INSTANCE" --project "$PROJECT_ID" --quiet
else
  echo "Cloud SQL instance not found: $SQL_INSTANCE"
fi

log "Deleting Firestore database if it exists"
if resource_exists gcloud firestore databases describe --project "$PROJECT_ID" --database "$FIRESTORE_DB"; then
  gcloud firestore databases update --project "$PROJECT_ID" --database "$FIRESTORE_DB" --no-delete-protection --quiet >/dev/null 2>&1 || true
  gcloud firestore databases delete --project "$PROJECT_ID" --database "$FIRESTORE_DB" --quiet
else
  echo "Firestore database not found: $FIRESTORE_DB"
fi

if [[ "$DELETE_SERVICE_ACCOUNT" == "y" ]]; then
  log "Deleting service account if it exists"
  SERVICE_ACCOUNT_EMAIL="${APP_SA}@${PROJECT_ID}.iam.gserviceaccount.com"
  if resource_exists gcloud iam service-accounts describe "$SERVICE_ACCOUNT_EMAIL" --project "$PROJECT_ID"; then
    gcloud iam service-accounts delete "$SERVICE_ACCOUNT_EMAIL" --project "$PROJECT_ID" --quiet
  else
    echo "Service account not found: $SERVICE_ACCOUNT_EMAIL"
  fi
fi

rm -f .gcloud-deploy.env

log "Remaining matching resources"
gcloud run services list --project "$PROJECT_ID" --region "$REGION" || true
gcloud functions list --project "$PROJECT_ID" --regions "$REGION" || true
gcloud sql instances list --project "$PROJECT_ID" || true
gcloud firestore databases list --project "$PROJECT_ID" || true

log "Uninstall complete."

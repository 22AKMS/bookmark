# Google Cloud Setup Guide

This guide walks through deploying the **Book Finder and Review App** on Google Cloud using:

- **Cloud Run** for the web app
- **Cloud SQL PostgreSQL** for the relational database
- **Firestore** for the non-relational database
- **2 Google Cloud Functions** for project functionality

> Important: this project uses a named Firestore database called `books-app`. The code must explicitly target that database.

---

## 1. Go to the repo root

```bash
cd ~/book-app/webapp
pwd
ls
```

You should see:

```bash
package.json  server.js  db  functions  views  public
```

---

## 2. Set variables

Replace the password with your real one.

```bash
gcloud config set project gcs-501

export PROJECT_ID="$(gcloud config get-value project)"
export REGION="us-central1"
export INSTANCE="bookfinder-sql"
export DB_NAME="bookfinder"
export DB_USER="appuser"
export DB_PASSWORD="YourRealPassword123!"
export APP_SERVICE="bookfinder-app"
export APP_SA="bookfinder-sa"
export FIRESTORE_DB="books-app"
```

Check:

```bash
echo "$PROJECT_ID"
```

---

## 3. Enable the APIs

```bash
gcloud services enable \
  run.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  artifactregistry.googleapis.com \
  sqladmin.googleapis.com \
  firestore.googleapis.com
```

---

## 4. If you ever need to recreate Cloud SQL

Use **Enterprise** with custom CPU/memory.

```bash
gcloud sql instances create "$INSTANCE" \
  --database-version=POSTGRES_16 \
  --edition=ENTERPRISE \
  --cpu=2 \
  --memory=7680MB \
  --region="$REGION"
```

Then:

```bash
gcloud sql users set-password postgres \
  --instance="$INSTANCE" \
  --password="$DB_PASSWORD"

gcloud sql databases create "$DB_NAME" --instance="$INSTANCE"

gcloud sql users create "$DB_USER" \
  --instance="$INSTANCE" \
  --password="$DB_PASSWORD"
```

---

## 5. Finish the PostgreSQL setup

Connect as `postgres`:

```bash
gcloud sql connect "$INSTANCE" --user=postgres
```

Inside `psql`:

```sql
\c bookfinder
GRANT ALL PRIVILEGES ON DATABASE bookfinder TO appuser;
GRANT USAGE, CREATE ON SCHEMA public TO appuser;
\q
```

Reconnect as `appuser`:

```bash
gcloud sql connect "$INSTANCE" --user=appuser
```

Inside `psql`:

```sql
\c bookfinder
\i db/schema-postgres.sql
\i db/seed-postgres.sql
SELECT COUNT(*) FROM books;
\q
```

---

## 6. Patch the app for your Firestore database name

Edit `lib/firestoreStore.js` and add this line inside the constructor after the `projectId` block:

```js
options.databaseId = process.env.FIRESTORE_DATABASE_ID;
```

That is the code change needed so the app targets the named Firestore database `books-app` instead of `(default)`.

---

## 7. Create a service account for the app and functions

```bash
gcloud iam service-accounts create "$APP_SA" \
  --display-name="Book Finder service account"

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${APP_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/cloudsql.client"

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${APP_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/datastore.user"
```

---

## 8. Get the Cloud SQL connection name

```bash
export INSTANCE_CONNECTION_NAME="$(gcloud sql instances describe "$INSTANCE" --format='value(connectionName)')"
echo "$INSTANCE_CONNECTION_NAME"
```

---

## 9. Deploy the web app to Cloud Run

```bash
gcloud run deploy "$APP_SERVICE" \
  --source . \
  --region "$REGION" \
  --allow-unauthenticated \
  --service-account "${APP_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --add-cloudsql-instances "$INSTANCE_CONNECTION_NAME" \
  --set-env-vars "APP_USER_ID=demo-user,FIRESTORE_PROJECT_ID=$PROJECT_ID,FIRESTORE_DATABASE_ID=$FIRESTORE_DB,INSTANCE_CONNECTION_NAME=$INSTANCE_CONNECTION_NAME,DB_NAME=$DB_NAME,DB_USER=$DB_USER,DB_PASSWORD=$DB_PASSWORD"
```

---

## 10. Deploy function 1

```bash
gcloud functions deploy updateAverageRating \
  --gen2 \
  --runtime=nodejs20 \
  --region="$REGION" \
  --source=functions/updateAverageRating \
  --entry-point=updateAverageRating \
  --trigger-http \
  --allow-unauthenticated \
  --service-account="${APP_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --set-env-vars "INSTANCE_CONNECTION_NAME=$INSTANCE_CONNECTION_NAME,DB_NAME=$DB_NAME,DB_USER=$DB_USER,DB_PASSWORD=$DB_PASSWORD"
```

---

## 11. Deploy function 2

```bash
gcloud functions deploy rebuildTrending \
  --gen2 \
  --runtime=nodejs20 \
  --region="$REGION" \
  --source=functions/rebuildTrending \
  --entry-point=rebuildTrending \
  --trigger-http \
  --allow-unauthenticated \
  --service-account="${APP_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --set-env-vars "INSTANCE_CONNECTION_NAME=$INSTANCE_CONNECTION_NAME,DB_NAME=$DB_NAME,DB_USER=$DB_USER,DB_PASSWORD=$DB_PASSWORD"
```

---

## 12. Get the function URLs and attach them to the app

```bash
export AVG_URL="$(gcloud functions describe updateAverageRating --gen2 --region "$REGION" --format='value(serviceConfig.uri)')"
export TREND_URL="$(gcloud functions describe rebuildTrending --gen2 --region "$REGION" --format='value(serviceConfig.uri)')"

gcloud run services update "$APP_SERVICE" \
  --region "$REGION" \
  --set-env-vars "AVG_RATING_FUNCTION_URL=$AVG_URL,TRENDING_FUNCTION_URL=$TREND_URL"
```

---

## 13. Get the app URL

```bash
gcloud run services describe "$APP_SERVICE" \
  --region "$REGION" \
  --format='value(status.url)'
```

Open that URL in your browser.

---

## 14. If something breaks, read logs

```bash
gcloud run services logs read "$APP_SERVICE" --region "$REGION" --limit=100
gcloud functions logs read updateAverageRating --gen2 --region "$REGION" --limit=100
gcloud functions logs read rebuildTrending --gen2 --region "$REGION" --limit=100
```

---

## Recommended order from your current state

Since you already created the Cloud SQL instance, start here:

1. Finish PostgreSQL permissions and load schema/seed
2. Patch `lib/firestoreStore.js`
3. Create the service account
4. Deploy Cloud Run
5. Deploy both functions
6. Attach function URLs to the app
7. Test the app

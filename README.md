# bookmark

A lightweight web application for browsing books, viewing details, leaving reviews, saving favorites, keeping a reading list, and rebuilding a trending list.

## Project specification checklist

Use this as a grading checklist based on the project overview requirements.

### Required project features
- [ ] Application is available on the web
- [ ] Uses **one relational database**
- [ ] Uses **one non-relational database**
- [ ] Uses **at least two Google Cloud Functions** that support project functionality
- [ ] Includes additional functionality beyond the bare minimum
- [ ] Application stays deployed and accessible through the grading period
- [ ] Uses real project data, seeded data, or a public dataset/API

### How this project maps to those requirements
- [x] **Web application**: Node.js + Express app deployed to **Cloud Run**
- [x] **Relational database**: **Cloud SQL for PostgreSQL**
- [x] **Non-relational database**: **Firestore**
- [x] **Google Cloud Function #1**: `updateAverageRating`
- [x] **Google Cloud Function #2**: `rebuildTrending`
- [x] **Additional functionality**: search, sorting, reviews, favorites, reading list, trending section, CLI control panel, installer
- [x] **Public-facing deployment target**: Cloud Run URL

### Deliverable 1 checklist
- [x] Overall project concept / description
- [x] Rough project architecture diagram
- [x] List of data sources / tools / APIs
- [x] Overview of team member responsibilities

### Deliverable 3 checklist
- [ ] Finalized project overview and architecture document
- [ ] Names of all group members included
- [ ] Zipped folder containing code and any data files
- [ ] Final demo recording showing the application and implemented services

## Project concept / description

**bookmark** is a data-driven book discovery and review web app. Users can:
- browse and search books
- open a detail page for each book
- submit reviews and ratings
- save books to favorites
- add books to a reading list
- rebuild a trending list through a cloud function

The app is intentionally styled lightly so the focus stays on functionality and cloud deployment.

## Data sources / tools / APIs

### Core platform and services
- **Cloud Run** for hosting the web app
- **Cloud SQL (PostgreSQL)** for structured book and review data
- **Firestore** for favorites and reading-list data
- **Google Cloud Functions** for rating and trending updates

### Project files that implement those pieces
- `server.js` - main web application
- `db/schema-postgres.sql` - PostgreSQL schema
- `db/seed-postgres.sql` - starter data
- `functions/updateAverageRating/` - function to recompute a book's average rating
- `functions/rebuildTrending/` - function to rebuild trending results
- `install_gcloud.sh` - interactive installer
- `bookmark_control.sh` - local / cloud control panel

## Team member responsibilities

Adjust these names for your team.

- [ ] **Member 1 - Web app / frontend**: pages, search UI, detail view, light styling
- [ ] **Member 2 - Backend / API**: routes, validation, PostgreSQL queries, Cloud Run app wiring
- [ ] **Member 3 - Databases / cloud services**: Cloud SQL, Firestore, seeding, IAM, environment setup
- [ ] **Member 4 - Functions / deployment / demo**: Cloud Functions, testing, deployment verification, final demo recording

## Rough project architecture diagram

```text
                           +-----------------------+
                           |       Browser         |
                           |  list page / detail   |
                           +-----------+-----------+
                                       |
                                       | HTTPS
                                       v
                           +-----------------------+
                           |   Cloud Run web app   |
                           |  Node.js / Express    |
                           +----+-------------+----+
                                |             |
               relational data  |             |  non-relational data
                                v             v
                  +-------------------+   +-------------------+
                  | Cloud SQL         |   | Firestore         |
                  | PostgreSQL        |   | favorites / list  |
                  | books / reviews   |   | user activity     |
                  +---------+---------+   +-------------------+
                            |
                            | invoked for maintenance / updates
                            v
                +-----------------------------+
                | Google Cloud Functions      |
                | 1) updateAverageRating      |
                | 2) rebuildTrending          |
                +-----------------------------+
```

---

# Manual installation

These steps assume you already cloned the project into **Cloud Shell** and want to set it up manually with the Google Cloud CLI.

## Section 1: Databases

### 1. Go to the project root

```bash
cd ~/book-app/webapp
pwd
ls
```

You should see `package.json`, `server.js`, `db/`, `functions/`, `views/`, and `public/`.

### 2. Set your project and shell variables

Replace the password with your real password.

```bash
gcloud config set project YOUR_PROJECT_ID

export PROJECT_ID="$(gcloud config get-value project)"
export REGION="us-central1"
export INSTANCE="bookmark-sql"
export DB_NAME="bookmark"
export DB_USER="appuser"
export DB_PASSWORD="YOUR_REAL_DB_PASSWORD"
export FIRESTORE_DB="books-app"
```

### 3. Enable required APIs

```bash
gcloud services enable \
  run.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  artifactregistry.googleapis.com \
  sqladmin.googleapis.com \
  firestore.googleapis.com
```

### 4. Create Firestore

If you already created a Firestore database, skip this.

```bash
gcloud firestore databases create \
  --database="$FIRESTORE_DB" \
  --location="$REGION" \
  --edition=standard \
  --type=firestore-native
```

### 5. Create Cloud SQL PostgreSQL

If the instance already exists, skip this and move to the next step.

```bash
gcloud sql instances create "$INSTANCE" \
  --database-version=POSTGRES_16 \
  --edition=ENTERPRISE \
  --cpu=2 \
  --memory=7680MB \
  --region="$REGION"
```

### 6. Set the admin password, create the app database, and create the app user

```bash
gcloud sql users set-password postgres \
  --instance="$INSTANCE" \
  --password="$DB_PASSWORD"

gcloud sql databases create "$DB_NAME" --instance="$INSTANCE"

gcloud sql users create "$DB_USER" \
  --instance="$INSTANCE" \
  --password="$DB_PASSWORD"
```

### 7. Connect and grant permissions

Connect as `postgres`:

```bash
gcloud sql connect "$INSTANCE" --user=postgres
```

Inside `psql`:

```sql
\c bookmark
GRANT ALL PRIVILEGES ON DATABASE bookmark TO appuser;
GRANT USAGE, CREATE ON SCHEMA public TO appuser;
\q
```

Reconnect as `appuser`:

```bash
gcloud sql connect "$INSTANCE" --user=appuser
```

Inside `psql`:

```sql
\c bookmark
\i db/schema-postgres.sql
\i db/seed-postgres.sql
SELECT COUNT(*) FROM books;
\q
```

### 8. Patch Firestore database selection if needed

This project supports named Firestore databases. In `lib/firestoreStore.js`, make sure the constructor passes the database ID:

```javascript
options.databaseId = process.env.FIRESTORE_DATABASE_ID;
```

---

## Section 2: Web app and functions

### 1. Create a service account

```bash
export APP_SERVICE="bookmark-app"
export APP_SA="bookmark-sa"

gcloud iam service-accounts create "$APP_SA" \
  --display-name="bookmark service account"
```

### 2. Grant IAM roles

```bash
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${APP_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/cloudsql.client"

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${APP_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/datastore.user"
```

### 3. Get the Cloud SQL connection name

```bash
export INSTANCE_CONNECTION_NAME="$(gcloud sql instances describe "$INSTANCE" --format='value(connectionName)')"
echo "$INSTANCE_CONNECTION_NAME"
```

### 4. Deploy the web app to Cloud Run

```bash
gcloud run deploy "$APP_SERVICE" \
  --source . \
  --region "$REGION" \
  --allow-unauthenticated \
  --service-account "${APP_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --add-cloudsql-instances "$INSTANCE_CONNECTION_NAME" \
  --set-env-vars "APP_USER_ID=demo-user,FIRESTORE_PROJECT_ID=$PROJECT_ID,FIRESTORE_DATABASE_ID=$FIRESTORE_DB,INSTANCE_CONNECTION_NAME=$INSTANCE_CONNECTION_NAME,DB_NAME=$DB_NAME,DB_USER=$DB_USER,DB_PASSWORD=$DB_PASSWORD"
```

### 5. Deploy Google Cloud Function #1

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

### 6. Deploy Google Cloud Function #2

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

### 7. Get the function URLs

```bash
export AVG_URL="$(gcloud functions describe updateAverageRating --gen2 --region "$REGION" --format='value(serviceConfig.uri)')"
export TREND_URL="$(gcloud functions describe rebuildTrending --gen2 --region "$REGION" --format='value(serviceConfig.uri)')"

echo "$AVG_URL"
echo "$TREND_URL"
```

### 8. Wire the function URLs into the Cloud Run app

```bash
gcloud run services update "$APP_SERVICE" \
  --region "$REGION" \
  --set-env-vars "AVG_RATING_FUNCTION_URL=$AVG_URL,TRENDING_FUNCTION_URL=$TREND_URL"
```

### 9. Get the app URL

```bash
gcloud run services describe "$APP_SERVICE" \
  --region "$REGION" \
  --format='value(status.url)'
```

### 10. Verify the deployment

- [ ] Home page loads
- [ ] Books appear on the list page
- [ ] Search works
- [ ] Book detail page opens
- [ ] Review submission works
- [ ] Favorites work
- [ ] Reading list works
- [ ] Trending function runs successfully

### 11. Useful logs

```bash
gcloud run services logs read "$APP_SERVICE" --region "$REGION" --limit=100
gcloud functions logs read updateAverageRating --gen2 --region "$REGION" --limit=100
gcloud functions logs read rebuildTrending --gen2 --region "$REGION" --limit=100
```

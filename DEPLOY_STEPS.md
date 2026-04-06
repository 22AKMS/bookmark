# Deploy Steps

## 1) Create Firestore
Create a Firestore database in Native mode.

## 2) Create Cloud SQL PostgreSQL
Suggested names:
- Instance: `bookmark-sql`
- Database: `bookmark`
- User: `appuser`

## 3) Run the SQL files
Run these in order:
- `db/schema-postgres.sql`
- `db/seed-postgres.sql`

## 4) Deploy the app
Use `install_gcloud.sh` for the easiest path, or deploy manually with Cloud Run and the two functions.

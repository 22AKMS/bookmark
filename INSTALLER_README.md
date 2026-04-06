# bookmark installer

This project includes `install_gcloud.sh`, an interactive installer for Cloud Shell.

## What it does

- prompts for your Google Cloud variables
- validates strong passwords locally before continuing
- enables the required APIs
- creates or reuses Firestore
- creates or reuses Cloud SQL for PostgreSQL
- enables a Cloud SQL instance password policy
- creates the app database and user
- loads the PostgreSQL schema and seed data
- deploys Cloud Run and both Cloud Functions
- wires the function URLs back into the app
- smoke-tests the deployment

## Password rules used by the installer

The installer requires each entered database password to be:

- at least 14 characters
- contain lowercase, uppercase, a number, and a symbol
- not contain the related username as a substring

It also creates the Cloud SQL instance with password policy settings enabled.

## Run it

From the project root in Cloud Shell:

```bash
chmod +x install_gcloud.sh
./install_gcloud.sh
```

## Extra helper

A simple control panel is included:

```bash
chmod +x bookmark_control.sh
./bookmark_control.sh
```

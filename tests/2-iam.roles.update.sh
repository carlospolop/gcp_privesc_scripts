#!/bin/bash

source lib/lib.sh

echo "================================================"
echo "Checking iam.roles.update"

modify_role "iam.roles.update,iam.roles.get"


gcloud --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
  iam roles update "$ROLE_NAME" --project "$PROJECT_ID" --add-permissions "iam.serviceAccountKeys.create"


# Cleaning
gcloud iam roles describe "$ROLE_NAME" --project "$PROJECT_ID"
echo "The role 'iam.serviceAccountKeys.create' should have been granted"
read -p "Press any key to delete scenario... " -n1 -s

# No deletion needed

echo "================================================"

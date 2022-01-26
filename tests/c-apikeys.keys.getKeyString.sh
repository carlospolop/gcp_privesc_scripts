#!/bin/bash

source lib/lib.sh

echo "================================================"
echo "Checking apikeys.keys.list,apikeys.keys.getKeyString"

enable_service "apikeys.googleapis.com"

modify_role "apikeys.keys.list,apikeys.keys.getKeyString"

for key in $(gcloud --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" alpha services api-keys list --uri); do
  gcloud --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" alpha services api-keys get-key-string "$key"
done


# Cleaning
echo "You should see a token previous to this message"
read -p "Press any key to delete scenario... " -n1 -s
echo ""

disable_service "apikeys.googleapis.com"

echo "================================================"

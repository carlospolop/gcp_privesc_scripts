#!/bin/bash

source lib/lib.sh

echo "================================================"
echo "Checking apikeys.keys.list"

enable_service "apikeys.googleapis.com"

modify_role "apikeys.keys.create"

gcloud --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
  alpha services api-keys create


# Cleaning
echo "You should see a token previous to this message"
read -p "Press any key to delete scenario... " -n1 -s
echo ""

echo "================================================"

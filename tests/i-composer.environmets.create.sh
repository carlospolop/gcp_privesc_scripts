#!/bin/bash

source lib/lib.sh



echo "================================================"
echo "Checking composer.environmets.create"

#enable_service "composer.googleapis.com"


modify_role "composer.environments.create"

gcloud beta --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
  composer environments create privesc-test \
--project "${PROJECT_ID}" \
--location europe-west1 \
--service-account="${ATTACK_SA}@${PROJECT_ID}.iam.gserviceaccount.com"

# Cleaning
read -p "Press any key to delete scenario... " -n1 -s
echo ""

gcloud beta composer environments delete privesc-test

#disable_service "composer.googleapis.com"

echo "================================================"

#!/bin/bash

source lib/lib.sh

echo "================================================"
echo "Checking cloudbuild.builds.create"


modify_role "cloudbuild.builds.create"

echo "PROJECT ID: ${PROJECT_ID}"

echo "TOKEN: "
gcloud --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" auth print-access-token


# Cleaning
echo "Execute ./tests/f-cloudbuild.builds.create.py to get a reverse shell inside the build and steal the SA token (you may need to install python libraries)"
read -p "Press any key to delete scenario... " -n1 -s
echo ""


echo "================================================"

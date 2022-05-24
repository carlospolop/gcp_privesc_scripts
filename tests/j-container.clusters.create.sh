#!/bin/bash

source lib/lib.sh

echo "This doesn't work without ActAs over the attacked SA"

echo "================================================"
echo "Checking container.clusters.update"

#enable_service "container.googleapis.com"


modify_role "container.pods.exec,container.pods.create,container.persistentVolumes.create,container.persistentVolumeClaims.create,container.pods.attach,container.pods.delete"


gcloud container clusters get-credentials cluster-1 --zone us-central1-c \
  --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com"



# Cleaning
read -p "Press any key to delete scenario... " -n1 -s
echo ""

#gcloud beta composer environments delete privesc-test

#disable_service "composer.googleapis.com"

echo "================================================"

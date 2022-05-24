#!/bin/bash

source lib/lib.sh


echo "================================================"
echo "Checking compute.projects.setCommonInstanceMetadata"

#enable_service "container.googleapis.com"


modify_role "compute.instances.setMetadata,compute.instances.get,compute.projects.get"

echo "YOU NEED TO SET THE INSTANCE NAME AND ZONE"

gcloud compute ssh $INTANCE_NAME --zone $ZONE \
  --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com"



# Cleaning
read -p "Press any key to delete scenario... " -n1 -s
echo ""

#gcloud beta composer environments delete privesc-test

#disable_service "composer.googleapis.com"

echo "================================================"


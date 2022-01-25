#!/bin/bash

# ARGS

HELP="Use:
    -n Do not delete the test service account
    -1 for deploymentmanager.deployments.create new VM abuse
    -2 for iam.roles.update abuse
    -3 for iam.serviceAccountKeys.create abuse
    -4 for iam.serviceAccounts.getAccessToken abuse
"
source lib/lib.sh

RM_SA="1"


DEPLOYMENTMANAGER_VM="" #-1
IAMROLESUPDATE="" #-2
IAMSERVICEACCOUNTKEYSCREATE="" #-3
IAMGETACCESSTOKEN="" #-4

while getopts "h?n1234" opt; do
  case "$opt" in
    h|\?) printf "%s\n\n" "$HELP"; exit 0;;
    n)  RM_SA="";;
    1)  DEPLOYMENTMANAGER_VM="1";;
    2)  IAMROLESUPDATE="1";;
    3)  IAMSERVICEACCOUNTKEYSCREATE="1";;
    4)  IAMGETACCESSTOKEN="1";;
    esac
done


# PREPARE ENVIRONMENT

export ATTACK_SA="attackedsa"
export PROJECT_ID=$(gcloud config list 2>/dev/null | grep "project =" | head -n1 | cut -d " " -f 3)
export ROLE_NAME=$(openssl rand -hex 12)
#export SERVICE_ACCOUNT_ID="testing$(openssl rand -hex 10)" #Must start with lowercase
export SERVICE_ACCOUNT_ID="securitytest1234"
export CURRENT_USER_EMAIL=$(gcloud config list 2>/dev/null | grep @ | head -n1 | cut -d " " -f 3)

create_sa
create_role "deploymentmanager.deployments.get" # Some random permission here
bind_sa_with_role


# LAUNCH TESTS
if [ "$DEPLOYMENTMANAGER_VM" ]; then
    bash ./tests/1-deploymentmanager.deployments.create.sh
fi

if [ "$IAMROLESUPDATE" ]; then
    bash ./tests/2-iam.roles.update.sh
fi

if [ "$IAMSERVICEACCOUNTKEYSCREATE" ]; then
    bash ./tests/3-iam.serviceAccountKeys.create.sh
fi

if [ "$IAMGETACCESSTOKEN" ]; then
    bash ./tests/4-iam.serviceAccounts.getAccessToken.sh
fi


# CLEAN ENVIRONMENT

delete_role
#for role in $(gcloud projects get-iam-policy "$PROJECT_ID" | grep -A2 securitytest | grep "role:" | cut -d ":" -f 2 | cut -d " " -f 2 | cut -d "/" -f 4); do
#    delete_role $role
#done

if [ "$RM_SA" ]; then
    #delete_sa
    #delete_sa $ATTACK_SA
    echo "finish"
fi
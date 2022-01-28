#!/bin/bash

# ARGS

HELP="Use:
    -n Do not delete the test service account
    -1 for deploymentmanager.deployments.create new VM abuse
    -2 for iam.roles.update abuse
    -3 for iam.serviceAccountKeys.create abuse
    -4 for iam.serviceAccounts.getAccessToken abuse
    -5 for iam.serviceAccounts.implicitDelegation abuse
    -6 for iam.serviceAccounts.signBlob abuse
    -7 for iam.serviceAccounts.signJwt abuse
    -9 for serviceusage.apiKeys.create abuse
    -a for serviceusage.apiKeys.list abuse
    -b for apikeys.keys.create abuse
    -c for apikeys.keys.getKeyString abuse
    -d for iam.serviceAccounts.setIamPolicy abuse
    -e for deploymentmanager.deployments.update abuse
    -f for cloudbuild.builds.create abuse
    -g for iam.serviceAccountKeys.update abuse
"


source lib/lib.sh

RM_SA="1"


DEPLOYMENTMANAGER_VM="" #-1
IAMROLESUPDATE="" #-2
IAMSERVICEACCOUNTKEYSCREATE="" #-3
IAMGETACCESSTOKEN="" #-4
IAMIMPLICITDELEGATION="" #-5
IAMSIGNBLOB="" #-6
IAMSIGNJWT="" #-7
IAMGETOPENIDTOKEN="" #-8
SERVICEUSAGEAPIKEYSCREATE="" #-9
SERVICEUSAGEAPIKEYSLIST="" #-9
APIKEYCREATE="" #-b
APIKEYLIST="" #-c
IAMSETIAMPOLICY="" #-d
DEPLOYMENTMANAGERUPDATE="" #-e
CLOUDBUILDCREATE="" #-f
SERVICEACCOUNTSKEYSUPDATE="" #-g

while getopts "h?n123456789abcdefg" opt; do
  case "$opt" in
    h|\?) printf "%s\n\n" "$HELP"; exit 0;;
    n)  RM_SA="";;
    1)  DEPLOYMENTMANAGER_VM="1";;
    2)  IAMROLESUPDATE="1";;
    3)  IAMSERVICEACCOUNTKEYSCREATE="1";;
    4)  IAMGETACCESSTOKEN="1";;
    5)  IAMIMPLICITDELEGATION="1";;
    6)  IAMSIGNBLOB="1";;
    7)  IAMSIGNJWT="1";;
    8)  IAMGETOPENIDTOKEN="1";;
    9)  SERVICEUSAGEAPIKEYSCREATE="1";;
    a)  SERVICEUSAGEAPIKEYSLIST="1";;
    b)  APIKEYCREATE="1";;
    c)  APIKEYLIST="1";;
    d)  IAMSETIAMPOLICY="1";;
    e)  DEPLOYMENTMANAGERUPDATE="1";;
    f)  CLOUDBUILDCREATE="1";;
    g)  SERVICEACCOUNTSKEYSUPDATE="1";;
    esac
done


# PREPARE ENVIRONMENT

export ATTACK_SA="attackedsa"
export PROJECT_ID=$(gcloud config list 2>/dev/null | grep "project =" | head -n1 | cut -d " " -f 3)
export ROLE_NAME=$(openssl rand -hex 12)
#export SERVICE_ACCOUNT_ID="testing$(openssl rand -hex 10)" #Must start with lowercase
export SERVICE_ACCOUNT_ID="securitytest1234"
export CURRENT_USER_EMAIL=$(gcloud config list 2>/dev/null | grep @ | head -n1 | cut -d " " -f 3)

create_one_sa "$ATTACK_SA"
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

if [ "$IAMIMPLICITDELEGATION" ]; then
    bash ./tests/5-iam.serviceAccounts.implicitDelegation.sh
fi

if [ "$IAMSIGNBLOB" ]; then
    bash ./tests/6-iam.serviceAccounts.signBlob.sh
fi

if [ "$IAMSIGNJWT" ]; then
    bash ./tests/7-iam.serviceAccounts.signJWT.sh
fi

#if [ "$IAMGETOPENIDTOKEN" ]; then
#    bash ./tests/8-iam.serviceAccounts.getOpenIdToken.sh
#fi

if [ "$SERVICEUSAGEAPIKEYSCREATE" ]; then
    bash ./tests/9-serviceusage.apiKeys.create.sh
fi

if [ "$SERVICEUSAGEAPIKEYSLIST" ]; then
    bash ./tests/a-serviceusage.apiKeys.list.sh
fi

if [ "$APIKEYCREATE" ]; then
    bash ./tests/b-apikeys.keys.create.sh
fi

if [ "$APIKEYLIST" ]; then
    bash ./tests/c-apikeys.keys.getKeyString.sh
fi

if [ "$IAMSETIAMPOLICY" ]; then
    bash ./tests/d-iam.serviceAccounts.setIamPolicy.sh
fi

if [ "$DEPLOYMENTMANAGERUPDATE" ]; then
    bash ./tests/e-deploymentmanager.deployments.update.sh
fi

if [ "$CLOUDBUILDCREATE" ]; then
    bash ./tests/f-cloudbuild.builds.create.sh
fi

if [ "$SERVICEACCOUNTSKEYSUPDATE" ]; then
    bash ./tests/g-iam.serviceAccountKeys.update.sh
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
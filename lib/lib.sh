#!/bin/bash

create_one_sa (){
    if ! gcloud iam service-accounts list | grep -q "$1@"; then
        echo "Creating SA: $1"
        gcloud iam service-accounts create "$1" \
            --description="Service account to test permissions" \
            --display-name="$1"
    fi
}

create_sa (){
    if ! gcloud iam service-accounts list | grep -q "$SERVICE_ACCOUNT_ID@"; then
        echo "Creating SA: $SERVICE_ACCOUNT_ID"
        gcloud iam service-accounts create "$SERVICE_ACCOUNT_ID" \
            --description="Service account to test permissions" \
            --display-name="$SERVICE_ACCOUNT_ID"
        
        gcloud iam service-accounts add-iam-policy-binding \
            "${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
            --member="user:$CURRENT_USER_EMAIL" \
            --role="roles/iam.serviceAccountUser"

        gcloud iam service-accounts add-iam-policy-binding \
            "${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
            --member="user:$CURRENT_USER_EMAIL" \
            --role="roles/iam.serviceAccountTokenCreator"
        
        echo "Sleeping 80s till the new role is applied to the new SA"
        sleep 80
    fi
}

create_role (){
    TO_CREATE="$ROLE_NAME"
    if [ "$2" ]; then
        TO_CREATE="$2"
    fi

    echo "Creating Role: $TO_CREATE"
    gcloud iam roles create "$TO_CREATE" --project="$PROJECT_ID" \
        --title="Test Perms" --description="Role to tst permissions" \
        --permissions="$1" --stage="beta"
    echo ""
}

bind_sa_with_role (){
    SA_ID="$SERVICE_ACCOUNT_ID"
    ROLE="$ROLE_NAME"
    if [ "$1" ]; then
       SA_ID="$1" 
    fi
    if [ "$2" ]; then
       ROLE="$2"
    fi
    echo "Binding SA with Role"
    gcloud projects add-iam-policy-binding "$PROJECT_ID" \
        --member="serviceAccount:${SA_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
        --role="projects/${PROJECT_ID}/roles/${ROLE}"
    echo ""
}


modify_role (){
    echo "Modifying Role: $ROLE_NAME"
    echo "Y" | gcloud iam roles update "$ROLE_NAME" --project="$PROJECT_ID" \
        --permissions="$1"
    echo ""
}


describe_role (){
    echo "Describing Role: $ROLE_NAME"
    gcloud iam roles describe "$ROLE_NAME" --project="$PROJECT_ID"
    echo ""
}


delete_role (){
    ROLE_TO_DELETE=$ROLE_NAME
    if [ "$1" ]; then
        ROLE_TO_DELETE=$1
    fi

    echo "Deleting Role: $ROLE_TO_DELETE"
    gcloud iam roles delete "$ROLE_TO_DELETE" --project="$PROJECT_ID"
    echo ""
}


delete_sa (){
    TO_DELETE=$SERVICE_ACCOUNT_ID
    if [ "$1" ]; then
        TO_DELETE="$1"
    fi
    echo "Deleting SA: $TO_DELETE"
    echo "Y" | gcloud iam service-accounts delete "${TO_DELETE}@${PROJECT_ID}.iam.gserviceaccount.com"
    echo ""
}

enable_service (){
    export WAS_ENABLED="1"
    if ! gcloud services list | grep -q "$1"; then
        echo "Enabling $1"
        gcloud services enable "$1"
        export WAS_ENABLED=""
    fi
}

disable_service (){
    if gcloud services list | grep -q "$1"; then
        if ! [ "$WAS_ENABLED" ]; then 
            echo "Disabling $1"
            gcloud services disable "$1"
        fi
    fi
}
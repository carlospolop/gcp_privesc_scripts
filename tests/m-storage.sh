#!/bin/bash

source lib/lib.sh


echo "================================================"
echo "Checking storage.objects.get,storage.objects.list"

#enable_service "container.googleapis.com"


modify_role "storage.objects.get,storage.objects.list"




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

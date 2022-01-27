#!/bin/bash

source lib/lib.sh

echo "================================================"
echo "Checking cloudbuild.builds.create"


modify_role "cloudbuild.builds.create"




# Cleaning
echo "Execute ./tests/f-cloudbuild.builds.create.py to get a reverse shell inside the build and steal the SA token (you may need to install python libraries)"
read -p "Press any key to delete scenario... " -n1 -s
echo ""

disable_service "apikeys.googleapis.com"

echo "================================================"

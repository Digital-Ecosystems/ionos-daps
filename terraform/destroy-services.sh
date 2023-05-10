#!/bin/bash

if [ -z `printenv TF_VAR_domain` ]; then
    echo "Stopping because TF_VAR_domain is undefined"
    exit 1
fi

cd terraform

# This script is used to destroy the cloud landscape for the daps services.
terraform init && terraform refresh && terraform plan && terraform destroy -auto-approve

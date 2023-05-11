#!/bin/bash

# This script generates a configuration file for the OmejdN DAPS

# Check if TF_VAR_domain is set

if [ -z "$TF_VAR_domain" ]; then
    echo "TF_VAR_domain is not set. Please set it to the domain name of the DAPS server."
    exit 1
fi

mkdir -p ./config

for file in ./config-templates/*; do
    filename=$(basename $file)
    sed "s/daps.example.com/daps.$TF_VAR_domain/g" $file > ./config/$filename
done

echo "Configuration files generated successfully."
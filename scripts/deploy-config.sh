#!/bin/bash

set -e

if [ -z `printenv KUBECONFIG` ]; then
    echo "Stopping because KUBECONFIG is undefined"
    exit 1
fi

# Get omejdn-server pod name
OMEJDN_SERVER_POD_NAME=$(kubectl get pods --namespace omejdn-daps -l "app.kubernetes.io/name=omejdn-server,app.kubernetes.io/instance=omejdn-server" -o jsonpath="{.items[0].metadata.name}")

# Copy the config directory to the omejdn-server pod
kubectl cp --namespace omejdn-daps ./config $OMEJDN_SERVER_POD_NAME:/opt/

echo "Successfully copied config directory to omejdn-server pod"
***
# DAPS deployment

This document describes how to deploy the DAPS on IONOS DCD.

All commands paths are relative to the current directory where this readme is located.

***
These are the services that are deployed:

- [DAPS-server](https://github.com/Fraunhofer-AISEC/omejdn-server/tree/master): DAPS backend.
- [DAPS-UI](https://github.com/Fraunhofer-AISEC/omejdn-ui/tree/main): DAPS user interface.

***


## Requirements

Before you start deploying the DAPS, make sure you meet the requirements:
- Kubernetes cluster with installed **cert-manager**, **NGINX ingress**, and **external-dns**
- Terraform
- kubectl
- Docker
- Helm
- DNS server and domain name
- jq

***
## Deploy


### 1. Create Kubernetes cluster

Follow [these instructions](https://github.com/Digital-Ecosystems/ionos-kubernetes-cluster) to create Kubernetes cluster with installed **cert-manager**, **NGINX ingress**, and optionally **external-dns**.

### 2. Configuration

Set environment variables


```sh
# copy .env-template to .env and set the values of the required parameters
cp .env-template .env

# load the configuration
source .env
```

### 3. Install the DAPS services

To install DAPS services, run the script `install-services.sh` located in the `terraform` directory.

```sh
# Install DAPS
./terraform/install-services.sh

# Generate the configuration from the ./config-template directory and store it in the ./config directory
./scripts/generate-config.sh

# Deploy the configuration from the ./config directory
./scripts/deploy-config.sh
```

### 4. Retrieve the `token_endpoint` and `jwks_uri` from the metadata URL
This step autogenerates the server private key. Run the following command:

```sh
OMEJDN_NGINX_POD_NAME=$(kubectl get pods --namespace omejdn-daps -l "app.kubernetes.io/name=omejdn-nginx,app.kubernetes.io/instance=omejdn-nginx" -o jsonpath="{.items[0].metadata.name}")
kubectl exec -it $OMEJDN_NGINX_POD_NAME --namespace omejdn-daps -- curl http://localhost/.well-known/oauth-authorization-server/auth|jq '.token_endpoint, .jwks_uri'
```

### 5. Get the DAPS URL
Run the following command to get the DAPS URL:

```sh
DAPS_HOSTNAME=$(kubectl get ingress -n omejdn-daps omejdn-nginx -o jsonpath='{.spec.rules[0].host}')
echo "DAPS URL: https://$DAPS_HOSTNAME"
```

You can login with testUser:mypassword

Make sure login works and that a valid TLS certificate has been issued.

### Registering Connectors

To register a new connector, run the `register-connector.sh` script located in the `./scripts` folder. This script creates the `clients.yml` file, certificates, and a keystore. After that, it uploads the client configuration and certificates to the DAPS server pod.

You need to change the `<connector-name>` and `<keystore-password>` parameters in the command. Choose any name for your connector, as long as it hasn't already been used by another connector. After running the script, it will output the client ID and the base64 encoded keystore, which you need to add to the connector configuration.

```sh
./scripts/register-connector.sh <CONNECTOR_NAME> <KEYSTORE_PASSWORD> <SECURITY_PROFILE> <CERTIFICATE_FILE>
```
The `SECURITY_PROFILE` and `CERTIFICATE_FILE` arguments are optional.


### References

Documentation for the [IONOS Cloud API](https://api.ionos.com/docs/)  
Documentation for the [IONOSCLOUD Terraform provider](https://registry.terraform.io/providers/ionos-cloud/ionoscloud/latest/docs/)   

### Uninstall

To remove the DAPS services, run the script `destroy-services.sh` located in the `terraform` directory.

```sh
# Destroy DAPS
./terraform/destroy-services.sh
```

#!/bin/bash

# Check if required packages are available
docker --version
if [ $? -eq 0 ]
then
  echo "docker package is available."
else
  echo "docker package is not  available."
  exit
fi

# Check if environment variables are set
if [ -z "${REGISTRY_HOST}" ];
then
  echo "Environment variable REGISTRY_HOST is not set."
  exit
fi
if [ -z "${DESIRED_TAG}" ];
then
  echo "Environment variable DESIRED_TAG is not set."
  exit
fi
if [ -z "${TOKEN_USERNAME}" ];
then
  echo "Environment variable TOKEN_USERNAME is not set."
  exit
fi
if [ -z "${TOKEN_PASSWORD}" ];
then
  echo "Environment variable TOKEN_PASSWORD is not set."
  exit
fi

./prepare.sh

# Build docker images
sudo docker build -t ${REGISTRY_HOST}/omejdn-server:${DESIRED_TAG} -f omejdn-server/Dockerfile temp/omejdn-server/
sudo docker build -t ${REGISTRY_HOST}/omejdn-ui:${DESIRED_TAG} -f omejdn-ui/Dockerfile temp/omejdn-ui/

# Push new docker images
sudo docker login -u ${TOKEN_USERNAME} -p ${TOKEN_PASSWORD} ${REGISTRY_HOST}

sudo docker push ${REGISTRY_HOST}/omejdn-server:${DESIRED_TAG}
sudo docker push ${REGISTRY_HOST}/omejdn-ui:${DESIRED_TAG}
#!/bin/bash

# Check if required packages are available
git --version
if [ $? -eq 0 ]
then
  echo "git package is available."
else
  echo "git package is not  available."
  exit
fi

# Clone code repository in temporary directory
mkdir temp
git clone https://github.com/International-Data-Spaces-Association/omejdn-daps ./temp --recurse-submodules


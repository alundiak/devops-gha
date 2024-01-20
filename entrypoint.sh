#!/bin/bash

echo "Hello Entry Point"

node --version
npm --version

# 
# This will keep the script running
# And as result Docker container will also be running till the kill process.
# 
# while true; do
#   sleep 3600
# done

#!/bin/sh -l

uname -a
echo "Ubuntu says Hello to Entry Point"

# Works only this way on 'FROM ubuntu' (v22.04)
cat /etc/lsb-release

# 
# This will keep the script running
# And as result Docker container will also be running till the kill process.
# 
# while true; do
#   sleep 3600
# done

# 777

#!/bin/bash

docker-machine rm -y  $(docker-machine ls |grep -v NAME|awk '{print $1}')

exit 0

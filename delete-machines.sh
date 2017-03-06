#!/bin/bash
machines=$(docker-machine ls |grep -v NAME|awk '{print $1}')
[ ! -z "${machines}" ] &&  docker-machine rm -y  ${machines}
[ -z "${machines}" ] && echo -e "\033[1mNothing to do!\033[0m"
exit 0

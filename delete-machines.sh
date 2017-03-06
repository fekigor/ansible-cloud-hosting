#!/bin/bash
machines=$(docker-machine ls |grep -v NAME|awk '{print $1}')
if [ ! -z "${machines}" ]; then
	docker-machine rm -y  ${machines}
	if [ -s exportfile ]; then
		cat exportfile|cut -f 1 -d"="|sed -e 's/^export/unset/g' > unsetfile
		echo -e "\033[1m# Run this command to configure your shell: \033[0m"
		echo "# eval \$(cat ./unsetfile)"
	fi 
fi
if [ -z "${machines}" ]; then  
	echo -e "\033[1mNothing to do!\033[0m"
fi
exit 0

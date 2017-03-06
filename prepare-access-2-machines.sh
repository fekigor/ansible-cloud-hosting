#!/bin/bash

export PUBLIC_KEY="/root/.ssh/id_rsa.pub"
machines=$(docker-machine ls |grep -v NAME|awk '{print $1}')
if [ ! -z "${machines}" ]; then

	echo -e "\033[1mRemoves known_hosts ...\033[0m"
		ssh-keygen -f "/root/.ssh/known_hosts" -R "${server1_ip}"
		sleep 1
		echo "Unset server2_ip variable ${server2_ip} ..."
		ssh-keygen -f "/root/.ssh/known_hosts" -R "${server2_ip}"
		sleep 1
		echo "Unset server3_ip variable ${server3_ip} ..."
		ssh-keygen -f "/root/.ssh/known_hosts" -R "${server3_ip}"
	echo -e "Removes are \033[1mDONE\033[1m"


	echo -e "\033[1mUnset\033[0m variables: \033[1mserverX_ip serverX_cert\033[0m ..."

	if [ -s exportfile ]; then
		cat exportfile|cut -f 1 -d"="|sed -e 's/^export/unset/g' > unsetfile
		[ -s unsetfile ] && eval $(cat ./unsetfile)
	else
		echo -e "\033[1mUnset variables ...\033[0m"
		echo "Unset variables: server1_ip server1_cert ..."
		unset server1_ip server1_cert
		echo "Unset variables: server1_ip server1_cert ..."
		unset server2_ip server2_cert
		echo "Unset variables: server1_ip server1_cert ..."
		unset server3_ip server3_cert
		
	fi 
	rm exportfile unsetfile
	
	echo -e "Unsets are \033[1mDONE\033[0m"


	echo -e "\033[1mSets new values for server1...\033[0m"
	export $(docker-machine env server1 |grep NAME|cut -f 2 -d"="|tr -d \")_ip=$(docker-machine env server1 |grep HOST|cut -f 3 -d"/"|cut -f 1 -d":")
	export $(docker-machine env server1 |grep NAME|cut -f 2 -d"="|tr -d \")_cert=$(docker-machine env server1 |grep CERT|cut -f 2 -d"="|tr -d \")/id_rsa
	echo "Server1: IP ${server1_ip} || CERT - ${server1_cert}"
	echo -e "\033[1mSets new values for server2...\033[0m"
	export $(docker-machine env server2 |grep NAME|cut -f 2 -d"="|tr -d \")_ip=$(docker-machine env server2 |grep HOST|cut -f 3 -d"/"|cut -f 1 -d":")
	export $(docker-machine env server2 |grep NAME|cut -f 2 -d"="|tr -d \")_cert=$(docker-machine env server2 |grep CERT|cut -f 2 -d"="|tr -d \")/id_rsa
	echo "Server2: IP ${server2_ip} || CERT - ${server2_cert}"
	echo -e "\033[1mSets new values for server3...\033[0m"
	export $(docker-machine env server3 |grep NAME|cut -f 2 -d"="|tr -d \")_ip=$(docker-machine env server3 |grep HOST|cut -f 3 -d"/"|cut -f 1 -d":")
	export $(docker-machine env server3 |grep NAME|cut -f 2 -d"="|tr -d \")_cert=$(docker-machine env server3 |grep CERT|cut -f 2 -d"="|tr -d \")/id_rsa
	echo "Server3: IP ${server3_ip} || CERT - ${server3_cert}"
	echo -e "Sets are \033[1mDONE\033[0m"
	
	
	echo -e "\033[1mCopying\033[0m id_rsa.pub to server1 ..."
	echo -e "\033[1m At this step you may input YES to continue ...\033[0m"
	scp -i ${server1_cert} ${PUBLIC_KEY} root@${server1_ip}:/root/
	echo "Adding id_rsa.pub to server1 /root/.ssh/authorized_keys ..."
	ssh -i ${server1_cert} root@${server1_ip} 'PUB=$(cat /root/id_rsa.pub|cut -f 3 -d" "); (grep -n ${PUB} /root/.ssh/authorized_keys) || cat /root/id_rsa.pub >> /root/.ssh/authorized_keys;rm /root/id_rsa.pub;'
	echo -e "\033[1mCopying\033[0m id_rsa.pub to server2 ..."
	echo -e "\033[1m At this step you may input YES to continue ...\033[0m"
	scp -i ${server2_cert} ${PUBLIC_KEY} root@${server2_ip}:/root/
	echo "Adding id_rsa.pub to server2 /root/.ssh/authorized_keys ..."
	ssh -i ${server2_cert} root@${server2_ip} 'PUB=$(cat /root/id_rsa.pub|cut -f 3 -d" "); (grep -n ${PUB} /root/.ssh/authorized_keys) || cat /root/id_rsa.pub >> /root/.ssh/authorized_keys;rm /root/id_rsa.pub;'
	echo -e "\033[1mCopying\033[0m id_rsa.pub to server3 ..."
	echo -e "\033[1m At this step you may input YES to continue ...\033[0m"
	scp -i ${server3_cert} ${PUBLIC_KEY} root@${server3_ip}:/root/
	echo "Adding id_rsa.pub to server3 /root/.ssh/authorized_keys ..."
	ssh -i ${server3_cert} root@${server3_ip} 'PUB=$(cat /root/id_rsa.pub|cut -f 3 -d" "); (grep -n ${PUB} /root/.ssh/authorized_keys) || cat /root/id_rsa.pub >> /root/.ssh/authorized_keys;rm /root/id_rsa.pub;'
	
	echo -e "Prepare access is \033[1mDONE\033[0m"
	
	echo "export server1_ip=${server1_ip}" > exportfile
	echo "export server1_cert=${server1_cert}" >> exportfile
	echo "export server2_ip=${server2_ip}" >> exportfile
	echo "export server2_cert=${server2_cert}" >> exportfile
	echo "export server3_ip=${server3_ip}" >> exportfile
	echo "export server3_cert=${server3_cert}" >> exportfile
	echo -e "\n\n\033[1m####################################################################\033[0m"
	echo -e "\n\033[1m# Run this command to configure your shell: \033[0m"
	echo -e "\033[1m# eval \$(cat ./exportfile)\033[0m"
	echo -e "\n\033[1m####################################################################\033[0m"
	echo -e "\n\nNow you can try ssh connect to remote servers:\n\033[1m# ssh \${server1_ip}\033[0m"
	echo -e "\n\033[1m####################################################################\033[0m"
else
	echo -e "\033[1mRemote server's are not READY!\033[0m\nRun this command to create remote servers on DigitalOcean:\n# \033[1mmake create-machines\033[0m"
fi
	
exit 0

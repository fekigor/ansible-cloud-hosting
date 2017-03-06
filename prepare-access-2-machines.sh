#!/bin/bash
export PUBLIC_KEY="/root/.ssh/id_rsa.pub"

echo "Unset server1_ip variable ${server1_ip} ..."
	ssh-keygen -f "/root/.ssh/known_hosts" -R "${server1_ip}"
unset server1_ip
sleep 1
echo "Unset server2_ip variable ${server2_ip} ..."
	ssh-keygen -f "/root/.ssh/known_hosts" -R "${server2_ip}"
unset server2_ip
sleep 1
echo "Unset server3_ip variable ${server3_ip} ..."
	ssh-keygen -f "/root/.ssh/known_hosts" -R ${server3_ip}
unset server3_ip
echo "Unsets done"


echo "Unset server1_cert variable ..."
unset $(docker-machine env server1 |grep NAME|cut -f 2 -d"="|tr -d \")_cert
echo "Unset server2_cert variable ..."
unset $(docker-machine env server2 |grep NAME|cut -f 2 -d"="|tr -d \")_cert
echo "Unset server3_cert variable ..."
unset $(docker-machine env server3 |grep NAME|cut -f 2 -d"="|tr -d \")_cert
echo "Unsets done"


echo "Sets new values for server1..."
export $(docker-machine env server1 |grep NAME|cut -f 2 -d"="|tr -d \")_ip=$(docker-machine env server1 |grep HOST|cut -f 3 -d"/"|cut -f 1 -d":")
export $(docker-machine env server1 |grep NAME|cut -f 2 -d"="|tr -d \")_cert=$(docker-machine env server1 |grep CERT|cut -f 2 -d"="|tr -d \")/id_rsa
echo "Server1: IP ${server1_ip} || CERT - ${server1_cert}"
echo "Sets new values for server2..."
export $(docker-machine env server2 |grep NAME|cut -f 2 -d"="|tr -d \")_ip=$(docker-machine env server2 |grep HOST|cut -f 3 -d"/"|cut -f 1 -d":")
export $(docker-machine env server2 |grep NAME|cut -f 2 -d"="|tr -d \")_cert=$(docker-machine env server2 |grep CERT|cut -f 2 -d"="|tr -d \")/id_rsa
echo "Server2: IP ${server2_ip} || CERT - ${server2_cert}"
echo "Sets new values for server3..."
export $(docker-machine env server3 |grep NAME|cut -f 2 -d"="|tr -d \")_ip=$(docker-machine env server3 |grep HOST|cut -f 3 -d"/"|cut -f 1 -d":")
export $(docker-machine env server3 |grep NAME|cut -f 2 -d"="|tr -d \")_cert=$(docker-machine env server3 |grep CERT|cut -f 2 -d"="|tr -d \")/id_rsa
echo "Server3: IP ${server3_ip} || CERT - ${server3_cert}"
echo "Sets DONE"


echo "Copying id_rsa.pub to server1 ..."
scp -i ${server1_cert} ${PUBLIC_KEY} root@${server1_ip}:/root/
echo "Adding id_rsa.pub to server1 /root/.ssh/authorized_keys ..."
ssh -i ${server1_cert} root@${server1_ip} 'cat ~/id_rsa.pub >> /root/.ssh/authorized_keys;rm ~/id_rsa.pub'
echo "Copying id_rsa.pub to server2 ..."
scp -i ${server2_cert} ${PUBLIC_KEY} root@${server2_ip}:/root/
echo "Adding id_rsa.pub to server2 /root/.ssh/authorized_keys ..."
ssh -i ${server2_cert} root@${server2_ip} 'cat ~/id_rsa.pub >> /root/.ssh/authorized_keys;rm ~/id_rsa.pub'
echo "Copying id_rsa.pub to server3 ..."
scp -i ${server3_cert} ${PUBLIC_KEY} root@${server3_ip}:/root/
echo "Adding id_rsa.pub to server3 /root/.ssh/authorized_keys ..."
ssh -i ${server3_cert} root@${server3_ip} 'cat ~/id_rsa.pub >> /root/.ssh/authorized_keys;rm ~/id_rsa.pub'

echo "Prepare access DONE"

echo "export server1_ip=${server1_ip}" > exportfile
echo "export server1_cert=${server1_cert}" >> exportfile
echo "export server2_ip=${server2_ip}" >> exportfile
echo "export server2_cert=${server2_cert}" >> exportfile
echo "export server3_ip=${server3_ip}" >> exportfile
echo "export server3_cert=${server3_cert}" >> exportfile
echo "# Run this command to configure your shell: "
echo "# eval \$(cat ./exportfile)"

exit 0

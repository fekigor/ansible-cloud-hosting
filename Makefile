#
# Tasks Makefile
# ==============
#
# Shortcuts for various tasks.
#

PRIVATE_KEY=~/.ssh/id_rsa
SWARM_IP=192.168.1.1:8000

delete-machines:
	@(/bin/bash delete-machines.sh)

create-machines:
	@(/bin/bash create-machines.sh)

prepare-access-2-machines:
	@(/bin/bash prepare-access-2-machines.sh)

first-run:
	@(ansible-playbook -i stage site.yml -u root --private-key $(PRIVATE_KEY))

run:
	@(ansible-playbook -i stage site.yml -u support -s -K --private-key $(PRIVATE_KEY))

setup:
	@(ansible cloud -i stage -u support -m setup --private-key $(PRIVATE_KEY))

ping:
	@(ansible all -i stage -m ping -u support)

tasks:
	@(ansible-playbook -i stage site.yml --list-tasks)

hosts:
	@(ansible-playbook -i stage site.yml --list-hosts)

gen-ca:
	@(mkdir -p certs/ca)
	@(openssl genrsa -aes256 -out certs/ca/ca-key.pem 4096)
	@(openssl req -new -x509 -days 365 -key certs/ca/ca-key.pem -sha256 -out certs/ca/ca.pem)

swarm:
	@(docker -H tcp://$(SWARM_IP) --tlsverify=true --tlscacert=certs/ca/ca.pem --tlscert=certs/docker/cert.pem --tlskey=certs/docker/key.pem info)

#!/usr/bin/env bash

#TODO convert this script to task runner and use bootstrap file to install task runner.

# Remove leading and trailing whitespace chars.
trim() {
    local var=$@
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

init() {
	PROJECT_ROOT=$(cd `dirname ${0}`; pwd)
	DEVOPS_DIR_NAME=devops
}

initGit() {
	git init	
}

# Clone devops-starter as a submodule.
installDevops() {
	git submodule add https://github.com/mtbvang/devops-starter.git devops

	git submodule update --init --recursive
	
	git submodule foreach --recursive git pull origin master	
}

# Copy over Vagrantfile template and do substitutioins.
setupVagrantFile() {
	cd ${PROJECT_ROOT}
	cp devops/vagrant/Vagrantfile.node.template Vagrantfile
	sed -i "s/<projectName>/${PROJECT_NAME}/g" Vagrantfile
	sed -i "s/<portOffset>/${PORT_OFFSET}/g" Vagrantfile
	sed -i "s/<guestAppPort>/${GUEST_APP_PORT}/g" Vagrantfile
	sed -i "s+<dotfilesDir>+${DEVOPS_DIR_NAME}/dotfiles+g" Vagrantfile
	sed -i "s+<vagrantDir>+${DEVOPS_DIR_NAME}/vagrant+g" Vagrantfile
	sed -i "s+<provisioningDir>+${DEVOPS_DIR_NAME}/provisioning+g" Vagrantfile
}

runConsul() {
	CONSUL_RUNNING=$(docker ps -a | grep consul)
	echo "CONSUL_RUNNING=${CONSUL_RUNNING}"
	if [ "" == "$CONSUL_RUNNING" ]; then
		echo "Consul container not installed. Installing."
		docker run -d -h node1 --name consul  -p 8300:8300  -p 8301:8301  -p 8301:8301/udp  -p 8302:8302  -p 8302:8302/udp  -p 8400:8400  -p 8500:8500  -p 172.17.42.1:53:53/udp  progrium/consul -server -bootstrap -ui-dir /ui
	else 
		echo -e "Consul already install:\n ${CONSUL_RUNNING}"
	fi 
	
	
}


PROJECT_NAME=$(trim ${1:-app})
PORT_OFFSET=$(trim ${2:-0})
GUEST_APP_PORT=$(trim ${3:-1337})

init
initGit
installDevops
setupVagrantFile
runConsul

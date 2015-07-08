#!/usr/bin/env bash

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
	DEVOPS_DIR=${DEVOPS_DIR_NAME}/devops
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
	cp devops/vagrant/Vagrantfile.template Vagrantfile
	sed -i "s/<projectName>/${PROJECT_NAME}/g" Vagrantfile
	sed -i "s/<portOffset>/${PORT_OFFSET}/g" Vagrantfile
	sed -i "s/<guestAppPort>/${GUEST_APP_PORT}/g" Vagrantfile
	sed -i "s+<dotfilesDir>+${DEVOPS_DIR}/dotfiles+g" Vagrantfile
	sed -i "s+<vagrantDir>+${DEVOPS_DIR}/vagrant+g" Vagrantfile
	sed -i "s+<provisioningDir>+${DEVOPS_DIR}/provisioning+g" Vagrantfile
}

initGit() {
	git init	
}

PROJECT_NAME=$(trim ${1:-app})
PORT_OFFSET=$(trim ${2:-0})
GUEST_APP_PORT=$(trim ${3:-1337})

init
initGit
installDevops
setupVagrantFile

#!/usr/bin/env bash

# Remove leading and trailing whitespace chars.
trim() {
    local var=$@
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}


installDevops() {
	git submodule add https://github.com/mtbvang/devops-starter.git devops

	git submodule update --init --recursive
	
	git submodule foreach --recursive git pull origin master
	
	cd devops/vagrant && git checkout split-containers
	
	
}

setupVagrantFile() {
	cp devops/vagrant/Vagrantfile.template Vagrantfile
	#sed -i 's/<projectName>/${PROJECT_NAME}/g' Vagrantfile
}

initGit() {
	git init	
}

PROJECT_NAME=$(trim ${1:-app})
PORT_OFFSET=$(trim ${2:-0})
GUEST_APP_PORT=$(trim ${3:-1337})

initGit
installDevops
setupVagrantFile

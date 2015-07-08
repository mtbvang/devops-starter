#!/usr/bin/env bash

# Remove leading and trailing whitespace chars.

init() {
	apt-get update
	apt-get install -yq wget unzip	
}

trim() {
    local var=$@
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}


installConsul () {
	
	SERVICE=consul
	if ps ax | grep -v grep | grep -v $0 | grep $SERVICE > /dev/null
	then
	    echo "$SERVICE service running, everything is fine"
	else
	    echo "$SERVICE is not running"
	    wget https://dl.bintray.com/mitchellh/consul/${CONSUL_VERSION}_linux_amd64.zip	
		unzip -o ${CONSUL_VERSION}_linux_amd64.zip -d /usr/local/bin
		apt-get install -yq psmisc
		
		# Install System V service scripts and start agent
		cp /vagrant/vagrant/provision/ubuntu/consulagent /etc/init.d/	
		chmod 755 /etc/init.d/consulagent
		update-rc.d consulagent defaults
		service consulagent start	
	fi

}

joinConsul () {
	sleep 5
	consul join 172.17.42.1
}

CONSUL_VERSION=$(trim ${1:-0.5.0})

init
installConsul
joinConsul

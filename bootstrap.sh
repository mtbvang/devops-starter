#!/usr/bin/env bash

# Remove leading and trailing whitespace chars.
trim() {
    local var=$@
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

init() {
	sudo apt-get update
	sudo apt-get install -yq curl python python3
}

# Install npm if it isn't
installNPM() {
	
	if ! app_installed="$(type -p "npm")" || [ -z "$app_installed" ]; then
		echo "npm not installed. Installing."
		sudo apt-get install -yq npm 
	else
		echo -e "npm already install. $(npm --version)"
	fi
	
}

installGulp() {
	if ! app_installed="$(type -p "gulp")" || [ -z npm"$app_installed" ]; then
		echo "gulp not installed. Installing."
		sudo npm install --global gulp 			
	else
		echo -e "gulp already installed globally."
	fi
	echo -e "Install local npm packages. $(gulp --version)"
	npm install --save gulp heroku-client
	npm install --save-dev gulp-shell@^0.4.2 \
		gulp-task-listing@^1.0.1 \
		gulp-util@^3.0.6 \
		minimist@^1.1.1 \
		run-sequence@^1.1.1 \
		node-netrc \
		array.prototype.find@^1.0.0 \
		gulp-help@^1.6.0 \
		redis-url@^1.2.0
}

downloadGulpFile() {
	curl -O https://raw.githubusercontent.com/mtbvang/devops-starter/master/templates/gulpfile.js
	SRC="projectName: '[^\t ]*'"
	DST="projectName: '${PROJECT_DIR_NAME}'"
	sed -i "s/${SRC}/${DST}/g" gulpfile.js
}

installVagrant() {
	if ! app_installed="$(type -p "vagrant")" || [ -z "$app_installed" ]; then
		echo "vagrant not installed. Installing."
		sudo apt-get install -yq vagrant 
	else
		echo -e "vagrant already install. $(vagrant --version)"
	fi
}

installDocker() {
	if ! app_installed="$(type -p "docker")" || [ -z "$app_installed" ]; then
		echo "docker not installed. Installing."
		wget -qO- https://get.docker.com/ | sh 
		sudo usermod -aG docker $USER
	else
		echo -e "docker already install. $(docker --version)"
	fi
}
PROJECT_DIR_NAME=${PWD##*/}

init
installNPM
installGulp
downloadGulpFile
installVagrant
installDocker
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
	
	if ! foobar_loc="$(type -p "npm")" || [ -z "$foobar_loc" ]; then
		echo "npm not installed. Installing."
		sudo apt-get install -yq npm 
	else
		echo -e "npm already install."
	fi
	
}

installGulp() {
	if ! foobar_loc="$(type -p "gulp")" || [ -z "$foobar_loc" ]; then
		echo "gulp not installed. Installing."
		sudo npm install --global gulp 			
	else
		echo -e "gulp already installed globally."
	fi
	echo -e "Install local npm packages."
	npm install --save gulp
	npm install --save-dev gulp-shell@^0.4.2 gulp-task-listing@^1.0.1 gulp-util@^3.0.6 minimist@^1.1.1 run-sequence@^1.1.1
}

downloadGulpFile() {
	curl -O https://raw.githubusercontent.com/mtbvang/devops-starter/master/templates/gulpfile.js
	SRC="projectName: '[^\t ]*'"
	DST="projectName: '${PROJECT_DIR_NAME}'"
	sed -i "s/${SRC}/${DST}/g" gulpfile.js
}

PROJECT_DIR_NAME=${PWD##*/}

init
installNPM
installGulp
downloadGulpFile
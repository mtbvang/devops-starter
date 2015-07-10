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
	sudo apt-get intsall -yq curl
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

npmInit() {
	npm init
	npm install --save gulp
	npm install --save-dev gulp-shell@^0.4.2 gulp-task-listing@^1.0.1 gulp-util@^3.0.6	
}

installGulp() {
	if ! foobar_loc="$(type -p "gulp")" || [ -z "$foobar_loc" ]; then
		echo "gulp not installed. Installing."
		sudo npm install --global gulp 
	else
		echo -e "gulp already install."
	fi
}

downloadGulpFile() {
	curl -O https://raw.githubusercontent.com/mtbvang/devops-starter/master/templates/gulpfile.js
}

init
installNPM
installGulp
npmInit
downloadGulpFile
#!/usr/bin/env bash

trim() {
    local var=$@
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

USER=$(trim ${1:-vagrant})

echo "Provisiong dotfiles for user: $USER"

cp /vagrant/vagrant/provision/ubuntu/bash_completion /usr/share/bash-completion/bash_completion
cp /vagrant/vagrant/provision/ubuntu/.bash_aliases /home/$USER/.bash_aliases
cp /vagrant/vagrant/provision/ubuntu/.bashrc /home/$USER/.bashrc
cp /vagrant/vagrant/provision/debian/.profile /home/$USER/.profile

chown -R $USER: /home/$USER/

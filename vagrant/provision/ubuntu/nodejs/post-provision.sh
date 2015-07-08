#!/usr/bin/env bash

apt-get install -y gcc make build-essential
cd /vagrant
npm install
cp -f /vagrant/vagrant/provision/ubuntu/nodejs/index.js /vagrant/node_modules/mongoose/node_modules/mongodb/node_modules/bson/ext
cd /vagrant/node_modules/mongodb/node_modules/bson/
npm install -g node-gyp
node-gyp rebuild

nohup mongod &
# devops-starter

A quick way to add devops related tooling to projects. 

## Getting started

Get the setup file for the kind of project you are starting. For example for node projects:

```sh
curl -O https://raw.githubusercontent.com/mtbvang/devops-starter/master/setup-node.sh
chmod +x setup-node.sh
./setup-node.sh <projectname> <portoffset>
```

'./setup-node.sh test-app 1' will result in a node application running on port 1338. Look at the setup-node.sh file for details of other arguments. 

The <portoffset> allows you to map multiple host machine ports to the one port number that the application run on on the guest container.

Start the containers.

```sh
vagrant up --no-parallel
```

Get the container names.

```sh
vagrant status
```

You can ssh into them using the names listed in the vagrant status command.

```sh
vagrant ssh <projectname>-app
```

## Creating application

After vagrant ssh'ing into the <projectname>-app container create the application project using the relevant script to scaffold out the project.

### Node (Sails, Reactjs)

The standard node stack 'm using is Sails + Reactjs. Run the setup script to scaffold the application.

```sh
cd /vagrant
```


## Git commands to work with submodules
  
```sh
git submodule add <repo path> [folder name]

git submodule update --init --recursive

git submodule foreach --recursive git fetch
git submodule foreach git merge origin master
or
git submodule foreach --recursive git pull origin master (is equivalent to a fetch and then merge)

git pull --recurse-submodules=on-demand
git push --recurse-submodules=on-demand
```


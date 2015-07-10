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

## Manually adding submodule

The setup-node.sh script runs the following commands to add this starter as a submodule.

```sh
git submodule add https://github.com/mtbvang/devops-starter.git devops
git submodule update --init --recursive
git submodule foreach --recursive git pull origin master  
```

## Creating application

After vagrant ssh'ing into the <projectname>-app container create the application project using the relevant script to scaffold out the project.

### Node (Sails, Reactjs)

The standard node stack 'm using is Sails + Reactjs. Run the setup script to scaffold the application.

```sh
cd /vagrant
```

## Working with git submodules

The submodule is it's own repo/work-area, with its own .git directory.

So, first commit/push your submodule's changes:

```sh
cd path/to/submodule
git add <stuff>
git commit -m "comment"
git push
```
Then tell your main project to track the updated version:

```sh
cd /main/project
git add path/to/submodule
git commit -m "updated my submodule"
git push
```

To push all submodules in one go from the parent repo:

```sh
git push --recurse-submodules=on-demand
```

### Git commands to work with submodules
  
```sh
git submodule add <repo path> [folder name]

git submodule update --init --recursive

git submodule foreach --recursive git fetch
git submodule foreach git merge origin master
or
git submodule foreach --recursive git pull origin master (is equivalent to a fetch and then merge)

git pull --recurse-submodules=on-demand
git push --recurse-submodules=on-demand
git submodule foreach --recursive git checkout master
```


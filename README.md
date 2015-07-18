# devops-starter

A quick way to add devops related tooling to projects. Only tested on Ubuntu 14.04.

## Getting started

### Requirements

* Ubuntu 14.04
* Vagrant 1.7.2
* Docker 1.6.2
* npm 2.7.4
* gulp 3.9.0

The bootstrap.sh file in the Up and running section should check for and install the above tools for ubuntu 14.04.

* heroku token 

Needed to deploy to heroku setup an account and get the token. 

### Up and running

Download the bootstrap script that installs npm, gulp and their required dependencies and run it using:

```sh
curl -O https://raw.githubusercontent.com/mtbvang/devops-starter/master/bootstrap.sh \
&& chmod +x bootstrap.sh \
&& ./bootstrap.sh \
&& gulp bootstrap --appType node-r --herokuToken <token>
```
Go get a coffee because it'll take a while to do the magic and the output is not being shown by gulp task.

There's a gulp task for bootstrapping a new project. Run it and pass in any parameters you want to change e.g.

```sh
gulp bootstrap --projectName exampleApp --appType node --vagrantPortOffset 0 --vagrantGuestAppPort 1337 
```

projectName: default app
appTypes: [node|node-r] default node
vagrantPortOffset: default  0
vagrantGuestAppPort: default 1337

The bootstrap script will have created a ready to run application. All that's required is to ssh into the container and sails lift the application.

```sh
vagrant ssh <projectname>-app
cd /vagrant
sails lift
```

It should now be accessible on the host via http://localhost:1337  or 1337 + vagrantPortOffset specified in the bootstrap command above.

## Manually adding submodule

The setup-node.sh script runs the following commands to add this starter as a submodule.

```sh
git submodule add https:// github.com/mtbvang/devops-starter.git devops
git submodule update --init --recursive
git submodule foreach --recursive git pull origin master
git submodule foreach --recursive git checkout master
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

To push and pull all submodules in one go . Note these commands do not pull the latest head from the origin master. They retrieve from the project that the submodules are contained.

```sh
git pull --recurse-submodules=on-demand
git submodule update --recursive
git push --recurse-submodules=on-demand
```

The next section covers pulling from the origin of the submodules.

### Pulling and pushing git submodules commits from submodule origin in projects

After cloning the repository containing your submodules, the following command will checkout the master branch of all submodules in one go. Other wise the submodules will will not be pointing to any branch.

```sh
git submodule foreach --recursive git checkout master
```

To get the latest head/commits from the submodule origin.

```sh
git submodule foreach git pull origin master
```
This is equivalent to this in git version > 1.7.3

```sh
git pull --recurse-submodules
```

Follow the pull with an update to see the pulled commits.

```sh
git submodule update --recursive
```

Git add, commit and push as normal and the submodule changes will be included.

```sh
git add .
git commit -m "example commit messaage"
git push
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

git submodule status --recursive
```




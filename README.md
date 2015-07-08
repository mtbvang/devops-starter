# devops-starter

A quick way to add devops related tooling to projects. Get the setup file for the kind of project you are starting. For example for node projects:

```sh
sudo curl -O https://raw.githubusercontent.com/mtbvang/devops-starter/master/setup-node.sh
sudo chmod +x setup-node.sh
sudo ./setup-node.sh <projectname> <portoffset>
```

'./setup-node.sh test-app 1' will result in a node application running on port 1338. Look at the setup-node.sh file for details of other arguments.

```sh
vagrant up
```

## Git commands to work with submodules

```sh
git submodule add <repo path> [folder name]

git submodule update --init --recursive

git submodule foreach --recursive git fetch
git submodule foreach git merge origin master
or
git submodule foreach --recursive git pull origin master (is equivalent to a fetch and then merge)

```


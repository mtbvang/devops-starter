# devops-starter

A quick way to add devops related tooling to projects.

Add this project as a submodule to a project. From the root of your project run:

```sh
git submodule add https://github.com/mtbvang/devops-starter.git devops

git submodule update --init --recursive

git submodule foreach --recursive git pull origin master

cd devops/vagrant && git checkout split-containers

cp devops/vagrant/Vagrantfile.template Vagrantfile
```
Update the variables under "# UPDATE these project specific details." and vagrant up.

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


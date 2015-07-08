# vagrant-starter
A quick way to add a local development environment that uses vagrant, docker and shell provisioning.

Add this project as a submodule to a project. From the root of your project run:

  git submodule add https://github.com/mtbvang/vagrant-starter.git vagrant
  cp vagrant/Vagrantfile.template Vagrantfile

Update the variables under "# UPDATE these project specific details." and vagrant up.

  vagrant up


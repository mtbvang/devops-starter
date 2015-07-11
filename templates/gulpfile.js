/*
 * Task related to developing and automation while working on the project. 
 * The code related build tasks are in the app/gulpfile.js. Use this file to
 * add all infrastructure and automation related tasks that aren't directly
 * related to building the project code.
 */

var gulp = require('gulp');
var shell = require('gulp-shell')
var taskListing = require('gulp-task-listing');
var util = require('gulp-util');
var minimist = require('minimist');


var knownOptions = {
  string: 'env',
  string: 'projectName',
  string: 'vagrantPortOffset', 
  string: 'vagrantGuestAppPort',
  string: 'devopsDirName',
  string: 'dockerImageApp',
  default: { env: process.env.NODE_ENV || 'development',
  	projectName: 'app',
  	vagrantPortOffset: '0',
  	vagrantGuestAppPort: '1337',
  	devopsDirName: 'devops',
  	dockerImageApp: 'vagrant-node'}
};

var options = minimist(process.argv.slice(2), knownOptions);

// Add a task to render the output
gulp.task('help', taskListing);

gulp.task('default', [ 'help' ]);

gulp.task('heroku:setBuildPack',
	shell
		.task([
			'heroku buildpacks:set https://github.com/heroku/heroku-buildpack-nodejs#v' + util.env.version
				+ ' -a letregnskab', ]))

gulp.task('deploy:heroku', shell.task([ 'git subtree push --prefix app heroku master', ]))

gulp.task('consul:rm', shell.task([ "docker stop consul && docker rm consul" ], {ignoreErrors : true}))

gulp
	.task(
		'consul:start', ['consul:rm'],
		shell
			.task([
				"docker run -d -h node1 --name consul  -p 8300:8300  -p 8301:8301  -p 8301:8301/udp  -p 8302:8302  -p 8302:8302/udp  -p 8400:8400  -p 8500:8500  -p 172.17.42.1:53:53/udp  progrium/consul -server -bootstrap -ui-dir /ui", ]))

gulp.task('bootstrap', [ 'git:init', 'bootstrap:devops', 'bootstrap:vagrantfile', 'consul:start', 'vagrant:up' ]);
				
gulp.task('git:init', shell.task([ 'git init', ]))

gulp.task('bootstrap:devops', shell.task(['git submodule add https://github.com/mtbvang/devops-starter.git devops', 

                                        	'git submodule update --init --recursive',
                                        	
                                        	'git submodule foreach --recursive git pull origin master',	
                                        	
                                        	'git submodule foreach --recursive git checkout master'], 
                                        	{ignoreErrors : true}))

gulp.task('bootstrap:vagrantfile', shell.task(['cp devops/vagrant/Vagrantfile.node.template Vagrantfile',
                                             	'sed -i "s/<projectName>/' + options.projectName + '/g" Vagrantfile',
                                            	'sed -i "s/<portOffset>/' + options.vagrantPortOffset + '/g" Vagrantfile',
                                            	'sed -i "s/<guestAppPort>/' + options.vagrantGuestAppPort + '/g" Vagrantfile',
                                            	'sed -i "s+<dotfilesDir>+' + options.devopsDirName + '/dotfiles+g" Vagrantfile',
                                            	'sed -i "s+<vagrantDir>+' + options.devopsDirName + '/vagrant+g" Vagrantfile',
                                            	'sed -i "s+<provisioningDir>+' + options.devopsDirName + '/provisioning+g" Vagrantfile',
                                            	'sed -i "s+<dockerImage>+' + options.dockerImageApp + '+g" Vagrantfile' ]))

gulp.task('vagrant:up', shell.task([ 'vagrant destroy -f && vagrant up --no-parallel', ]))

gulp.task('sails:new', shell.task([ 'sails new app', 
                                    'cp ' + options.devopsDirName + '/dotfiles/.sailsrc-app app/.sailsrc'
                                    ]))     
                                    
gulp.task('sails:reactjs', ['sails:new'], shell.task([ 'sails generate reactjs ' + options.projectName,
                                    'sails generate bower',
                                    'bower install',
                                    'npm install'
                                    ], {cwd: 'app'}))                               
                                      
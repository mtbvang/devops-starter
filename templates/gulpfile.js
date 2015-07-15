/*
 * Task related to developing and automation while working on the project. 
 * The code related build tasks are in the app/gulpfile.js. Use this file to
 * add all infrastructure and automation related tasks that aren't directly
 * related to building the project code.
 */

var gulp = require('gulp');
var shell = require('gulp-shell'); // Used instead of exec for tasks
var taskListing = require('gulp-task-listing');
var util = require('gulp-util');
var minimist = require('minimist');
var runSequence = require('run-sequence');
var exec = require('child_process').exec;	// Used to exec sequential shell tasks
																					// because gulp-shell is not returning
																					// control of terminal when calling
																					// vagrant commands.
var Heroku = require('heroku-client');
var Netrc = require('node-netrc');

var netrc = new Netrc('api.heroku.com');


var knownOptions = {
  string: 'env',									// NODE_ENV value
  string: 'projectName',					// Project name.
  string: 'appDirName',						// Where sails app will be generated
  string: 'vagrantPortOffset', 		// vagrantGuestApport + vagrantPortOffset =
																	// host machine app port
  string: 'vagrantGuestAppPort',	// Port that node app will run on
  string: 'devopsDirName',				// Dir where devops-starter is cloned to
  string: 'appType', 							// Type of application to generate.
																	// [node|node-r]
  string: 'herokuToken',					// Heroku authentication token
  default: { env: process.env.NODE_ENV || 'development',
  	projectName: 'app',
  	appDirName: 'app',
  	vagrantPortOffset: '0',
  	vagrantGuestAppPort: '1337',
  	devopsDirName: 'devops',
  	appType: 'node',
  	herokuToken: netrc.password} 
};

var options = minimist(process.argv.slice(2), knownOptions);
var heroku = new Heroku({token: options.herokuToken});

// Add a task to render the output
gulp.task('help', taskListing);

gulp.task('default', [ 'help' ]);

gulp.task('heroku:setBuildPack',
	shell.task(['heroku buildpacks:set https://github.com/heroku/heroku-buildpack-nodejs#v' 
	            + util.env.version + ' -a ' + options.projectName,])
);

gulp.task('deploy:heroku', shell.task([ 'git subtree push --prefix app heroku master'], {maxBuffer : 5 * 1024 * 1024}));

gulp.task('consul:rm', shell.task([ "docker stop consul && docker rm consul" ], {ignoreErrors : true}));

gulp.task('consul:start', ['consul:rm'],
		shell.task(["docker run -d -h node1 --name consul -p 8300:8300 -p 8301:8301 -p 8301:8301/udp -p 8302:8302 -p 8302:8302/udp -p 8400:8400 -p 8500:8500 -p 172.17.42.1:53:53/udp progrium/consul -server -bootstrap -ui-dir /ui",])
);
				
gulp.task('bootstrap', function(cb) {		
	runSequence('git:init',
							'bootstrap:devops', 
	            'bootstrap:vagrantfile', 
	            'consul:start',
	            'bootstrap:app', 
	            'heroku:app:create',
	            'git:remote:add:heroku',
	            'deploy:heroku',
	            cb);
});

gulp.task('heroku:init', function(cb) {		
	runSequence('heroku:app:create',
	            'git:remote:add:heroku',
	            cb);
});

gulp.task('heroku:deinit', function(cb) {		
	runSequence('heroku:app:delete',
	            'git:remote:remove:heroku',
	            cb);
});

gulp.task('heroku:apps', function() {
	heroku.apps().list(function (err, res) {
	  if (!err) {
	  	util.log(JSON.stringify(res, null, 2));
	  }else {
	  	util.log(err.message);
	  }
	});
});

gulp.task('heroku:app:delete', function() {
	heroku.apps(options.projectName).delete(function (err, res) {
		if (!err) {
	  	util.log(JSON.stringify(res, null, 2));
	  }else {
	  	util.log(err.message);
	  }				
	});	
});

gulp.task('heroku:app:create', function() {
	heroku.apps().create({name: options.projectName, stack: 'cedar-14'}, function (err, res) {
		if (!err) {
	  	util.log(JSON.stringify(res, null, 2));
	  }else {
	  	util.log(err.message);
	  }		
	});	
});

gulp.task('bootstrap:clean', shell.task(['vagrant destroy -f',
                                          'rm Vagrantfile']));

gulp.task('git:init', shell.task(['git init', 
                                  'curl -O https://raw.githubusercontent.com/mtbvang/dotfiles/master/.gitignore']));

gulp.task('git:remote:add:heroku', shell.task(['git remote add heroku git@heroku.com:' + options.projectName + '.git']));

gulp.task('git:remote:remove:heroku', shell.task(['git remote remove heroku']));


gulp.task('npm:init', 
	shell.task([
	            'npm config set init.author.name ${git config user.name}',
	            'npm config set init.author.email ${git config user.email}',
	            'npm config set init.license MIT',
	            'npm init',
	            ]
	)
);

gulp.task('bootstrap:devops', 
	shell.task([
	            'git submodule add https://github.com/mtbvang/devops-starter.git devops', 
             	'git submodule update --init --recursive',
             	'git submodule foreach --recursive git pull origin master',	
             	'git submodule foreach --recursive git checkout master',
             	], 
             	{ignoreErrors : true}
	)
);

gulp.task('bootstrap:vagrantfile', 
	shell.task(['echo options.appType: ' + options.appType,
	            'cp devops/vagrant/templates/Vagrantfile-' + options.appType + ' Vagrantfile',
					   	'sed -i "s/<projectName>/' + options.projectName + '/g" Vagrantfile',
					  	'sed -i "s/<portOffset>/' + options.vagrantPortOffset + '/g" Vagrantfile',
					  	'sed -i "s/<guestAppPort>/' + options.vagrantGuestAppPort + '/g" Vagrantfile',
					  	'sed -i "s+<dotfilesDir>+' + options.devopsDirName + '/dotfiles+g" Vagrantfile',
					  	'sed -i "s+<vagrantDir>+' + options.devopsDirName + '/vagrant+g" Vagrantfile',
					  	'sed -i "s+<provisioningDir>+' + options.devopsDirName + '/provisioning+g" Vagrantfile',
					  	'sed -i "s+<dockerImage>+' + 'vagrant-' + options.appType + '+g" Vagrantfile',
					  	]
	)
);

gulp.task('bootstrap:app', function (cb) {
	exec('vagrant up --no-parallel && vagrant ssh ' + options.projectName + 
		'-app -c "cd /vagrant && gulp sails:new && gulp sails:generate:reactjs "' +
		'&& git add . && git commit -am "intial commit."', 
		{maxBuffer: 5 * 1024 * 1024},
		function (err, stdout, stderr) {
			console.log(stdout);
			console.log(stderr);
			cb(err);
		});
});
                                        
gulp.task('sails:new', function(cb) {
	exec('cp ' + options.devopsDirName + '/dotfiles/.sailsrc-karnith .sailsrc' +
		' && sails new ' + options.appDirName +
		' && cp ' + options.devopsDirName + '/dotfiles/.sailsrc-app app/.sailsrc', 
		{maxBuffer: 5 * 1024 * 1024},
		function (err, stdout, stderr) {
 			console.log(stdout);
 			console.log(stderr);
 			cb(err);
		});
});  

gulp.task('sails:generate:reactjs', function(cb) {
	exec('sails generate bower --force' +
		' && sails generate reactjs ' + options.projectName + ' --force' +
		' && bower install' +
		' && npm install',
		{maxBuffer: 5 * 1024 * 1024, cwd: '/vagrant/app'},
		function (err, stdout, stderr) {
 			console.log(stdout);
 			console.log(stderr);
 			cb(err);
		});
});  
                          
                                      
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

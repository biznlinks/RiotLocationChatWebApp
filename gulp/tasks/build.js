var gulp = require('gulp');
var $ = require('gulp-load-plugins')();

//temporarily disabling jshint
gulp.task('build', ['html', 'images', 'extras', 'riot'], function () {
  return gulp.src('dist/**/*');
});
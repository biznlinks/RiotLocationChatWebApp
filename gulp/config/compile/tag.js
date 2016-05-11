var gulp = require('gulp');

var gulp_riot = require('gulp-riot');

var $ = require('gulp-load-plugins')();


gulp.task('riot', [ 'fonts'], function () {
  var lazypipe = require('lazypipe');
  

  return gulp.src(['app/components/*.tag'])
    .pipe(gulp_riot.riot())
    .pipe(gulp.dest('dist'));
});
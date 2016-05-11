var gulp = require('gulp');
var $ = require('gulp-load-plugins')();

gulp.task('riot', [ 'fonts'], function () {
  var lazypipe = require('lazypipe');
  

  return gulp.src(['app/**/*.tag'])
    
    // .pipe($.if('*.js', $.uglify()))
    .pipe($.useref())
    .pipe(gulp.dest('dist'));
});
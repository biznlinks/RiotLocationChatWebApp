var gulp = require('gulp');
var $ = require('gulp-load-plugins')();

gulp.task('watch', ['connect'], function () {
  $.livereload.listen();

  // watch for changes
  gulp.watch([
    'app/**/*.html',
    'app/**/*.tag',
    '.tmp/styles/**/*.css',
    'app/js/**/*.js',
    'app/images/**/*'
  ]).on('change', $.livereload.changed);

});
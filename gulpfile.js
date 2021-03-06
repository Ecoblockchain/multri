const gulp     = require('gulp')
const webpack  = require('gulp-webpack')
const cleanCSS = require('gulp-clean-css')
const stylus   = require('gulp-stylus')
const rename   = require('gulp-rename')

gulp.task('css', () => {
  return gulp.src('public/**/*.styl')
    .pipe(stylus({compress: true}))
    .pipe(cleanCSS())
    .pipe(gulp.dest('public'))
})

gulp.task('js', () => {
  return gulp.src('app/index.ls')
    .pipe(webpack(require('./webpack.config.js')))
    .pipe(rename('bundle.js'))
    .pipe(gulp.dest('public'))
})

gulp.task('watchcss', ['css'], () => {
  gulp.watch('public/**/*.styl', ['css'])
})

gulp.task('default', ['watchcss', 'js'])

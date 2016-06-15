'use strict'

# Include gulp
gulp = require 'gulp'

# Include Our Plugins
cleanDest = require 'gulp-clean-dest'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
html2js = require 'gulp-ng-html2js'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
gutil = require 'gulp-util'
rename = require 'gulp-rename'
less = require 'gulp-less'
minifyCSS = require 'gulp-minify-css'
inject = require 'gulp-inject'
bowerFiles = require 'main-bower-files'
imagemin  = require 'gulp-imagemin'
runSequence = require 'run-sequence'
browserSync = require 'browser-sync'
wiredep = require 'wiredep'

### Variables ###
name = 'sc-form'

paths =
  src: 'src'
  dist: 'dist'
  demo: 'demo'
  release: 'release'
  tmp: '.tmp'

src =
  scripts: "#{paths.src}/**/*.coffee"
  stylesheets: "#{paths.src}/**/*.less"
  templates: "#{paths.src}/**/*_template.html"
  index: "#{paths.demo}/index.html"
  demo: "#{paths.demo}/*.{json,js}"

dest =
  all: "#{paths.dist}/**/*.*"
  scripts: "#{paths.dist}/js"
  stylesheets: "#{paths.dist}/css"
  tmp:
    scripts: "#{paths.tmp}/js"
    templates: "#{paths.tmp}/templates"

tmp =
  scripts: [
    "#{dest.tmp.scripts}/**/*.js"
    "#{dest.tmp.templates}/**/*.js"
  ]

config =
  port: "9000"
  baseDevUrl: "http://localhost"
  uri: "http://localhost:9000"


# Watch Files For Changes
gulp.task 'watch', ->
  gulp.watch src.scripts, ['scripts']
  gulp.watch src.templates, ['scripts']
  gulp.watch src.stylesheets, ['stylesheets']
  gulp.watch src.index, ['index']
  gulp.watch src.demo, ['demo']
  gulp.watch dest.all
    .on 'change', browserSync.reload


# Run a webserver
gulp.task 'connect', ->
  browserSync.init(
    ui: false
    server: {
      baseDir: paths.dist
      index: "index.html"
      routes: {
        "/bower_components": "bower_components"
        "/dist": "dist"
      }
    }
    port: config.port
    open: false
    browser: "chromium-browser"
  )

# Compile CoffeeScript files
gulp.task 'coffee', ->
  gulp
  .src src.scripts
  .pipe cleanDest(dest.tmp.scripts)
  .pipe coffeelint()
  .pipe coffeelint.reporter('default')
  .pipe coffee()
  .pipe gulp.dest dest.tmp.scripts
  .on('error', gutil.log)

# Converting AngularJS templates to JavaScript
gulp.task 'html2js', ->
  gulp
  .src src.templates
  .pipe cleanDest(dest.tmp.templates)
  .pipe html2js(
    moduleName: (file) ->
      pathParts = file.path.split('/')
      folder = pathParts[pathParts.length - 1]
      folder.replace('_template.html', 'Template')
  )
  .pipe concat 'templates.js'
  .pipe gulp.dest dest.tmp.templates
  .on('error', gutil.log)

# Concatenate & Minify Javascript files
gulp.task 'scripts', ['coffee', 'html2js'], ->
  gulp
  .src tmp.scripts
  .pipe cleanDest(dest.scripts)
  .pipe concat "#{name}.js"
  .pipe rename "#{name}.min.js"
  .pipe uglify({
    # Specify mangle false to prevent changes to your variable and function names
    mangle: false
  })
  .pipe gulp.dest dest.scripts
  .on('error', gutil.log)

# Concatenate & Minify CSS files
gulp.task 'stylesheets', ->
  gulp
  .src src.stylesheets
  .pipe cleanDest(dest.stylesheets)
  .pipe less()
  .pipe minifyCSS()
  .pipe concat "#{name}.css"
  .pipe rename "#{name}.min.css"
  .pipe gulp.dest dest.stylesheets
  .on('error', gutil.log)

# Injecting all files for development
gulp.task 'index', ->
  wiredepOptions =
     directory: 'bower_components'

  gulp
  .src src.index
  .pipe inject gulp.src(bowerFiles(), {read: false}), {addRootSlash: false, name: 'bower'}
  .pipe inject gulp.src(["#{dest.scripts}/#{name}.min.js", "#{dest.stylesheets}/#{name}.min.css"], {read: false}), {addRootSlash: false}
  .pipe gulp.dest paths.dist
  .on('error', gutil.log)

# Copy demonstration files
gulp.task 'demo', ->
  gulp
  .src src.demo
  .pipe gulp.dest paths.dist

# Populate release folder
gulp.task 'release', ->
  gulp
  .src ["#{dest.scripts}/#{name}.min.js", "#{dest.stylesheets}/#{name}.min.css"]
  .pipe gulp.dest paths.release


### Tasks ###
gulp.task 'build', ->
  runSequence ['scripts', 'stylesheets']

gulp.task 'build-release', ->
  runSequence ['scripts', 'stylesheets'], 'release'

# This will run in this order:
# scripts and stylesheets in parallel
# index and demo in parallel
# connect and watch in parallel
gulp.task 'serve', ->
  runSequence ['scripts', 'stylesheets'], ['index', 'demo'], ['connect', 'watch']

gulp.task 'default', [
  'build'
  'watch'
]

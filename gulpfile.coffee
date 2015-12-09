del        = require 'del'
gulp       = require 'gulp'
coffee     = require 'gulp-coffee'
jade       = require 'gulp-jade'
minifyCSS  = require 'gulp-minify-css'
rename     = require 'gulp-rename'
sass       = require 'gulp-sass'
gutil      = require 'gulp-util'

paths = {
  srcSass:   'src/sass/*.scss'
  destCSS:   'www/css'

  srcCoffee: 'src/coffee/**/*.coffee'
  destJS:    'www/js'

  srcJade:   'src/jade/**/*.jade'
  destHTML:  'www'
  
  jsToCopy:  [
    'bower_components/jquery/dist/jquery.min.js',
    'bower_components/bootstrap/dist/js/bootstrap.min.js'
  ]
}

gulp.task 'default', ['sass', 'coffee', 'jade', 'copy-js']

gulp.task 'sass', (done) ->
  gulp.src paths.srcSass
    .pipe sass({errLogToConsole: true})
      .on 'error', gutil.log
    .pipe minifyCSS keepSpecialComments: 0
    .pipe rename( (path) -> path.extname = '.min.css' )
    .pipe gulp.dest paths.destCSS
    .on 'end', done
  return undefined

gulp.task 'coffee', (done) ->
  gulp.src paths.srcCoffee
    .pipe coffee({bare: true})
      .on 'error', gutil.log
    .pipe gulp.dest paths.destJS
    .on 'end', done
  return undefined

gulp.task 'jade', (done) ->
  gulp.src paths.srcJade
    .pipe jade()
      .on 'error', gutil.log
    .pipe gulp.dest paths.destHTML
    .on 'end', done
  return undefined

gulp.task 'copy-js', (done) ->
  gulp.src paths.jsToCopy
    .pipe gulp.dest paths.destJS
    .on 'error', gutil.log
    .on 'end', done
  return undefined

gulp.task 'watch', ->
  gulp.watch paths.srcSass, ['sass']
  gulp.watch paths.srcCoffee, ['coffee']
  gulp.watch paths.srcJade, ['jade']

# Clean up all compile output
gulp.task 'clean', ->
  del [
    paths.destCSS,
    paths.destJS,
    paths.destHTML + '/templates',
    paths.destHTML + '/index.html'
  ]

# Clean up bower libraries
gulp.task 'clean-all', ['clean'], ->
  del [
    'www/lib'
  ]

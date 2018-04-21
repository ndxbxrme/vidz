module.exports = (grunt) ->
  require('load-grunt-tasks') grunt
  grunt.initConfig
    express:
      web:
        options:
          script: 'build/test.js'
    watch:
      coffee:
        files: ['src/**/*.coffee']
        tasks: ['build']
    coffee:
      options:
        sourceMap: true
      default:
        files: [{
          expand: true
          cwd: 'src'
          src: ['**/*.coffee']
          dest: 'build'
          ext: '.js'
        }]
    pug:
      options:
        pretty: true
        data: ->
          package: pkg
      default:
        files: [
          expand: true
          cwd: 'src'
          src: ['**/*.pug']
          dest: 'build'
          ext: '.html'
        ]
    clean:
      build: 'build'
    nodeunit:
      tests: ['build/test/**/*.js']
  grunt.registerTask 'build', [
    'clean:build'
    'coffee'
    'pug'
  ]
  grunt.registerTask 'default', [
    'build'
    'watch'
  ]
  grunt.registerTask 'test', [
    'build'
    'nodeunit'
  ]
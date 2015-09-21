module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    sass: {
      dist: {
        files: {
          'assets/css/editor.css' : 'sass/editor.scss'
        }
      }
    },
    coffee: {
      compile: {
        options: {
          sourceMap: true
        },
        files: {
          'assets/js/editor.js': 'coffeescript/editor.coffee'
        }
      }
    }
  });
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.registerTask('default',['sass', 'coffee']);
}
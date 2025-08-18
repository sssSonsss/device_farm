require.ensure([], function(require) {
  require('nine-bootstrap')

  require('angular')
  require('angular-route')
  require('angular-touch')
  require('angular-hotkeys')

  angular.module('app', [
    'ngRoute',
    'ngTouch',
    'cfp.hotkeys',
    require('gettext').name,
    require('./signin').name
  ])
    .config(function($routeProvider, $locationProvider) {
      $locationProvider.html5Mode(true)
      $routeProvider
        .otherwise({
          redirectTo: '/auth/mock/'
        })
    })
})

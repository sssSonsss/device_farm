/**
* Copyright © 2019 contains code contributed by Orange SA, authors: Denis Barbaron - Licensed under the Apache license 2.0
**/

require.ensure([], function(require) {
  require('angular')
  require('angular-route')
  require('angular-touch')

  // Helper function to safely require modules
  function safeRequire(modulePath) {
    try {
      const module = require(modulePath)
      console.log('Module loaded:', modulePath, module)
      return module && module.name ? module.name : null
    } catch (e) {
      console.warn('Failed to load module:', modulePath, e)
      return null
    }
  }

  // Test each module individually
  console.log('Testing module loading...')
  
  const gettextModule = safeRequire('gettext')
  const hotkeysModule = safeRequire('angular-hotkeys')
  const layoutModule = safeRequire('./layout')
  const deviceListModule = safeRequire('./device-list')
  const groupListModule = safeRequire('./group-list')
  const controlPanesModule = safeRequire('./control-panes')
  const menuModule = safeRequire('./menu')
  const settingsModule = safeRequire('./settings')
  const docsModule = safeRequire('./docs')
  const userModule = safeRequire('./user')
  const langModule = safeRequire('./../common/lang')
  const standaloneModule = safeRequire('stf/standalone')
  const safeApplyModule = safeRequire('stf/common-ui/safe-apply')

  // Filter out null modules
  const modules = [
    'ngRoute',
    'ngTouch',
    gettextModule,
    hotkeysModule,
    layoutModule,
    deviceListModule,
    groupListModule,
    controlPanesModule,
    menuModule,
    settingsModule,
    docsModule,
    userModule,
    langModule,
    standaloneModule,
    safeApplyModule
  ].filter(Boolean)

  // Debug: Log modules array
  console.log('Available modules:', modules)
  console.log('Modules count:', modules.length)
  console.log('Modules array:', JSON.stringify(modules, null, 2))

  angular.module('app', modules)
    .config(function($routeProvider, $locationProvider) {
      $locationProvider.hashPrefix('!')
      $routeProvider
        .otherwise({
          redirectTo: '/devices'
        })
    })

    .config(function(hotkeysProvider) {
      hotkeysProvider.templateTitle = 'Keyboard Shortcuts:'
    })
    
    .run(['$rootScope', 'AppState', function($rootScope, AppState) {
      $rootScope.state = AppState
    }])
})

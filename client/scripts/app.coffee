'use strict';

angular.module('app', [
  # Angular modules
  'ngAnimate'

  # 3rd Party Modules
  'ui.bootstrap'
  'ui.router'

  # Custom modules
  'app.controllers'
  'app.localization'

  'taf'
])

.run ($rootScope, $state, $stateParams) ->
  $rootScope.$state = $state;
  $rootScope.$stateParams = $stateParams;


  $rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
    console.log '$stateChangeError', toState
    console.error error

  $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
    console.log '$stateChangeSuccess', toState

  $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
    console.log '$stateChangeStart', toState

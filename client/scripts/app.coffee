'use strict';

angular.module('app', [
  # Angular modules
  'ngRoute'
  'ngAnimate'

  # 3rd Party Modules
  'ui.bootstrap'

  # Custom modules
  'app.controllers'
  'app.localization'

  'taf'
])

.config [
  '$routeProvider'
  ($routeProvider) ->

    routes = [
      'taf/home'
      'taf/save'
      'taf/import'
      'taf/calculate'
    ]

    setRoutes = (route) ->
      url = '/' + route
      config =
        templateUrl: 'views/' + route + '.html'

      $routeProvider.when url, config
      return $routeProvider

    routes.forEach (route) ->
      setRoutes(route)

    $routeProvider
      .when('/', { redirectTo: '/taf/home'} )
      .when('/404', { templateUrl: 'views/pages/404.html'} )
      .otherwise( redirectTo: '/404' )
]

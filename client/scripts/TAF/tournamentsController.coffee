
angular.module('taf.controller.tournaments', ['ngStorage'])
.controller 'tafTournamentsCtrl', ($scope, $localStorage, tafTournament) ->
  console.log 'TEST'

  $scope.init = ->
    $scope.tournaments = tafTournament.getTournaments()
    $scope.tournament = tafTournament.activeTournament()

  $scope.reset = ->
    $localStorage.$reset()
    $scope.init()

  $scope.save = ->
    tafTournament.addTournament $scope.tournament
    $scope.tournament = null
    tafTournament.emptyTournament()
    $scope.init()

  $scope.activate = (tournament) ->
    tafTournament.activateTournament tournament

  $scope.init()
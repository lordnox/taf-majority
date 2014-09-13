
angular.module('taf.services.tournament', [])
.factory 'tafTournament', ($localStorage) ->
  class Tournament
    constructor: ->
      @information =
        title: 'TEST'

  Tournament.load = (tournament) ->
    return new Tournament if not tournament


  create: -> new Tournament
  active: -> Tournament.load $localStorage.tournament
  all: ->
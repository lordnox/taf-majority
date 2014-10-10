
blacklist = ['uuid']
watchlist = ['title', 'hasQuick', 'hasSlow', 'hasKuer']

angular.module('taf.services.tournament', [])

.constant 'slow', 'SLOW-DF'
.constant 'quick', 'DISCOFOX'
.constant 'kuer', 'KUER'

.factory 'tafId', ->
  -> return "00000000-0000-4000-8000-000000000000".replace /0/g, -> (0|Math.random()*16).toString 16

.factory 'tafSettings', (slow, quick, kuer) ->
  {}

.factory 'tafCouple', (tafSettings, tafId) ->
  empty: ->
    number: 0
    leader: null
    follower: null
    slow:
      values: []
    quick:
      values: []
    kuer:
      values: []

.factory 'tafJudge', (tafSettings, tafId) ->
  empty: ->
    letter: 'A'
    name: null

.factory 'tafTournament', ($localStorage, tafCalculation, tafCouple, tafId, $rootScope) ->

  tafTournament =
    getTournaments: -> $localStorage.tournaments = $localStorage.tournaments or []
    activeTournament: -> $localStorage.tournament = $localStorage.tournament or tafTournament.emptyTournament()
    addTournament: (tournament) -> $localStorage.tournaments.push tournament
    activateTournament: (tournament) -> $localStorage.tournament = tournament
    getTournament: (id) ->
      console.log id
      tournaments = $localStorage.tournaments.filter (tournament) -> id is ""+tournament.id
      tournaments?[0]
    emptyTournament: -> $localStorage.tournament =
      id: tafId()
      name: null
      couples: []
      judges: []
      dances: ['slow', 'quick', 'kuer']

  tafTournament
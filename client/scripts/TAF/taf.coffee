
angular.module 'taf.controller', [
  'taf.controller.tournaments'
  'taf.controller.tournament'
  'taf.controller.import'
#  'taf.controller.calculation'
]

angular.module 'taf.directives', [
  'taf.directives.radialSelect'
  'taf.directives.ratings'
]

angular.module 'taf.services', [
  'taf.services.calculation'
  'taf.services.tournament'
]

angular.module 'taf', [
  'taf.controller'
  'taf.directives'
  'taf.services'
]

.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/all'

  $stateProvider

  .state 'taf',
    template: '<div ui-view></div>'
    abstract: true

  .state 'taf.list',
    url: '/all'
    templateUrl: 'views/taf/tournaments.html'
    controller: 'tafTournamentsCtrl'

  .state 'taf.tournament',
    url: '/tournament/:id'
    templateUrl: 'views/taf/tournament-wrapper.html'
    controller: 'tafTournamentCtrl'
    abstract: true
    resolve:
      tournament: ($stateParams, tafTournament) ->
        console.log $stateParams, tafTournament.getTournament $stateParams.id
        tafTournament.getTournament $stateParams.id

  .state 'taf.tournament.view',
    url: '/view'
    templateUrl: 'views/taf/tournament-view.html'
    controller: 'tafTournamentCtrl'

  .state 'taf.tournament.editJudges',
    url: '/judges'
    templateUrl: 'views/taf/tournament-edit-judges.html'
    controller: 'tafTournamentCtrl'

  .state 'taf.tournament.editCouples',
    url: '/couples'
    templateUrl: 'views/taf/tournament-edit-couples.html'
    controller: 'tafTournamentCtrl'

  .state 'taf.tournament.enterRound',
    url: '/round'
    templateUrl: 'views/taf/tournament-edit-round.html'
    controller: 'tafTournamentCtrl'


createArray = (n, fn = (i) -> i) ->
  return [] if n <= 1
  i = 0
  array = []
  while i < n
    array.push fn i++
  array

angular.module('taf.controller.application', ['ngStorage'])
.controller 'tafApplicationCtrl', ($scope, $sessionStorage, tafTournament) ->
  $scope.mode = {
    edit: {
      title: false
    }
  };
  $scope.tournament = tafTournament.active()

###
.controller 'tafApplicationCtrl', ($scope, $sessionStorage, tafTournament) ->
  $scope.input =
    couple:                             # Eingabe für das aktuelle Paar
      name: "Paar"                      # Name
      SD: values: []                    # values given by the judges, in order
      DF: values: []                    # ^^
      KR: values: []                    # ^
    judges: ['A', 'B', 'C', 'D', 'E'] # Anzahl der Wertungsrichter
    judgeCount: 5
    couples: [1, 2, 3, 4, 5, 6, 7, 8] # Anzahl der Paare mit Index damit die Zahlen genutzt werden können

  $scope.$watch 'input.judgeCount', (nValue, oValue) ->
    value = parseInt nValue, 10
    return if not value
    #return $scope.input.judgeCount = oValue if isNaN(value) or (value < 1) or (value > 9)
    $scope.input.judges = createArray value, (i) -> String.fromCharCode 65 + i
    $scope.judgeCount = value;

  $scope.$watch 'input.couplesCount', (nValue, oValue) ->
    value = parseInt nValue, 10
    return if not value
    #return $scope.input.couplesCount = oValue if isNaN(value) or (value < 1) or (value > 9)
    $scope.input.couples = createArray value, (i) -> i + 1

  $scope.addCouple = (couple) ->
    console.log 'Adding a new couple!'

  $scope.selectNext = ($event) ->
    console.log 'CHAAANGE'

  $sessionStorage.settings = $sessionStorage.settings || {}
  $scope.settings = $sessionStorage.settings;
  $scope.settings.radialWidth = 200;
  $scope.settings.radialBorder = 3;

  $scope.tournamet = tafTournament.active()

  $scope.store = $sessionStorage;
  $scope.judgeCount = $scope.store.tournament?.judges?.count || 5;

  $scope.rows = ->
    rows = 0
    rows++ if $scope.settings.slow
    rows++ if $scope.settings.quick
    rows++ if $scope.settings.kuer
    rows
### # ###
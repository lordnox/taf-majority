
angular.module('taf.controller.tournament', ['ngStorage'])
.controller 'tafTournamentCtrl', ($scope, tournament, tafCouple, tafJudge, tafCalculation) ->
  $scope.tournament = tournament

  $scope.initCouple = ->
    $scope.couple = tafCouple.empty()
    if tournament.couples.length
      $scope.couple.number = parseInt(tournament.couples[tournament.couples.length - 1].number, 10) + 1

  $scope.initJudge = ->
    $scope.judge = tafJudge.empty()
    $scope.judge.letter = String.fromCharCode 65 + tournament.judges.length

  $scope.addCouple = (couple) ->
    tournament.couples.push couple
    $scope.initCouple()

  $scope.addJudge = (judge) ->
    tournament.judges.push judge
    $scope.initJudge()

  $scope.initJudge()
  $scope.initCouple()

  $scope.toggleDance = (dance) ->
    index = tournament.dances.indexOf dance
    if index is -1
      tournament.dances.push dance
    else
      tournament.dances.splice index, 1

  $scope.hasDance = (dance) ->
    -1 isnt tournament.dances.indexOf dance

  $scope.calculate = ->
    calculation = new tafCalculation tournament
    calculation.result()

  tournament.dances = ['quick']
  calculation = new tafCalculation tournament
  #calculation.result()

  $scope.dance = tournament.dances[0]
  $scope.isDanceActive = (dance) -> dance is $scope.dance

  $scope.hasIndexError = (index, dance) ->
    values = $scope.tournament.couples.map (couple) ->
      couple[dance].values[index]

    filtered = values.filter (value, index) ->
      return false if isNaN(value) or (value is null) or (value is "")
      -1 isnt values.indexOf value, index + 1

    filtered.length > 0
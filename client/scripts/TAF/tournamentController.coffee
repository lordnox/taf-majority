
angular.module('taf.controller.tournament', ['ngStorage'])
.controller 'tafTournamentCtrl', ($scope, tournament, tafCouple, tafJudge) ->
  $scope.tournament = tournament

  $scope.couple = tafCouple.empty()
  $scope.judge = tafJudge.empty()

  $scope.addCouple = (couple) ->
    tournament.couples.push couple
    $scope.couple = tafCouple.empty()

  $scope.addJudge = (judge) ->
    tournament.judges.push judge
    $scope.judge = tafJudge.empty()

  $scope.dance = 'slow'
  $scope.isDanceActive = (dance) -> dance is $scope.dance

  $scope.hasIndexError = (index, dance) ->
    values = $scope.tournament.couples.map (couple) ->
      couple[dance].values[index]

    filtered = values.filter (value, index) ->
      return false if isNaN(value) or (value is null) or (value is "")
      -1 isnt values.indexOf value, index + 1

    if filtered.length > 0
      console.log filtered

    filtered.length > 0
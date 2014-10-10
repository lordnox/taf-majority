
angular.module('taf.controller.calculation', ['ngStorage'])

.controller 'tafCalculationCtrl', ($scope, $sessionStorage, $localStorage, tafCalculation) ->
  $scope.store = $sessionStorage
  $scope.lStore = $localStorage

  calculate = (tournament) ->
    calculation = new tafCalculation tournament
    calculation.result()

  $scope.calculate = ->
    #calculate $scope.lStore.tournaments[0]
    $scope.lStore.tournaments.forEach calculate

  $scope.calculate()

  window.s = $scope

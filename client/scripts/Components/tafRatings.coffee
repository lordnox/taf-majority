
angular.module('taf.directives.ratings', [])

.directive 'tafRatings', [ ->
  restrict: 'A'
  templateUrl: 'views/components/tafRatings.html'
  scope:
    judges: '=tafJudges'
    ratings: '=tafRatings'
]
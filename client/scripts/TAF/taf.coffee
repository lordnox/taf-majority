
angular.module 'taf.controller', [
  'taf.controller.application'
  'taf.controller.import'
  'taf.controller.calculation'
]

angular.module 'taf.directives', [
  'taf.directives.radialSelect'
  'taf.directives.ratings'
]

angular.module 'taf.services', [
  'taf.services.calculation'
]

angular.module 'taf', [
  'taf.controller'
  'taf.directives'
  'taf.services'
]

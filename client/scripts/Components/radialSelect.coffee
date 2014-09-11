
angular.module('taf.directives.radialSelect', [])

.directive 'radialSelect', [ '$http', '$compile', ($http, $compile) ->
  template = $http.get 'views/components/radialSelect.html'

  cachedRotSkew = (border, max) ->
    hash = cachedRotSkew.hash border, max
    return cachedRotSkew.cache[hash] if cachedRotSkew.cache[hash]
    border = parseInt(border, 10) || 5
    max = max || 1
    deg = if max is 0 then 360 else 360 / max
    cachedRotSkew.cache[hash] =
      deg: deg
      _rot: (90 - deg / 2) + border
      skew: 90 - deg + 2 * border
  cachedRotSkew.hash = (border, max) -> [border, max].join '|'
  cachedRotSkew.cache = {}

  restrict: 'A'
  scope:
    model: '=ngModel'
    select: '=radialSelect'
    width: '@radialWidth'
    border: '@radialBorder'
  # This link method creates a simple div-wrapper and append the real template side by side with the original tag
  link: ($scope, $element, $attrs) ->
    $scope.wrapper = angular.element '<div class="radial-select wrapper"></div>'
    $element.after $scope.wrapper
    $scope.wrapper.append $element
    template.success (html) ->
      $scope.wrapper.append ($compile html) $scope

  controller: ($scope, $element, $window, $http, $templateCache) ->
    $scope.open = false

    $scope.activate = -> $scope.open = true
    $scope.deactivate = -> $scope.open = false

    prevent = ($event) ->
      $event.preventDefault()
      $event.stopPropagation()

    digest = (fns...) -> (args...) ->
      fns.forEach (fn) => fn.apply this, args
      $scope.$digest()

    angular.element(window).click digest $scope.deactivate
    $element.click digest $scope.activate, prevent

    # handle when the element looses focus through a tap or tab
    # and not has any part of the wrapper contents taking the active state
    $element.on 'blur', ($event) ->
      if not $(':active', $scope.wrapper).length
        $scope.deactivate $event
        $scope.$digest()

    $scope.set = (value, $event) ->
      $scope.model = value
      $element.focus()
      $scope.deactivate $event

    max = 1
    $scope.$watch 'select.length', -> max = $scope.select?.length || 1

    getRotSkew = (index) ->
      {deg, _rot, skew} = cachedRotSkew $scope.border, max
      rot: _rot + deg * index
      skew: skew

    transform = (transformation) ->
      "-webkit-transform": transformation
      "-moz-transform": transformation
      "-ms-transform": transformation
      "transform": transformation

    $scope.css_li = (index) ->
      return transform "rotate(" + (90 + 180 * index) + "deg) skew(0deg) translateY(50%)" if max is 2
      {rot, skew} = getRotSkew index
      transform "rotate(" + rot + "deg) skew(" + skew + "deg)"

    $scope.css_anchor = ->
      return transform "skew(0deg) rotate(-" + (90) + "deg) translateX(50%)" if max is 2
      {rot, skew} = getRotSkew 0
      transform "skew(" + (-skew) + "deg) rotate(" + (-rot) + "deg)"
]
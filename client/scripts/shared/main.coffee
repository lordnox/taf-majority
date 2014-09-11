'use strict';

angular.module('app.controllers', [])

# overall control
.controller('AppCtrl', [
    '$scope', '$rootScope'
    ($scope, $rootScope) ->
        $window = $(window)

        $scope.navigation =
            open: false

        $scope.pageTransitionOpts = [
            name: 'Fade up'
            class: 'animate-fade-up'
        ,
            name: 'Scale up'
            class: 'ainmate-scale-up'
        ,
            name: 'Slide in from right'
            class: 'ainmate-slide-in-right'
        ,
            name: 'Flip Y'
            class: 'animate-flip-y'
        ]
])


# Add 'active' class to li based on url, muli-level supported, jquery free
.directive('highlightActive', [ ->
    return {
        restrict: "A"
        controller: [
            '$scope', '$element', '$attrs', '$location'
            ($scope, $element, $attrs, $location) ->
                links = $element.find('a')
                path = () ->
                    return $location.path()

                highlightActive = (links, path) ->
                    path = '#' + path

                    angular.forEach(links, (link) ->
                        $link = angular.element(link)
                        $li = $link.parent('li')
                        href = $link.attr('href')

                        if ($li.hasClass('active'))
                            $li.removeClass('active')
                        if path.indexOf(href) is 0
                            $li.addClass('active')
                    )

                highlightActive(links, $location.path())

                $scope.$watch(path, (newVal, oldVal) ->
                    if newVal is oldVal
                        return
                    highlightActive(links, $location.path())
                )
        ]

    }
])

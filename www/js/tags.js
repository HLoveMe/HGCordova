angular.module('Tags', [])
.directive("async", function($ImageBox, $ionicPlatform, $rootScope) {
           return {
           restrict: "A",
           scope: {
           src: "@",
           ngSrc: "=",
           placeholder: "@",
           notification: "@"
           },
           link: function(scope, element, attrs) {
           var img = element[0]
           
           function load() {
           //不支持该插件
           if (typeof ImageBox == "undefined") {img.src=scope.src;return;}
           img.src = scope.placeholder
           scope.$watch('src', function(newValue, oldValue, scope) {
                        if (typeof newValue != "undefined") {
                        $ImageBox.loadImage(newValue, img).then(function() {
                                                                if (typeof scope.notification == "string") {
                                                                $rootScope.$broadcast(scope.notification)
                                                                }
                                                                })
                        
                        }
                        })
           scope.$watch('ngSrc', function(newValue, oldValue, scope) {
                        if (typeof newValue != "undefined") {
                        $ImageBox.loadImage(newValue, img).then(function() {
                                                                if (typeof scope.notification == "string") {
                                                                $rootScope.$broadcast(scope.notification)
                                                                }
                                                                })
                        }
                        })
           
           }
           //保证Dcoument已经加载
           if (typeof ImageBox == "undefined") {
           $ionicPlatform.ready(function() {
                                load()
                                })
           } else {
           load()
           }
           }
           }
           })

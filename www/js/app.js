// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
// 'starter.services' is found in services.js
// 'starter.controllers' is found in controllers.js
angular.module('starter', ['ionic', 'starter.controllers', 'starter.services', "Tags", "ngCordova"])
    .factory("$ImageBox", function($q, $rootScope) {
        return {
            loadImage: function(url, ele) {
                ImageBox.loadImage(url, function(data) {
                    ele.src = "data:image/jpeg;base64," + data
                })
            },
            clear: function() {
                var def = $q.defer()
                ImageBox.clear(function(res) {
                    def.resolve(res)
                })
                return def.promise
            },
            cacheSize: function(func) {
                ImageBox.cacheSize(func)
            }
        }
    })
    .factory("$DataManager", function($q) {
        return {
            operation: function(ops, type) {
                var def = $q.defer()
                switch (type) {
                    case 0:
                        //打开数据库 在数据库插件初始时  就自动创建打开
                        DataManager.openBase(function(msg) {
                            def.resolve(msg)
                        }, function(msg) {
                            def.reject(msg)
                        })
                        break;
                    case 1:
                        //关闭数据库
                        DataManager.closeBase(function(msg) {
                            def.resolve(msg)
                        }, function(msg) {
                            def.reject(msg)
                        })
                        break;
                    case 2:
                        //保存数据  所有属性都必须有
                        DataManager.saveObjects(ops, function(msg) {
                            def.resolve(msg)
                        }, function(msg) {
                            def.reject(msg)
                        })
                        break;
                    case 3:
                        //删除数据
                        DataManager.delete(ops, function(msg) {
                            def.resolve(msg)
                        }, function() {
                            def.reject(msg)
                        })
                        break;
                    case 4:
                        //更新数据
                        DataManager.update(ops, function(msg) {
                            def.resolve(msg)
                        }, function(msg) {
                            def.reject(msg)
                        })
                        break;
                    case 5:
                        //查找数据
                        DataManager.select(ops, function(msg) {
                            def.resolve(msg)
                        }, function() {
                            def.reject(msg)
                        })
                        break;
                    case 6:
                        //删除表
                        DataManager.remove(ops,function(msg) {
                            def.resolve(msg)
                        }, function() {
                            def.reject(msg)
                        })
                        break;
                }
                return def.promise
            }
        }
    })
    .factory('$shareSDK', function($q, $window) {
         return {
         share: function(options) {
         var ova = $q.defer()
         share.shareSDK.share(options, function(res) {
                              ova.resolve(res)
                              }, function(res) {
                              ova.reject(res)
                              })
         return ova.promise;
         }
         }
    })
    .run(function($ionicPlatform) {
        $ionicPlatform.ready(function() {
            // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
            // for form inputs)
            if (window.cordova && window.cordova.plugins && window.cordova.plugins.Keyboard) {
                cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
                cordova.plugins.Keyboard.disableScroll(true);

            }
            if (window.StatusBar) {
                // org.apache.cordova.statusbar required
                StatusBar.styleDefault();
            }
        });
    })

.config(function($stateProvider, $urlRouterProvider) {

    // Ionic uses AngularUI Router which uses the concept of states
    // Learn more here: https://github.com/angular-ui/ui-router
    // Set up the various states which the app can be in.
    // Each state's controller can be found in controllers.js
    $stateProvider

    // setup an abstract state for the tabs directive
        .state('tab', {
        url: '/tab',
        abstract: true,
        templateUrl: 'templates/tabs.html'
    })

    // Each tab has its own nav history stack:

    .state('tab.dash', {
        url: '/dash',
        views: {
            'tab-dash': {
                templateUrl: 'templates/tab-dash.html',
                controller: 'DashCtrl'
            }
        }
    })

    .state('tab.chats', {
            url: '/chats',
            views: {
                'tab-chats': {
                    templateUrl: 'templates/tab-chats.html',
                    controller: 'ChatsCtrl'
                }
            }
        })
        .state('tab.chat-detail', {
            url: '/chats/:chatId',
            views: {
                'tab-chats': {
                    templateUrl: 'templates/chat-detail.html',
                    controller: 'ChatDetailCtrl'
                }
            }
        })

    .state('tab.account', {
        url: '/account',
        views: {
            'tab-account': {
                templateUrl: 'templates/tab-account.html',
                controller: 'AccountCtrl'
            }
        }
    });

    // if none of the above states are matched, use this as the fallback
    $urlRouterProvider.otherwise('/tab/dash');

});

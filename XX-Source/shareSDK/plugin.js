
    angular.module('hg-plugins', [])
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
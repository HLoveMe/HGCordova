
    angular.module('hg-plugins', [])
        .factory("$ImageBox", function($q) {
            return {
                loadImage: function(url, ele) {
                    var def = $q.defer()
                    ImageBox.loadImage(url, function(data) {
                        if (data == "Not Result") {
                            return; }
                        ele.src = "data:image/jpeg;base64," + data
                        def.resolve()
                    })
                    return def.promise
                },
                clear: function() {
                    var def = $q.defer()
                    ImageBox.clear(function(res) {
                        def.resolve(res)
                    })
                    return def.promise
                }
            }
        })
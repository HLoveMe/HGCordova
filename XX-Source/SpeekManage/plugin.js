angular.module('hg-plugins', [])
    .factory('$speechManage', function($q, $window) {
        return {
            languages: function() {   //支持的语言
                var ova = $q.defer();
                speechManager.supportLanguages(function(res) {
                    ova.resolve(res);
                }, function(res) {
                    ova.reject(res);
                })
                return ova.promise;
            },
            requestSpeechAuth: function(lanage) {  //请求权限
                var ova = $q.defer();
                speechManager.requestSpeechAuth(function(res) {
                    ova.resolve(res);
                }, function(res) {
                    ova.reject(res);
                }, lanage)
                return ova.promise;
            },
            startSpeech: function() {    //开始    完成,失败,ing
                var ova = $q.defer();
                speechManager.startSpeech(function(res) {
                    // ova.resolve(res);
                    if(typeof res == "string"){
                        ova.notify(res)
                    }else{
                        ova.resolve(res);
                    }
                }, function(res) {
                    ova.reject(res);
                })
                return ova.promise;
            },
            endSpeech: function() {   //结束
                var ova = $q.defer();
                speechManager.endSpeech(function(res) {
                    ova.resolve(res);
                }, function(res) {
                    ova.reject(res);
                })
                return ova.promise;
            }, 
            clear: function() {       //清理设备
                var ova = $q.defer();
                speechManager.clear(function(res) {
                    ova.resolve(res);
                }, function(res) {
                    ova.reject(res);
                })
                return ova.promise;
            },
            prepare: function(lanage) {    //默认不需要调用 在clear 再次使用 必须要调用
                var ova = $q.defer();
                speechManager.prepare(function(res) {
                    ova.resolve(res);
                }, function(res) {
                    ova.reject(res);
                }, lanage)
                return ova.promise;
            },
            audioData:function(name){   //得到文件数据
                var ova = $q.defer();
                speechManager.audioData(function(res) {
                    ova.resolve(res);
                }, function(res) {
                    ova.reject(res);
                }, [name])
                return ova.promise;
            },
            operatefiles: function(option) {   //操作文件
                var ova = $q.defer();
                speechManager.operatefiles(function(res) {
                    ova.resolve(res);
                }, function(res) {
                    ova.reject(res);
                }, option)
                return ova.promise;
            }

        }
    })
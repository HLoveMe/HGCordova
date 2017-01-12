
    angular.module('hg-plugins', [])
        .factory("$DataManager", function($q) {
            return {
                size:function () {
                    var def = $q.defer()
                    DataManager.size(function(size){
                        def.resolve(size)
                    })
                    return def.promise
                },
                operation: function(ops, type) {
                    var def = $q.defer()
                    switch (type) {
                        case 0:
                            //打开数据库 数据库是默认打开的
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
                            //保存数据
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
                            DataManager.removeTable(ops, function(msg) {
                                def.resolve(msg)
                            }, function() {
                                def.reject(msg)
                            })
                            break;
                        case 7:
                            //  清除数据库文件
                            DataManager.removeBase(function(msg) {
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
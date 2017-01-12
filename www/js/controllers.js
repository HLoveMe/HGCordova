angular.module('starter.controllers', [])

.controller('DashCtrl', function($scope, $rootScope, $DataManager) {
            
    $scope.take = function() {
        var ops = {
            table: "Person",
            data: [{
                name: "ZZH",
                age: 18,
                source: 1212,
                books: [{
                    name: "OC"
                }, {
                    name: "JAVA"
                }]
            }, {
                name: "ZZH",
                age: 18,
                source: 1213,
                books: [{
                    name: "OC"
                }]
            }]
        }
        $DataManager.operation(ops, ConnectArgs.Operation.save)
    }

    $scope.delete = function() {
        var ops = {
            table: "Person",
            args: {
                source: 1213
            }
        }
        $DataManager.operation(ops, ConnectArgs.Operation.delete)
    }

    $scope.update = function() {
        var ops = {
            table: "Person",
            args: { //修改对象满足条件
                source: 1212
            },
            source: { //修改的值
                name: "朱子豪",
                books: [{
                    name: "呵呵"
                }]
            }

        }
        $DataManager.operation(ops, ConnectArgs.Operation.update)
    }
    $scope.query = function() {
        var ops = {
            table: "Person",
            args: {
                name: "朱子豪"
            }
        }
        $DataManager.operation(ops, ConnectArgs.Operation.select).then(function(msg) {
            console.log(msg)
        }, function(msg) {
            alert(msg)
        })
    }
})

.controller('ChatsCtrl', function($scope) {
            //$ImageBox 是为了配合async使用
            //设置图片  得到缓存大小  删除缓存
        $scope.imgSrc ="http://www.bz55.com/uploads/allimg/141021/138-141021144035.jpg";
})

.controller('ChatDetailCtrl', function($scope, $stateParams) {

})

.controller('AccountCtrl', function($scope,$shareSDK) {
        $scope.share = function(){
            var options = {
            navigationColor: "#F0F",
            platforms: [
                        {
                        platform: ShareSDKArg.PlatformType.All,
                        shareType:ShareSDKArg.ContentType.Auto,
                        content: "分享到微信好友",
                        title: "HWMBBF",
                        url: "http://www.sas.com",
                        icons:[""]
                        }
                        ]
            }
            $shareSDK.share(options).then(function(msg) {
                                          alert(msg)
                                          }, function(msg) {
                                          alert(msg)
                                          })
        }
});

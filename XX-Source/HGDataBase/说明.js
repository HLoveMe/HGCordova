$scope.save = function() {

        var ops = {
            table: "Person",   //必须
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
        $DataManager.operation(ops, ConnectArgs.Course.save)
    }

    $scope.delete = function() {
        var ops = {
            table: "Person",   //必须
            args: {   //条件  [ {} ]
                source: 1213
            }
        }
        $DataManager.operation(ops, ConnectArgs.Course.delete)
    }

    $scope.update = function() {
        var ops = {
            table: "Person",     //必须
            args: { //修改对象满足条件   // [{}]
                source: 1212
            },
            source: { //修改的值
                name: "朱子豪",
                books: [{
                    name: "呵呵"
                }]
            }

        }
        $DataManager.operation(ops, ConnectArgs.Course.update)
    }
    $scope.select = function() {
        var ops = {
            table: "Person",   //必须
            orderBy:"name",  //rowid
            limit:100  , //10
            offset:0   ,  //0
            //查找条件   // {}
            args: {
                name: "朱子豪"
            }
        }
        $DataManager.operation(ops, ConnectArgs.Course.select).then(function(msg) {
            console.log(msg)
        }, function(msg) {
            alert(msg)
        })
    }

    $scope.deletTable =

    $scope.clear =

    $scope.size = fun



    .........
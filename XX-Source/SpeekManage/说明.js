只支持ios10 



$speechManage.startSpeech().then(func,errFunc,valueFunc)

$speechManage.audioData(fileName) 得到文件  base64数据

$speechManage.operatefiles({"operation":SpeechArg.GETFILES（REMOVE）|  ,  "files":[..无表示所有.] })


其他


exam:
	$speechManage.requestSpeechAuth("zh-CN").then(function (reation) {
        $speechManage.startSpeech().then(function () {
          console.log("识别结束");
        }, function () {
          console.log("识别失败、取消");
        }, function (res) {
          console.log(res)
          $scope.content = res;
        })
      }, function (reation) {
        console.log("权限失败")
      })
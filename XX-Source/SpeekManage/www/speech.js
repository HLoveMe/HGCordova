var exec = require('cordova/exec');
    var manager = {};

    //得到支持的语言
    manager.supportLanguages = function(sucFunc, errFunc) {
            exec(sucFunc, errFunc, "speechManager", "supportLanages", []);
        }
        //请求识别  录音权限  参数为识别的语言 en_US
    manager.requestSpeechAuth = function(sucFunc, errFunc, lanage) {
            if (typeof lanage != "string") { lanage = "en_US"; }
            exec(sucFunc, errFunc, "speechManager", "requestSpeech", [lanage]);
        }
        //开始录音
    manager.startSpeech = function(sucFunc, errFunc) {
        exec(sucFunc, errFunc, "speechManager", "startSpeech", []);
    }

    //结束录音
    manager.endSpeech = function(sucFunc, errFunc) {
            exec(sucFunc, errFunc, "speechManager", "endSpeech", []);
        }
        //在不需要的时候可以清理不必要资源
    manager.clear = function(sucFunc, errFunc) {
        exec(sucFunc, errFunc, "speechManager", "clear", []);
    }

    //在清理后 必须准备 才能再次地调用
    manager.prepare = function(sucFunc, errFunc, lanage) {
        if (typeof lanage != "string") { lanage = "en_US"; }
        exec(sucFunc, errFunc, "speechManager", "prepare", [lanage]);
    }
    //得到文件名 或者删除文件
    manager.operatefiles = function(sucFunc, errFunc, options) {
        exec(sucFunc, errFunc, "speechManager", "operatefiles", [options]); 
    }
    //得到录音数据
    manager.audioData = function(sucFunc, errFunc, options) {
        exec(sucFunc, errFunc, "speechManager", "getAudioFile", [options]);
    }


    module.exports = manager;
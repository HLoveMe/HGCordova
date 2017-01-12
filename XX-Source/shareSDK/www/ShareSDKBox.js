
var exec = require('cordova/exec');
var shareTool = {}
shareTool.share = function(options,successFun,errFunc){
    exec(successFun, errFunc, "ShareSDK", "share", [options]);
}
module.exports = shareTool;

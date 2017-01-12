cordova.define("hg-plugin-share.ShareSDK", function(require, exports, module) {
var exec = require('cordova/exec');
var shareTool = {}
shareTool.share = function(options,successFun,errFunc){
    exec(successFun, errFunc, "ShareSDK", "share", [options]);
}
module.exports = shareTool;
});

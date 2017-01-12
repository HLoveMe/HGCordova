cordova.define("hg-plugin-imageBox.HGImageBox", function(require, exports, module) {
var exec = require('cordova/exec');
var box = {};
box.loadImage = function(url,successFunction){
     exec(successFunction, null, "ImageBox", "loadDataWith", [url]);
};

box.clear = function(suncFun){
     exec(suncFun, null, "ImageBox", "clear", []);
};
box.cacheSize = function(suncFun){
	exec(suncFun,null,"ImageBox","cacheSize",[]);
}
module.exports = box;


});

cordova.define("hg-plugin-dataBase.dataManager", function(require, exports, module) {
var exec = require('cordova/exec');
var manager = {};
manager.openBase = function(succFun, errFunc) {
    exec(succFun, errFunc, "dataManager", "openDataBase", []);
};
manager.closeBase = function(succFun, errFunc) {
    exec(succFun, errFunc, "dataManager", "closeDataBase", []);
};
manager.saveObject = function(obj, succFun, errFunc) {
    exec(succFun, errFunc, "dataManager", "saveObject", [obj])
};
manager.saveObjects = function(obj, succFun, errFunc) {
    exec(succFun, errFunc, "dataManager", "saveObjects", [obj])
};
manager.delete = function(obj, succFun, errFunc) {
    exec(succFun, errFunc, "dataManager", "deleteObjects", [obj]);
};
manager.update = function(obj, succFun, errFunc) {
    exec(succFun, errFunc, "dataManager", "updateObjects", [obj]);
};
manager.select = function(obj, succFun, errFunc) {
    exec(succFun, errFunc, "dataManager", "selectObjects", [obj]);
};
module.exports = manager;

});

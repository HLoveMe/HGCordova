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
    if (typeof obj["args"] == "undefined") { obj["args"] = {}; }
    exec(succFun, errFunc, "dataManager", "deleteObjects", [obj]);
};
manager.update = function(obj, succFun, errFunc) {
    if (typeof obj["args"] == "undefined") { obj["args"] = {}; }
    exec(succFun, errFunc, "dataManager", "updateObjects", [obj]);
};
manager.select = function(obj, succFun, errFunc) {
    if (typeof obj["orderBy"] == "undefined") { obj["orderBy"] = "rowid"; }
    if (typeof obj["limit"] == "undefined") { obj["limit"] = 10; }
    if (typeof obj["offset"] == "undefined") { obj["offset"] = 0; }
    if (typeof obj["args"] == "undefined") { obj["args"] = {}; }
    exec(succFun, errFunc, "dataManager", "selectObjects", [obj]);
};
manager.removeTable = function(obj, succFun, errFunc) {
    exec(succFun, errFunc, "dataManager", "removeTable", [obj]);
};
manager.removeBase = function(succFun, errFunc) {
    exec(succFun, errFunc, "dataManager", "clearData", []);
};
manager.size = function(succFun, errFunc) {
    exec(succFun, errFunc, "dataManager", "sizeOfData", []);
};
module.exports = manager;

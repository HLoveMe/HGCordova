cordova.define("hg-plugin-dataBase.Connect", function(require, exports, module) {

module.exports = {
	Operation:{
		//打开数据库  默认自动开启
		openBase  : 0,
		// 关闭数据库
		closeBase : 1,
		// 保存数据
		save	  :  2,
		//删除数据
		delete    :  3,
		//更新数据
		update    :  4,
		//查找数据
		select    :  5,
		//删除表
		remove    :  6
	}
};

});

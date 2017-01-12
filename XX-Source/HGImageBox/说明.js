基础
	$ImageBox.loadData(src,imgEle)   //为图片标签设置源
	
	$ImageBox.clear().then(function(suc){})  删除本地缓存

	$ImageBox.cacheSize(func(size){})     得到数据缓存大小


结合自定义标签 内部自定设置图片源
	
	
	B:
		<img src="{{}}" / ng-src="module"  async  placeholder="module" notification="StringName">


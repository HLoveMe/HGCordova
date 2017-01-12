
	ShareSDK    导入 / 相关的库文件


1： APPDelegate  设置相关配置
2：设置白名单
3：设置url types




全平台统一样式
var options = {
	navigationColor:
	.....
	platforms:[
		{
			platform:ShareSDKArg.PlatformType.All,      YES
			/**
			 * ShareSDKArg.ContentType.Text/Image/WebPage/Auto
			 * 
			 */
			shareType:ShareSDKArg.ContentType.Auto,      NO    Auto
			content:"",									 NO    "input..." 
			title:"",									NO     APPNAME 
			url:""										NO     ""
			icons:"" | []								NO    
		}
	]
}


为各个平台设置
var options = {
	navigationColor:
	.....
	platforms:[
		{   微信 好友 / 朋友圈 /收藏 需要分开设置   
			platform:ShareSDKArg.PlatformType.WeChat                      YES 
			/**
			 * WechatSession/WechatTimeline/WechatFav
			 */
			subPlatform:ShareSDKArg.PlatformType.WechatSession,            YES 
			content:"",									                   NO    "input..."
			title:"",								                       NO     APPNAME
			url:"点击跳转URL"												   NO     ""
			thumbImage:"包内图片名称 app_icon / urlStr"					   NO      nil
			image   :"包内图片名称 app_icon / urlStr"                        NO     nil
			musicFileURL :"music url"										NO    nil
			/**
			 * ShareSDKArg.ContentType.Text/Image/WebPage/App/Audio
			 *Text :   content参数
			 * Image:   非gif图片时：填入title和image参数
			 *          如果为gif图片则需要填写title和emoticonData参数
			 * WebPage:  并设置text、title、url以及thumbImage参数(默认为image的小图)
			 * App    :并设置text、title、extInfo（可选）以及fileData（可选）参数。
			 * Audio  :并设置text、title、url以及musicFileURL（可选）参数。
			 */
			shareType: ShareSDKArg.ContentType.WebPage                     NO      WebPage
		},
		{
				platform:ShareSDKArg.PlatformType.SinaWeibo                   YES 
				content:"",									                   NO    "input..."
				title:"",								                       NO     APPNAME
				latitude:0
				longitude:0													  经纬度
				url:"附加跳转URL"		                                           ""
				image   :"包内图片名称 app_icon / urlStr" 
				//仅支持Text、Image、WebPage（客户端分享时）类型
				shareType: ShareSDKArg.ContentType.WebPage                     NO      WebPage
		}
	]
}




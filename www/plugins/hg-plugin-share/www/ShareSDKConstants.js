cordova.define("hg-plugin-share.ShareSDKArg", function(require, exports, module) {




module.exports = {
    //平台
    PlatformType:{
        //同一平台
        All                 : 999,
        /**
         *  新浪微博
         */
        SinaWeibo           : 1,
        /**
         *  腾讯微博
         */
        TencentWeibo        : 2,
        /**
         *  QQ空间
         */
        QZone            : 6,
        /**
         *  人人网
         */
        Renren              : 7,
        /**
         *  Facebook
         */
        Facebook            : 10,
        /**
         *  Twitter
         */
        Twitter             : 11,
        /**
         *  LinkedIn
         */
        LinkedIn            : 16,
        /**
         *  微信好友
         */
        WechatSession    : 22,
        /**
         *  微信朋友圈
         */
        WechatTimeline   : 23,
        /**
         *  QQ好友
         */
        QQFriend         : 24,
        /**
         *  微信收藏
         */
        WechatFav        : 37,
        /**
         *  Line
         */
        Line                : 42,
        /**
         *  WhatsApp
         */
        WhatsApp            : 43,
        /**
         *  支付宝好友
         */
        AliPaySocial        : 50,
        /**
         *  支付宝朋友圈
         */
        AliPaySocialTimeline: 51,
        /**
         *  微信平台
         */
        Wechat          :997,
         /**
         *  QQ
         */
        QQ          :998


    },
    ContentType:{
        /***  自动适配*/
        Auto:0,
        /***  文本*/
        Text:1,
        /**图片*/
        Image:2,
        /**网页*/
        WebPage:3,
        /**应用*/
        App:4,
        /**音频*/
        Audio:5,
        /**视频*/
        Video:6,
        /**文件 仅仅微信*/
        File:7
    }
}
});

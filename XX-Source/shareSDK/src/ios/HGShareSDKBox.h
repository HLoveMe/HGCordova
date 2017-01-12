//
//  ShareSDKBox.h
//  TestPro
//
//  Created by 朱子豪 on 2016/11/4.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

#import <Cordova/CDVPlugin.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDK/ShareSDK.h>
@class HGPlatform;
@interface HGShareOptions : NSObject
//导航栏颜色
@property(nonatomic,strong)UIColor *navigationColor;
//标记界面背景颜色
//@property(nonatomic,strong)UIColor *editbackColor;
//设置标题
@property(nonatomic,copy)NSString *title;
//标题颜色
@property(nonatomic,strong)UIColor *titleColor;
//取消文字
@property(nonatomic,copy)NSString *cancelTitle;
//取消文字颜色
@property(nonatomic,strong)UIColor *cancelTitleColor;
//取消按钮背景图片
@property(nonatomic,copy)NSString *cancelImage;

//确定文字
@property(nonatomic,copy)NSString *sharelTitle;
//确定文字颜色
@property(nonatomic,strong)UIColor *sharelTitleColor;
//确定按钮背景图片
@property(nonatomic,copy)NSString *shareImage;



//是否为全平台统一样式
@property(nonatomic,assign,readonly)BOOL isAllPlatform;
//平台参数
@property(nonatomic,strong)NSMutableArray<HGPlatform*> *platforms;
@end




@interface HGShareSDKBox : CDVPlugin
@property(nonatomic,strong)HGShareOptions *options;
-(void)share:(CDVInvokedUrlCommand *)command;
@end





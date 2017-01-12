
//
//  SpeekManage.h
//  HHVideo
//
//  Created by 朱子豪 on 2016/12/29.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
@interface HGSpeechManage : CDVPlugin
-(void)supportLanages:(CDVInvokedUrlCommand *)cmd;

//请求权限
-(void)requestSpeech:(CDVInvokedUrlCommand *)cmd;

//开始录音
-(void)startSpeech:(CDVInvokedUrlCommand *)cmd;
-(void)endSpeech:(CDVInvokedUrlCommand *)cmd;


//文件操作 批量操作（删除/得到文件名）
-(void)operatefiles:(CDVInvokedUrlCommand *)cmd;

//得到录音文件
-(void)getAudioFile:(CDVInvokedUrlCommand *)cmd;

//准备设备   语言  默认已经调用
//"en_US"  
-(void)prepare:(CDVInvokedUrlCommand *)cmd;
//清除不需要的资源  再次录音需要prepare
-(void)clear:(CDVInvokedUrlCommand *)cmd;
@end

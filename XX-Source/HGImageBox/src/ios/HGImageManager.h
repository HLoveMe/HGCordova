//
//  HGImageManager.h
//  PluginFac
//
//  Created by 朱子豪 on 2016/11/14.
//
//

#import <Foundation/Foundation.h>
typedef void(^imageLoadBlock)(NSData *data,NSString *callID);
#import <Cordova/CDVPlugin.h>
@interface HGImageFileBox : NSObject
+(instancetype)shareInstance;
@end
@interface HGImageManager : CDVPlugin
-(void)loadDataWith:(CDVInvokedUrlCommand *)command;

-(void)clear:(CDVInvokedUrlCommand *)command;

-(void)cacheSize:(CDVInvokedUrlCommand *)command;
@end

//
//  HGSQLManager.h
//  PluginFac
//
//  Created by 朱子豪 on 2016/11/21.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
@interface HGSQLManager : CDVPlugin
//打开数据库   在数据库插件初始时  就自动创建打开
-(void)openDataBase:(CDVInvokedUrlCommand *)command;
//关闭数据库
-(void)closeDataBase:(CDVInvokedUrlCommand *)command;

//增加
-(void)saveObject:(CDVInvokedUrlCommand *)command;
-(void)saveObjects:(CDVInvokedUrlCommand *)command;
//删除
-(void)deleteObjects:(CDVInvokedUrlCommand *)command;
//改
-(void)updateObjects:(CDVInvokedUrlCommand *)command;

//查
-(void)selectObjects:(CDVInvokedUrlCommand *)command;

//删除表
-(void)removeTable:(CDVInvokedUrlCommand *)command;

//数据库更新   未完成
-(void)updateDataManager:(CDVInvokedUrlCommand *)command;

//得到数据库文件大小
-(void)sizeOfData:(CDVInvokedUrlCommand *)command;
//移除数据库文件
-(void)clearData:(CDVInvokedUrlCommand *)command;

@end

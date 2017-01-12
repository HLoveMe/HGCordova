//
//  HGImageManager.m
//  PluginFac
//
//  Created by 朱子豪 on 2016/11/14.
//
//

#import "HGImageManager.h"
static id single;
@interface HGImageFileBox()
@property(nonatomic,strong)NSMutableDictionary *task;
@end
@implementation HGImageFileBox
-(NSMutableDictionary *)task{
    if(!_task){
        _task = [NSMutableDictionary dictionary];
    }
    return _task;
}
+(instancetype)shareInstance{
    if(!single){
        single = [[HGImageFileBox alloc]init];
    }
    return single;
}

-(void)loadImageWith:(NSString *)url callID:(NSString *)callID complete:(imageLoadBlock)block{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"HG-Cache"];
    BOOL isDir;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];

    if(!isDir){
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //是否已经在下载
    if (self.task[url]){return;}
//    if([self.task containsObject:url]){return;}
    //读取本地数据
    NSString *imgName = [url stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSArray *parts = [imgName componentsSeparatedByString:@"."];
    
    parts = [parts subarrayWithRange:NSMakeRange(parts.count-2, 2)];
    
    NSString *fileName = [parts componentsJoinedByString:@"."];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,fileName];
    
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    if(fileData){
        block(fileData,callID);
        return;
    }
    //没有本地数据
    [self.task setObject:callID forKey:url];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if(data){
            [data writeToFile:filePath atomically:YES];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            block(data,self.task[url]);
            [self.task removeObjectForKey:url];
        });
    });
}
-(void)clearCaches:(void(^)(BOOL success))block{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"HG-Cache"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *manager = [NSFileManager defaultManager];
        __block BOOL flag = YES;
        [[manager subpathsAtPath:path] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL temp = [manager removeItemAtPath:[path stringByAppendingPathComponent:obj] error:nil];
            flag = flag && temp;
        }];
        block(flag);
    });
}
-(long long)sizeForCache{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"HG-Cache"];
    __block long long size = 0;
    NSFileManager *manager = [NSFileManager defaultManager];
    [[manager subpathsAtPath:path] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *filePath = [path stringByAppendingPathComponent:obj];
        long long oneSize = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        size += oneSize;
    }];
    
    return size;
}
@end
@implementation HGImageManager
-(NSString *)toBase64:(NSData *)data{
    if(IsAtLeastiOSVersion(@"7.0")){
        if([data respondsToSelector:@selector(base64EncodedStringWithOptions:)]){
            return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        }
    }else{
        if([data respondsToSelector:@selector(base64Encoding)]){
            return [data base64Encoding];
        }
    }
    return @"Not Result";
}
-(void)loadDataWith:(CDVInvokedUrlCommand *)command{
    NSString *url = command.arguments.lastObject;
    [[HGImageFileBox shareInstance] loadImageWith:url callID:command.callbackId complete:^(NSData *data,NSString *callID) {
        NSString *resu = [self toBase64:data];
        CDVPluginResult *Result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:resu];
        [self.commandDelegate sendPluginResult:Result callbackId:callID];
    }];
}
-(void)clear:(CDVInvokedUrlCommand *)command{
    [[HGImageFileBox shareInstance] clearCaches:^(BOOL success) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            CDVPluginResult *Result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
            [self.commandDelegate sendPluginResult:Result callbackId:command.callbackId];
        });
    }];
}
-(void)cacheSize:(CDVInvokedUrlCommand *)command{
    long long size = [[HGImageFileBox shareInstance] sizeForCache];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:size];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
@end

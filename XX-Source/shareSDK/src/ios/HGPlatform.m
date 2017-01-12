//
//  HGPlatform.m
//  HWMBBF
//
//  Created by 朱子豪 on 2016/11/8.
//
//

#import "HGPlatform.h"
#import "NSDictionary+Argument.h"
#import "UIColor+NSString.h"
#import <ShareSDK/ShareSDK.h>
@implementation HGPlatform
+(instancetype)HG:(NSDictionary *)obj{
    NSAssert(NO, @"子类必须实现");
    return nil;
}
-(void)shareSetUp:(NSMutableDictionary *)par{
    NSAssert(NO, @"子类必须实现");
}
+(NSMutableArray *)platformsWith:(NSArray *)command{
    NSMutableArray *arr = [NSMutableArray array];
    
    [command enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HGPlatform *res = nil;
        SSDKPlatformType type = [[obj valueForKey:@"platform" defaultValue:@(SSDKPlatformTypeUnknown)] integerValue];
        switch (type) {
            //all
            case SSDKPlatformTypeAny:{
                res = [HGAllPlatform HG:obj];
                break;
            }
            
            case SSDKPlatformTypeWechat:{
                res = [HGWeiXin HG:obj];
                break;
            }
            case SSDKPlatformTypeSinaWeibo:{
                res = [HGWeibo HG:obj];
                break;
            }
            default:
            break;
        }
        res.content = [obj valueForKey:@"content" defaultValue:@"input..."];
        res.title = [obj valueForKey:@"title" defaultValue:[NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"]];
        res.platform = type;
        [arr addObject:res];
    }];
    
    return arr;
}
@end
@implementation HGAllPlatform
+(instancetype)HG:(NSDictionary *)obj{
    HGAllPlatform * one  = [HGAllPlatform new];
    one.shareType = [[obj valueForKey:@"shareType" defaultValue:@(SSDKContentTypeAuto)] integerValue];
    one.platform = SSDKPlatformTypeUnknown;
    one.url = [obj valueForKey:@"url" defaultValue:@""];
    id icons = [obj valueForKey:@"icons" defaultValue:nil];
    if(![icons isKindOfClass:[NSArray class]]){
        icons = @[icons];
    }
    NSFileManager *manage = [NSFileManager defaultManager];
    NSMutableArray *_icons = [NSMutableArray array];
    [icons enumerateObjectsUsingBlock:^(NSString *iconMsg, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *img = [UIImage imageNamed:iconMsg];
        if(img){
            [_icons addObject:img];
        }else if ([manage fileExistsAtPath:iconMsg]){
            [_icons addObject:iconMsg];
        }else{
            NSURL *url  = [NSURL URLWithString:iconMsg];
            if(url){
                [_icons addObject:url];
            }else{
                one.errorMsg = @"not know icons ";
                *stop = YES;
            }
        }
    }];
    one.icons = _icons;
    return one;
}
-(void)shareSetUp:(NSMutableDictionary *)par{
    [par SSDKSetupShareParamsByText:self.content images:self.icons url:[NSURL URLWithString:self.url] title:self.title type:self.shareType];
}
@end
@implementation HGWeiXin
+(instancetype)HG:(NSDictionary *)obj{
    HGWeiXin *one = [HGWeiXin new];
    
    one.subPlatform = [[obj valueForKey:@"subPlatform" defaultValue:@(SSDKPlatformTypeUnknown)] integerValue];
    if( one.subPlatform == SSDKPlatformTypeUnknown){
        one.errorMsg = @"You must have a sub platform.";
        return one;
    }
    
    one.url = [obj valueForKey:@"url" defaultValue:@""];
    
    NSString *res = [obj valueForKey:@"thumbImage" defaultValue:nil];
    one.thumbImage = [res contentFromSelf];
    
    res = [obj valueForKey:@"image" defaultValue:nil];
    
    one.image = [res contentFromSelf];
    
    one.musicFileURL = [NSURL URLWithString:[obj valueForKey:@"musicFileURL" defaultValue:nil]];
    
    
    
    one.shareType = [[obj valueForKey:@"shareType" defaultValue:@(SSDKContentTypeWebPage)] integerValue];
    return one;
}
-(void)shareSetUp:(NSMutableDictionary *)par{
    [par SSDKSetupWeChatParamsByText:self.content title:self.title url:[NSURL URLWithString:self.url ] thumbImage:self.thumbImage image:self.image musicFileURL:self.musicFileURL extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:self.shareType forPlatformSubType:self.subPlatform];
}
@end


@implementation HGWeibo
+(instancetype)HG:(NSDictionary *)dic{
    HGWeibo *bo  = [HGWeibo new];
    NSString *res =[dic valueForKey:@"image" defaultValue:@""];
    bo.image = [res contentFromSelf];
    bo.urlStr = [dic valueForKey:@"url" defaultValue:@""];
    bo.latitude = [[dic valueForKey:@"latitude" defaultValue:[NSNumber numberWithFloat:0]] doubleValue];
    bo.longitude = [[dic valueForKey:@"longitude" defaultValue:[NSNumber numberWithFloat:0]] doubleValue];
    bo.shareType = [[dic valueForKey:@"shareType" defaultValue:@(SSDKContentTypeWebPage)] integerValue];
    return bo;
}
-(void)shareSetUp:(NSMutableDictionary *)par{
    [par SSDKSetupSinaWeiboShareParamsByText:self.content title:self.title image:self.image url:[NSURL URLWithString:self.urlStr] latitude:self.latitude longitude:self.longitude objectID:nil type:self.shareType];
}
@end

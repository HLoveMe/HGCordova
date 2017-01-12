//
//  HGPlatform.h
//  HWMBBF
//
//  Created by 朱子豪 on 2016/11/8.
//
//

#import <Foundation/Foundation.h>
#import <ShareSDKUI/ShareSDKUI.h>
@interface HGPlatform : NSObject
//分享的内容
@property(nonatomic,copy)NSString *content;
//标题
@property(nonatomic,copy)NSString *title;
//平台
@property(nonatomic,assign)SSDKPlatformType platform;
//是否有错误
@property(nonatomic,copy)NSString *errorMsg;

//子类无需重写
+(NSMutableArray *)platformsWith:(NSArray *)command;

+(instancetype)HG:(NSDictionary *)dic;
-(void)shareSetUp:(NSMutableDictionary *)par;
@end


@interface HGAllPlatform : HGPlatform
//表示分享的形式  图片   文字    网页  ....
@property(nonatomic,assign)SSDKContentType shareType;
//url
@property(nonatomic,copy)NSString *url;
//icons
@property(nonatomic,strong)NSMutableArray *icons;
@end

@interface HGWeiXin : HGPlatform
//子平台
@property(nonatomic,assign)SSDKPlatformType subPlatform;
//url
@property(nonatomic,copy)NSString *url;
//缩略图   可以为UIImage、NSString（图片路径）、NSURL（图片路径）
@property(nonatomic,strong)id thumbImage;
//可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage
@property(nonatomic,strong)id image;
//音乐文件链接地址
@property(nonatomic,strong)NSURL *musicFileURL;
/**
//扩展信息
@property(nonatomic,copy)NSString *extInfo;
//文件数据，UIImage、NSString、NSURL（文件路径）
@property(nonatomic,strong)id fileData;
//表情数据， UIImage、NSURL（文件路径）
@property(nonatomic,strong)id emoticonData;
//sourceFileExtension  源文件后缀名
@property(nonatomic,copy)NSString *sourceFileExtension;
//源文件数据，可以为NSData、NSString、NSURL（文件路径
@property(nonatomic,strong)id sourceFileData;
*/
//SSDKContentTypeText、SSDKContentTypeImage、SSDKContentTypeWebPage、SSDKContentTypeApp、SSDKContentTypeAudio和SSDKContentTypeVideo
@property(nonatomic,assign)SSDKContentType shareType;
@end


@interface HGWeibo : HGPlatform
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *urlStr;
@property(nonatomic,assign)double latitude;
@property(nonatomic,assign)double longitude;
//分享类型，仅支持Text、Image、WebPage（客户端分享时）类型
@property(nonatomic,assign)SSDKContentType shareType;
@end


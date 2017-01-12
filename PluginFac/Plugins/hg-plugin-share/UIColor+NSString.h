//
//  UIColor+Hex.h
//  TestPro
//
//  Created by 朱子豪 on 2016/11/7.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+ (UIColor *) colorWithHexString: (NSString *)color ;
@end

@interface NSString (Hex)
@property(nonatomic,strong,readonly)UIColor *hexString;
//UIImage NSURL self
-(id)contentFromSelf;
@end


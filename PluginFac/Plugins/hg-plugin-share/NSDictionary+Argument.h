//
//  NSDictionary+Argument.h
//  TestPro
//
//  Created by 朱子豪 on 2016/11/7.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Argument)
-(id)valueForKey:(NSString *)key defaultValue:(id)defaultV;
@end

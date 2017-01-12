//
//  NSDictionary+Argument.m
//  TestPro
//
//  Created by 朱子豪 on 2016/11/7.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

#import "NSDictionary+Argument.h"

@implementation NSDictionary (Argument)
-(id)valueForKey:(NSString *)key defaultValue:(id)defaultV{
    id value = self[key];
    if(nil==value){
        return defaultV;
    }
    return value;
}
@end

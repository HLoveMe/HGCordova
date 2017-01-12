//
//  HGSQLConnection.m
//  PluginFac
//
//  Created by 朱子豪 on 2016/11/22.
//
//

#import "HGSQLConnection.h"

@implementation HGSQLConnection
-(NSMutableArray *)datas{
    if (nil==_datas) {
        _datas=[NSMutableArray array];
    }
    return _datas;
}
@end

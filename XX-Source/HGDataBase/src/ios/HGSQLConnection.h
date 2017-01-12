//
//  HGSQLConnection.h
//  PluginFac
//
//  Created by 朱子豪 on 2016/11/22.
//
//

#import <Foundation/Foundation.h>

@interface HGSQLConnection : NSObject
@property(nonatomic,copy)NSString *tableName;
@property(nonatomic,copy)NSString *sql;
//是否执行成功
@property(nonatomic,assign)BOOL isSuccess;
//表示data  数组
@property(nonatomic,strong)NSMutableArray *datas;
@end

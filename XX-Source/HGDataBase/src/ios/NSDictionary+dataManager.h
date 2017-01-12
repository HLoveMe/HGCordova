//
//  NSDictionary+dataManager.h
//  PluginFac
//
//  Created by 朱子豪 on 2016/11/21.
//
//

#import <Foundation/Foundation.h>
@class HGSQLConnection;
typedef enum {
    
    CREATE = 0,  //创建表
    REMOVE,  //移除表
    
    
    INERT ,//增
    DELETE,//删
    UPDATE,//改
    SELECT,//查
}FMDBType;

typedef id (^SQLBlock)(NSString *sql);

@interface NSDictionary (dataManager)

-(HGSQLConnection *)sqlWithType:(FMDBType)type table:(NSString *)table;
@end

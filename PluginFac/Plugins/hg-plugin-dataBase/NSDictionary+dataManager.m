//
//  NSDictionary+dataManager.m
//  PluginFac
//
//  Created by 朱子豪 on 2016/11/21.
//
//

#import "NSDictionary+dataManager.h"
#import "HGSQLConnection.h"
@implementation NSDictionary (dataManager)

////(id primary key,name text ,price String)
-(NSString *)options:(BOOL) isCreate{
    NSMutableString *sql=[NSMutableString stringWithString:@"( "];
    NSMutableArray *array=[NSMutableArray array];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (isCreate)
            if([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]){
                [array addObject:[NSString stringWithFormat:@"%@ blob",key]];
            }else{
                [array addObject:[NSString stringWithFormat:@"%@ text",key]];
            }
        else{
            [array addObject:[NSString stringWithFormat:@"%@ ",key]];
        }
    }];
    [sql appendString:[array componentsJoinedByString:@","]];
    [sql appendString:@" )"];
    return  sql;
}
//(name="zzh",price="66元",age=67)
-(NSString *)property:(HGSQLConnection *)con{
    //(name ,price,age)
    NSString *option= [self options:NO];
    option=[option substringWithRange:NSMakeRange(1, option.length-2)];
    NSArray *arr1=[option componentsSeparatedByString:@","];
    
    //("zzh","66元",?)
    NSString *value=[self values:con];
    value=[value substringWithRange:NSMakeRange(1, value.length-2)];
    NSArray *arr2=[value componentsSeparatedByString:@","];
    
    NSMutableArray *array=[NSMutableArray array];
    for (int i=0; i<arr1.count; i++) {
        NSString *key=arr1[i];
        NSString *valu=arr2[i];
        [array addObject:[NSString stringWithFormat:@"%@=%@",key,valu]];
    }
    NSString *str=[NSString stringWithFormat:@"(%@)",[array componentsJoinedByString:@","]];
    return str;
}
////值得集合 ("zzh","66元",?)
-(NSString *)values:(HGSQLConnection *)con{
    NSMutableArray *args = [NSMutableArray array];
    
    NSMutableString *content = [NSMutableString stringWithString:@"( "];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]){
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            [args addObject:@" ? "];
            [con.datas addObject:jsonData];
        }else if([obj isKindOfClass: [NSNumber class]]){
            [args addObject:[NSString stringWithFormat:@" %@ ",obj]];
        }else{
            [args addObject:[NSString stringWithFormat:@" '%@' ",obj]];
        }
        
    }];
    [content appendString:[args componentsJoinedByString:@","]];
    [content appendString:@" )"];
    return content;
}

-(HGSQLConnection *)sql:(NSString *)name type:(FMDBType)type{
    NSMutableString *sql = [NSMutableString string];
    NSString *tableName = [@"t_" stringByAppendingString:name];
    HGSQLConnection * sqlCon = [[HGSQLConnection alloc]init];
    switch (type) {
        case CREATE:{
            [sql appendString:@"create table if not exists "];
            [sql appendString:tableName];
            [sql appendString:[self options:YES]];
            break;
        }
        case INERT:{
            [sql appendString:@"INSERT INTO "];
            [sql appendString:tableName];
            [sql appendString:[self options:NO]];
            [sql appendString:@" values "];
            [sql appendString:[self values:sqlCon]];
            break;
        }
        case DELETE:{
            //[sql appendFormat:@" delete from t_%@ where '1' = '1' and ",clazz];
            [sql appendString:[NSString stringWithFormat:@"delete from %@ where '1' = '1' and ",tableName]];
            [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [sql appendFormat:@" %@ = '%@' ",key,obj];
                [sql appendString:@" and "];
            }];
            [sql replaceCharactersInRange:NSMakeRange(sql.length-4, 4) withString:@""];
            break;
        }
        case SELECT:{
            [sql appendFormat:@" select * from %@ where '1' = '1' and ",tableName];
            for (NSString *key in self) {
                id value = self[key];
                [sql appendFormat:@" %@ = '%@' ",key,value];
                [sql appendFormat:@" and"];
            }
            [sql replaceCharactersInRange:NSMakeRange(sql.length-4, 4) withString:@""];
            break;
        }
        case UPDATE:{
            //update t_Person set name="AAA" , age = 100   where  source=1213
            [sql appendString:[NSString stringWithFormat:@"update %@ set ",tableName]];
            [sql appendString:@" %@ "];
            [sql appendString:@" where  '1' = '1'  and "];
            for (NSString *key in self) {
                id value = self[key];
                [sql appendFormat:@" %@ = '%@' ",key,value];
                [sql appendFormat:@" and"];
            }
            [sql replaceCharactersInRange:NSMakeRange(sql.length-4, 4) withString:@""];
            break;
        }
        case REMOVE:{
            [sql appendString:@"drop table if  exists "];
            [sql appendString:tableName];
            break;
        }
        default:
            break;
    }
    sqlCon.sql =sql;
    sqlCon.tableName = tableName;
    return sqlCon;
}
-(HGSQLConnection *)sqlWithType:(FMDBType)type table:(NSString *)table{
    return [self sql:table type:type];
}



@end

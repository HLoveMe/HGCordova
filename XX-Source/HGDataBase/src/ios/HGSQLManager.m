//
//  HGSQLManager.m
//  PluginFac
//
//  Created by 朱子豪 on 2016/11/21.
//
//

#import "HGSQLManager.h"
#import "FMDB.h"
#import "NSDictionary+dataManager.h"
#import "HGSQLConnection.h"
@interface HGSQLManager()
@property(nonatomic,strong)FMDatabase *dataBase;
@property(nonatomic,copy)NSString *path;
@property(nonatomic,assign)BOOL hasOpen;
@end
@implementation HGSQLManager
-(void)pluginInitialize{
    _path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES).lastObject stringByAppendingPathComponent:@"pluginDB.db"];
    _dataBase = [FMDatabase databaseWithPath:_path];
    _hasOpen = [_dataBase open];
}
-(void)checkDataBase:(CDVInvokedUrlCommand *)command{
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Fail open dataBase"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

//开启数据库
-(void)openDataBase:(CDVInvokedUrlCommand *)command{
    _dataBase = [FMDatabase databaseWithPath:_path];
    _hasOpen = [_dataBase open];
    CDVPluginResult *result;
    if(_hasOpen){
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Success open dataBase"];
    }else{
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Fail open dataBase"];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
//关闭
-(void)closeDataBase:(CDVInvokedUrlCommand *)command{
    CDVPluginResult *result;
    _hasOpen = ![_dataBase close];
    if(_hasOpen){
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Fail close dataBase"];
    }else{
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success close dataBase"];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

//处理数据库打开之后的消息
-(void)sendResult:(CDVCommandStatus)statu msg:(id)message ID:(NSString *)callID{
    CDVPluginResult *result;
    if([message isKindOfClass:[NSString class]]){
        result = [CDVPluginResult resultWithStatus:statu messageAsString:message];
    }else if([message isKindOfClass:[NSArray class]]){
        result = [CDVPluginResult resultWithStatus:statu messageAsArray:message];
    }else if([message isKindOfClass:[NSDictionary class]]){
        result = [CDVPluginResult resultWithStatus:statu messageAsDictionary:message];
    }else{
        result = [CDVPluginResult resultWithStatus:statu messageAsDouble:[message doubleValue]];
    }
    [self.commandDelegate sendPluginResult:result callbackId:callID];
}

-(HGSQLConnection *)saveOne:(NSDictionary *)data table:(NSString *)name num:(int)count{
    HGSQLConnection *sqlCon = [data sqlWithType:INERT table:name];
    if(sqlCon.datas.count>=1){
        sqlCon.isSuccess = [_dataBase executeUpdate:sqlCon.sql withArgumentsInArray:sqlCon.datas];
    }else{
        sqlCon.isSuccess = [_dataBase executeUpdate:sqlCon.sql];
    }
    
    return sqlCon;
}
//保存
-(void)saveObject:(CDVInvokedUrlCommand *)command{
    if(!self.hasOpen){[self checkDataBase:command];return;}
    id data = command.arguments[0];
    if([data[@"data"] isKindOfClass:[NSArray class]]){[self saveObjects:command];return;}
    NSString *table = data[@"table"];
    NSDictionary *dicData = data[@"data"];
    //创建表
    HGSQLConnection *sqlCon = [dicData sqlWithType:CREATE table:table];
    BOOL flag = [self.dataBase executeUpdate:sqlCon.sql];
    if(!flag){[self sendResult:CDVCommandStatus_ERROR msg:@"create table Fail" ID:command.callbackId];return;}
    //保存数据
    BOOL suc = [[self saveOne:dicData table:table num:1] isSuccess];
    [self sendResult:suc ? CDVCommandStatus_OK :CDVCommandStatus_ERROR  msg:suc ? @"Success" : @"Fail" ID:command.callbackId];
}
-(void)saveObjects:(CDVInvokedUrlCommand *)command{
    __block BOOL isSuc = YES;
    if(!self.hasOpen){[self checkDataBase:command];return;}
    id data = command.arguments[0];
    if([data[@"data"] isKindOfClass:[NSDictionary class]]){[self saveObject:command];return;}
    NSString *table = data[@"table"];
    NSArray *arrData = data[@"data"];
    //创建表
    NSDictionary *dicData = [arrData lastObject];
    HGSQLConnection *sqlCon = [dicData sqlWithType:CREATE table:table];
    BOOL flag = [self.dataBase executeUpdate:sqlCon.sql];
    if(!flag){[self sendResult:CDVCommandStatus_ERROR msg:@"create table Fail" ID:command.callbackId];return;}
    
    //保存数据
    [_dataBase beginTransaction];
    [arrData enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HGSQLConnection *con = [self saveOne:obj table:table num:1];
        if(!con.isSuccess){
            isSuc = NO;
            *stop = YES;
        }
    }];
    if(!isSuc){
        [_dataBase rollback];
        [self sendResult:CDVCommandStatus_ERROR msg:@"Fail insert" ID:command.callbackId];
    }
    [_dataBase commit];
    [self sendResult:CDVCommandStatus_OK msg:@"Success insert" ID:command.callbackId];
}
//删除
-(void)deleteObjects:(CDVInvokedUrlCommand *)command{
    if(!self.hasOpen){[self checkDataBase:command];return;}
    NSDictionary *args = command.arguments[0];
    NSString *table = args[@"table"];
    NSDictionary *pars = args[@"args"];
    {
        //判断是否存在表是否存在   创建表
        NSString *sql = [NSString stringWithFormat:@"select count(*) as 'count' from sqlite_master where type ='table' and name = '%@'",[NSString stringWithFormat:@"t_%@",table]];
        
        FMResultSet *rs = [self.dataBase executeQuery:sql];
        if([rs next]){
            int num = [rs intForColumn:@"count"];
            if(num==0){
                //这里表示没有该表
                [self sendResult:CDVCommandStatus_OK msg:@"table not exist but it is success" ID:command.callbackId];
                return;
            }
        }
    }
    HGSQLConnection *con = [pars sqlWithType:DELETE table:table];
    con.isSuccess = [_dataBase executeUpdate:con.sql];
    if(con.isSuccess){
        [self sendResult:CDVCommandStatus_OK msg:@"delete sucess" ID:command.callbackId];
    }else{
        [self sendResult:CDVCommandStatus_ERROR msg:@"delete fail" ID:command.callbackId];
    }
}
-(NSMutableArray<NSDictionary *> *)resultFrom:(FMResultSet *)set{
    NSMutableArray *result  = [NSMutableArray array];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    while ([set next]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (int i=0; i<[set columnCount]; i++) {
            NSString *colName=[set columnNameForIndex:i];
            id value = [set objectForColumnName:colName];
            if([value isKindOfClass:[NSData class]]){
                NSString *con = [[NSString alloc]initWithData:value encoding:NSUTF8StringEncoding];
                [dic setObject:con forKey:colName];
            }else{
                NSNumber *numTemp = [numberFormatter numberFromString:value];
                if(numTemp){
                    [dic setObject:numTemp forKey:colName];
                }else{
                    [dic setObject:value forKey:colName];
                }
            }
        }
        [result addObject:dic];
    }
    return result;
}
//改
-(void)updateObjects:(CDVInvokedUrlCommand *)command{
    if(!self.hasOpen){[self checkDataBase:command];return;}
    NSDictionary *args = command.arguments[0];
    NSString *table = args[@"table"];
    NSDictionary *pars = args[@"args"];
    NSDictionary *source = args[@"source"];
    
    {
        //判断是否存在表是否存在   创建表
        FMResultSet *rs = [self.dataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?",[NSString stringWithFormat:@"t_%@",table]];
        if([rs next]){
            int num = [rs intForColumn:0];
            if(num==0){
                //这里表示没有该表
                [self sendResult:CDVCommandStatus_OK msg:@"table not exist but it is success" ID:command.callbackId];
                return;
            }
        }
    }
    
    HGSQLConnection *update = [pars sqlWithType:UPDATE table:table];
    NSString * pros = [source performSelector:@selector(property:) withObject:update];
    pros = [pros substringWithRange:NSMakeRange(1, pros.length-2)];
    update.sql = [NSString stringWithFormat:update.sql,pros];
    update.isSuccess = [_dataBase executeUpdate:update.sql withArgumentsInArray:update.datas];
    if(update.isSuccess){
        [self sendResult:CDVCommandStatus_OK msg:@"update success" ID:command.callbackId];
    }else{
        [self sendResult:CDVCommandStatus_ERROR msg:@"update Fail" ID:command.callbackId];
    }
}

-(void)selectObjects:(CDVInvokedUrlCommand *)command{
    if(!self.hasOpen){[self checkDataBase:command];return;}
    NSDictionary *args = command.arguments[0];
    NSString *table = args[@"table"];
    NSDictionary *pars = args[@"args"];
    
    int limit = [args[@"limit"] intValue];
    int offset = [args[@"offset"] intValue];
    NSString *order = args[@"orderBy"];
    
    HGSQLConnection *con = [pars sqlWithType:SELECT table:table];
    
    //select * from users order by id limit 10 offset 0;
    con.sql = [con.sql stringByAppendingFormat:@" order by %@ limit %d offset %d",order,limit,offset];
    
    FMResultSet *set = [_dataBase executeQuery:con.sql];
    if(!set){
        [self sendResult:CDVCommandStatus_ERROR msg:@"select Fail" ID:command.callbackId];
        return;
    }
    NSArray *result = [self resultFrom:set];
    [self sendResult:CDVCommandStatus_OK msg:result ID:command.callbackId];
}
-(void)removeTable:(CDVInvokedUrlCommand *)command{
    if(!self.hasOpen){[self checkDataBase:command];return;}
    NSDictionary *args = command.arguments[0];
    NSString *table = args[@"table"];
    HGSQLConnection *con = [@{} sqlWithType:REMOVE table:table];
    con.isSuccess = [_dataBase executeUpdate:con.sql];
    if(con.isSuccess){
        [self sendResult:CDVCommandStatus_OK msg:@"remove succcess" ID:command.callbackId];
    }else{
        [self sendResult:CDVCommandStatus_ERROR msg:@"remove Fail" ID:command.callbackId];
    }
}
-(void)updateDataManager:(CDVInvokedUrlCommand *)command{
    
}
-(void)sizeOfData:(CDVInvokedUrlCommand *)command{
    NSFileManager *manager = [NSFileManager defaultManager];
    long long size =  [[manager attributesOfItemAtPath:self.path error:nil] fileSize];
    [self sendResult:CDVCommandStatus_OK msg:[NSNumber numberWithLong:size] ID:command.callbackId];
}
-(void)clearData:(CDVInvokedUrlCommand *)command{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *err;
    BOOL flag = [manager removeItemAtPath:self.path error:&err];
    if(flag){
        [self sendResult:CDVCommandStatus_OK msg:@"remove base File success" ID:command.callbackId];
    }else{
        [self sendResult:CDVCommandStatus_ERROR msg:err.description ID:command.callbackId];
    }
}
@end

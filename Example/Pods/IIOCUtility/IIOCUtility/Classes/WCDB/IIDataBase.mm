//
//  IIDataBase.m
//  impcloud
//
//  Created by Jacky Zang on 2017/8/16.
//  Copyright © 2017年 Elliot. All rights reserved.
//

#import "IIDataBase.h"
#import "IIDataBaseManage.h"

@interface IIDataBase ()

@property (nonatomic, strong) WCTDatabase *db;

@end

@implementation IIDataBase

static IIDataBase *shareInstance = nil;

+ (IIDataBase *)instance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (NSString *)getDBFileName {
    return [IIDataBaseManage instance].fileNameBlock();
}

//内部添加方法需要使用self.db
- (WCTDatabase *)db {
    if (_db == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];

        _db = [[WCTDatabase alloc] initWithPath:[documentsDirectory stringByAppendingPathComponent:[self getDBFileName]]];

        NSData *password = [[IIDataBaseManage instance].wcdbPassword dataUsingEncoding:NSASCIIStringEncoding];

        [_db setCipherKey:password andCipherPageSize:1024];

        _startTime = [[NSDate date] timeIntervalSince1970];

        if(_errorPrint){
            [self registerErrorMonitor];
        }
        if(_sqlTimeCostMonitor){
            [self registerTimeMonitor];
        }

        if(_sqlPrintForTest){
            [self registerSQLPrint];
        }
    }
    return _db;
}

- (void)close {
    if(_db != nil){
        [(WCTDatabase *)_db close];
        _db = nil;
    }
}

- (BOOL)isTableExists:(NSString *)tableName {
    return [self.db isTableExists:tableName];
}

- (BOOL)createTableAndIndexesOfName:(NSString *)tableName withClass:(__unsafe_unretained Class<WCTTableCoding>)tableClass {
//    if([self isTableExists:tableName]){
//        return YES;
//    }
    return [self.db createTableAndIndexesOfName:tableName withClass:tableClass];
}

- (BOOL)insertOrReplaceObjects:(NSArray *)objects
                          into:(NSString *)tableName{

    return [self.db insertOrReplaceObjects:objects into:tableName];
}

- (BOOL)insertOrReplaceObject:(MyWCTObject *)object into:(NSString *)tableName {
    return [self.db insertOrReplaceObject:object into:tableName];
}

- (BOOL)deleteObjectsFromTable:(NSString *)tableName
                         where:(const MyWCTCondition &)condition {
    if(![self isTableExists:tableName]){
        return YES;
    }
    return [self.db deleteObjectsFromTable:tableName where:condition];
}

- (BOOL)deleteAllObjectsFromTable:(NSString *)tableName {
    if(![self isTableExists:tableName]){
        return YES;
    }
    return [self.db deleteAllObjectsFromTable:tableName];
}

- (BOOL)updateRowsInTable:(NSString *)tableName
               onProperty:(const MyWCTProperty &)property
               withObject:(MyWCTObject *)object
                    where:(const MyWCTCondition &)condition {
    if(![self isTableExists:tableName]){
        return NO;
    }
    return [self.db updateRowsInTable:tableName onProperty:property withObject:object where:condition];
}

- (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                        fromTable:(NSString *)tableName
                                          orderBy:(const MyWCTOrderByList &)orderList {
    if(![self isTableExists:tableName]){
        return [[NSArray alloc] init];
    }
    return [self.db getObjectsOfClass:cls fromTable:tableName orderBy:orderList];
}

- (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                        fromTable:(NSString *)tableName
                                          orderBy:(const MyWCTOrderByList &)orderList
                                            limit:(const MyWCTLimit &)limit
                                           offset:(const MyWCTOffset &)offset{
    if(![self isTableExists:tableName]){
        return [[NSArray alloc] init];
    }
    return [self.db getObjectsOfClass:cls fromTable:tableName orderBy:orderList limit:limit offset:offset];
}

- (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                        fromTable:(NSString *)tableName
                                            where:(const MyWCTCondition &)condition
                                          orderBy:(const MyWCTOrderByList &)orderList {
    if(![self isTableExists:tableName]){
        return [[NSArray alloc] init];
    }
    return [self.db getObjectsOfClass:cls fromTable:tableName where:condition orderBy:orderList];
}

- (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                        fromTable:(NSString *)tableName
                                            where:(const MyWCTCondition &)condition
                                          orderBy:(const MyWCTOrderByList &)orderList
                                            limit:(const MyWCTLimit &)limit{
    if(![self isTableExists:tableName]){
        return [[NSArray alloc] init];
    }
    return [self.db getObjectsOfClass:cls fromTable:tableName where:condition orderBy:orderList limit:limit];
}

/// 分页查询多行数据
- (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                        fromTable:(NSString *)tableName
                                            where:(const MyWCTCondition &)condition
                                          orderBy:(const MyWCTOrderByList &)orderList
                                            limit:(const MyWCTLimit &)limit
                                           offset:(const WCTOffset &)offset {
    if(![self isTableExists:tableName]){
        return [[NSArray alloc] init];
    }
    return [self.db getObjectsOfClass:cls fromTable:tableName where:condition orderBy:orderList limit:limit offset:offset];
}

/// 查询多行数据
- (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                        fromTable:(NSString *)tableName
                                            where:(const MyWCTCondition &)condition
                                            limit:(const MyWCTLimit &)limit {
    if(![self isTableExists:tableName]){
        return [[NSArray alloc] init];
    }
    return [self.db getObjectsOfClass:cls fromTable:tableName where:condition  limit:limit];
}

/// 查询多行数据
- (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                        fromTable:(NSString *)tableName
                                          orderBy:(const MyWCTOrderByList &)orderList
                                            limit:(const MyWCTLimit &)limit {
    if(![self isTableExists:tableName]){
        return [[NSArray alloc] init];
    }
    return [self.db getObjectsOfClass:cls fromTable:tableName orderBy:orderList limit:limit];
}

- (id /* WCTObject* */)getOneObjectOfClass:(Class)oneClass fromTable:(NSString *)tableName where:(const MyWCTCondition &)whereCondition {
    if(![self isTableExists:tableName]){
        return nil;
    }
    return [self.db getOneObjectOfClass:oneClass fromTable:tableName where:whereCondition];
}

- (NSArray /* <WCTObject*> */ *)getAllObjectsOfClass:(Class)cls
                                           fromTable:(NSString *)tableName {
    if(![self isTableExists:tableName]){
        return [[NSArray alloc] init];
    }
    return [self.db getAllObjectsOfClass:cls fromTable:tableName];
}

- (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                        fromTable:(NSString *)tableName
                                            where:(const MyWCTCondition &)condition {
    if(![self isTableExists:tableName]){
        return [[NSArray alloc] init];
    }
    return [self.db getObjectsOfClass:cls fromTable:tableName where:condition];
}

- (NSArray /* <WCTValue *> */*)getOneColumnOnResult:(const WCTResult &)result
                                          fromTable:(NSString *)tableName {
    if(![self isTableExists:tableName]){
        return [[NSArray alloc] init];
    }
    WCTOneColumn *objects = [self.db getOneColumnOnResult:result
                                                fromTable:tableName];
    return [[NSArray alloc] initWithArray:objects];
}
- (NSArray /* <WCTValue *> */*)getOneColumnOnResult:(const WCTResult &)result
                                          fromTable:(NSString *)tableName
                                              where:(const MyWCTCondition &)condition
                                              limit:(const MyWCTLimit &)limit{
    if(![self isTableExists:tableName]){
        return [[NSArray alloc] init];
    }
    WCTOneColumn *objects = [self.db getOneColumnOnResult:result
                                                fromTable:tableName where:condition limit:limit];
    return [[NSArray alloc] initWithArray:objects];
}
- (NSArray /* <WCTValue *> */*)getOneColumnOnResult:(const WCTResult &)result
                                          fromTable:(NSString *)tableName
                                              where:(const MyWCTCondition &)condition
                                            orderBy:(const MyWCTOrderByList &)orderList{
    if(![self isTableExists:tableName]){
        return [[NSArray alloc] init];
    }
    WCTOneColumn *objects = [self.db getOneColumnOnResult:result
                                                fromTable:tableName where:condition orderBy:orderList];
    return [[NSArray alloc] initWithArray:objects];
}
- (NSArray /* <WCTValue *> */*)getOneColumnOnResult:(const WCTResult &)result
                                          fromTable:(NSString *)tableName
                                              where:(const MyWCTCondition &)condition
                                            orderBy:(const MyWCTOrderByList &)orderList
                                              limit:(const MyWCTLimit &)limit {
    if(![self isTableExists:tableName]){
        return [[NSArray alloc] init];
    }
    WCTOneColumn *objects = [self.db getOneColumnOnResult:result
                                                fromTable:tableName where:condition orderBy:orderList limit:limit];
    return [[NSArray alloc] initWithArray:objects];
}
- (NSArray /* <WCTValue *> */*)getOneColumnOnResult:(const WCTResult &)result
                                          fromTable:(NSString *)tableName
                                              where:(const MyWCTCondition &)condition
                                            orderBy:(const MyWCTOrderByList &)orderList
                                              limit:(const MyWCTLimit &)limit
                                             offset:(const WCTOffset &)offset{
    if(![self isTableExists:tableName]){
        return [[NSArray alloc] init];
    }
    WCTOneColumn *objects = [self.db getOneColumnOnResult:result
                                                fromTable:tableName where:condition orderBy:orderList limit:limit offset:offset];
    return [[NSArray alloc] initWithArray:objects];
}

- (BOOL)insertOrReplaceObjectsByTransaction:(NSArray *)objects into:(NSString *)tableName {
    BOOL ret = [self.db beginTransaction];
    if(!ret){
        return ret;
    }
    ret = [self.db insertOrReplaceObjects:objects into:tableName];

    if (ret) {
        ret = [self.db commitTransaction];
        return ret;
    } else {
        [self.db rollbackTransaction];
        return NO;
    }
}

- (BOOL)deleteObjectsFromTableByTransaction:(NSString *)tableName
                                      where:(const MyWCTCondition &)condition {
    BOOL ret = [self.db beginTransaction];
    if(!ret){
        return ret;
    }
    ret = [self.db deleteObjectsFromTable:tableName where:condition];

    if (ret) {
        ret = [self.db commitTransaction];
        return ret;
    } else {
        [self.db rollbackTransaction];
        return NO;
    }
}

- (BOOL)transactionWithInsertObjects:(NSArray *)objects insertInto:(NSString *)insertTableName deleteObjectsFrom:(NSString *)deleteTableName deleteWhere:(const MyWCTCondition &)condition {

    BOOL ret = [self.db beginTransaction];
    if(!ret){
        return ret;
    }
    ret = [self.db insertOrReplaceObjects:objects into:insertTableName];
    if(!ret){
        [self.db rollbackTransaction];
        return NO;
    }
    ret = [self.db deleteObjectsFromTable:deleteTableName where:condition];
    if (ret) {
        ret = [self.db commitTransaction];
        return ret;
    } else {
        [self.db rollbackTransaction];
        return NO;
    }
}

- (void)registerErrorMonitor {
    [WCTStatistics SetGlobalErrorReport:^(WCTError *error) {
        NSLog(@"[WCDB]%@", error);
        if(error.description != nil) {
            //临时注释掉，等AOP拆分后，再打开
//            WCDBEvent *event = [[WCDBEvent alloc] init];
//            [event setBaseInfoWithErrorInfo: error.description];
//            [[AOPNBPCoreManagerCenter getInstance] writeCustomLogWithEvent:event];
        }
    }];
}

- (void)registerTimeMonitor {
    [WCTStatistics SetGlobalPerformanceTrace:^(WCTTag tag, NSDictionary<NSString *, NSNumber *> *sqls, NSInteger cost) {
        //        NSLog(@"Tag: %d", tag);
        [sqls enumerateKeysAndObjectsUsingBlock:^(NSString *sql, NSNumber *count, BOOL *) {
            NSLog(@"SQL: %@ Count: %d", sql, count.intValue);
        }];
        NSLog(@"Total cost %ld nanoseconds", (long) cost);
    }];
}

- (void)registerSQLPrint {
    //SQL Execution Monitor
    [WCTStatistics SetGlobalSQLTrace:^(NSString *sql) {
        NSLog(@"SQL: %@", sql);
    }];
}
@end

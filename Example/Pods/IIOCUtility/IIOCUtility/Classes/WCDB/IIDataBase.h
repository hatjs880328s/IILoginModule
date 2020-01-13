//
//  IIDataBase.h
//  impcloud
//
//  Created by Jacky Zang on 2017/8/16.
//  Copyright © 2017年 Elliot. All rights reserved.
//

#import <WCDB/WCDB.h>

typedef WCTCondition MyWCTCondition;
typedef WCTOrderByList MyWCTOrderByList;
typedef WCTLimit MyWCTLimit;
typedef WCTProperty MyWCTProperty;
typedef WCTObject MyWCTObject;
typedef WCTOffset MyWCTOffset;

@interface IIDataBase : NSObject

///数据库启动时间
@property (assign, nonatomic) NSTimeInterval startTime;

///调试参数 是否开启SQL耗时监控
@property (assign, nonatomic) BOOL sqlTimeCostMonitor;

///调试参数 是否打印SQL语句
@property (assign, nonatomic) BOOL sqlPrintForTest;

///调试参数 是否打印错误提示
@property (assign, nonatomic) BOOL errorPrint;


+ (IIDataBase *)instance;

///关闭数据库
- (void)close;

/// 创建表
- (BOOL)createTableAndIndexesOfName:(NSString *)tableName withClass:(__unsafe_unretained Class<WCTTableCoding>)tableClass;

/// 批量插入|替换models
- (BOOL)insertOrReplaceObjects:(NSArray *)objects into:(NSString *)tableName;

/// 插入|替换单个model
- (BOOL)insertOrReplaceObject:(MyWCTObject *)object into:(NSString *)tableName;

/// 删除符合条件的数据
- (BOOL)deleteObjectsFromTable:(NSString *)tableName
                         where:(const MyWCTCondition &)condition;
/// 删除表中所有数据
- (BOOL)deleteAllObjectsFromTable:(NSString *)tableName;

/// 修改某列数据
- (BOOL)updateRowsInTable:(NSString *)tableName
               onProperty:(const MyWCTProperty &)property
               withObject:(MyWCTObject *)object
                    where:(const MyWCTCondition &)condition;
/// 查询多行数据
- (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                        fromTable:(NSString *)tableName
                                          orderBy:(const MyWCTOrderByList &)orderList;
/// 查询多行数据 可用于分页查询
- (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                        fromTable:(NSString *)tableName
                                          orderBy:(const MyWCTOrderByList &)orderList
                                            limit:(const MyWCTLimit &)limit
                                           offset:(const MyWCTOffset &)offset;

/// 查询多行数据 可用于分页查询 
- (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                        fromTable:(NSString *)tableName
                                            where:(const MyWCTCondition &)condition
                                          orderBy:(const MyWCTOrderByList &)orderList
                                            limit:(const MyWCTLimit &)limit
                                           offset:(const WCTOffset &)offset;

/// 查询多行数据
- (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                        fromTable:(NSString *)tableName
                                            where:(const MyWCTCondition &)condition;
/// 查询多行数据
- (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                        fromTable:(NSString *)tableName
                                            where:(const MyWCTCondition &)condition
                                          orderBy:(const MyWCTOrderByList &)orderList;
/// 查询多行数据
- (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                        fromTable:(NSString *)tableName
                                            where:(const MyWCTCondition &)condition
                                          orderBy:(const MyWCTOrderByList &)orderList
                                            limit:(const MyWCTLimit &)limit;

/// 查询多行数据
- (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                        fromTable:(NSString *)tableName
                                            where:(const MyWCTCondition &)condition
                                            limit:(const MyWCTLimit &)limit;

/// 查询多行数据
- (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                        fromTable:(NSString *)tableName
                                          orderBy:(const MyWCTOrderByList &)orderList
                                            limit:(const MyWCTLimit &)limit;
/// 查询单条数据
- (id /* WCTObject* */)getOneObjectOfClass:(Class)oneClass fromTable:(NSString *)tableName where:(const MyWCTCondition &)whereCondition;

/// 查询表中所有数据
- (NSArray /* <WCTObject*> */ *)getAllObjectsOfClass:(Class)cls
                                           fromTable:(NSString *)tableName;

/// 查询单列数据
- (NSArray /* <WCTValue *> */*)getOneColumnOnResult:(const WCTResult &)result
                                          fromTable:(NSString *)tableName;
/// 查询单列数据
- (NSArray /* <WCTValue *> */*)getOneColumnOnResult:(const WCTResult &)result
                                          fromTable:(NSString *)tableName
                                              where:(const MyWCTCondition &)condition
                                              limit:(const MyWCTLimit &)limit;
/// 查询单列数据
- (NSArray /* <WCTValue *> */*)getOneColumnOnResult:(const WCTResult &)result
                                          fromTable:(NSString *)tableName
                                              where:(const MyWCTCondition &)condition
                                            orderBy:(const MyWCTOrderByList &)orderList;
/// 查询单列数据
- (NSArray /* <WCTValue *> */*)getOneColumnOnResult:(const WCTResult &)result
                                          fromTable:(NSString *)tableName
                                              where:(const MyWCTCondition &)condition
                                            orderBy:(const MyWCTOrderByList &)orderList
                                              limit:(const MyWCTLimit &)limit;
/// 查询单列数据
- (NSArray /* <WCTValue *> */*)getOneColumnOnResult:(const WCTResult &)result
                                          fromTable:(NSString *)tableName
                                              where:(const MyWCTCondition &)condition
                                            orderBy:(const MyWCTOrderByList &)orderList
                                              limit:(const MyWCTLimit &)limit
                                             offset:(const WCTOffset &)offset;

/// 使用事务批量插入|替换models，失败自动回滚
- (BOOL)insertOrReplaceObjectsByTransaction:(NSArray *)objects into:(NSString *)tableName;

/// 使用事务批量删除数据，失败自动回滚
- (BOOL)deleteObjectsFromTableByTransaction:(NSString *)tableName
                                      where:(const MyWCTCondition &)condition;

/// 使用事务批量插入和删除数据，失败自动回滚
- (BOOL)transactionWithInsertObjects:(NSArray *)objects insertInto:(NSString *)insertTableName deleteObjectsFrom:(NSString *)deleteTableName deleteWhere:(const MyWCTCondition &)condition;

@end

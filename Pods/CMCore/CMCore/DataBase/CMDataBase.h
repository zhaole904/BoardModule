//
//  CMDataBase.h
//  CMCore
//
//  Created by PengTao on 2017/11/30.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMDataBase : NSObject

@property(readonly, nonatomic, copy) NSString *path; ///< 数据库路径

/// 初始化数据库(若无则创建数据库)
- (instancetype)initWithPath:(NSString *)path;

/// 最后一条错误信息
@property(readonly, nonatomic) NSError *lastError;

- (void)open;
- (void)close;
- (BOOL)rollback; ///< 滚回

/// 执行更新(CREATE、UPDATE、DELETE...)
- (BOOL)executeUpdate:(NSString *)sql, ...;
/// 执行查询
- (NSArray *_Nullable)executeQuery:(NSString *)sql, ...;

@end

@interface CMDataBase (ThreadSafe)

/// 是否正在开启事务
@property(readonly, nonatomic) BOOL isInTransaction;

/// 多线程调用通过此方法调用
- (void)inDatabase:(void (^)(CMDataBase *db))block;
/// 事务开启
- (void)inTransaction:(void (^)(CMDataBase *db, BOOL *rollback))block;

@end

@interface CMDataBase (Table)

/// 是否存在某张表
- (BOOL)tableExists:(NSString *)tableName;

@end

NS_ASSUME_NONNULL_END

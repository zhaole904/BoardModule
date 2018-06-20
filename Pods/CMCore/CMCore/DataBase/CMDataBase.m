//
//  CMDataBase.m
//  CMCore
//
//  Created by PengTao on 2017/11/30.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#import <FMDB/FMDB.h>
#import "CMDataBase.h"

@interface FMDatabaseQueue ()
@property(readonly, nonatomic) FMDatabase *dataBase;
@end

@interface CMDataBase ()
@property(readonly, nonatomic, strong) FMDatabaseQueue *dbQueue;
@end

@implementation CMDataBase

@dynamic path, lastError;

- (instancetype)initWithPath:(NSString *)path {
	if (self = [super init]) {
		_dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
	}
	return self;
}

- (void)open {
	[_dbQueue.dataBase open];
}
- (void)close {
	[_dbQueue close];
}

- (BOOL)rollback {
	return [self.dbQueue.dataBase rollback];
}

- (BOOL)executeUpdate:(NSString *)sql, ... {
	va_list args;
	va_start(args, sql);
	
	BOOL result = [self.dbQueue.dataBase executeUpdate:sql withVAList:args];
	
	va_end(args);
	return result;
}
- (NSArray *_Nullable)executeQuery:(NSString *)sql, ... {
	va_list args;
	va_start(args, sql);
	
	FMResultSet *result = [self.dbQueue.dataBase executeQuery:sql withVAList:args];
	
	va_end(args);
	
	NSMutableArray *infoArray = [NSMutableArray array];
	while ([result next]) {
		[infoArray addObject:result.resultDictionary];
	}
	return infoArray.count > 0 ? infoArray : nil;
	
}

#pragma mark - ThreadSafe

- (BOOL)isInTransaction {
	return self.dbQueue.dataBase.isInTransaction;
}

- (void)inDatabase:(void (^)(CMDataBase * _Nonnull))block {
	if (block) {
		[self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
			block(self);
		}];
	}
}

- (void)inTransaction:(void (^)(CMDataBase * _Nonnull, BOOL * _Nonnull))block {
	if (block) {
		[self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
			block(self, rollback);
		}];
	}
}

#pragma mark - Table

- (BOOL)tableExists:(NSString *)tableName {
	return [self.dbQueue.dataBase tableExists:tableName];
}

#pragma mark -

- (NSString *)path {
	return _dbQueue.path;
}

- (NSError *)lastError {
	if (!self.dbQueue.dataBase.hadError) {
		return nil;
	}
	NSDictionary *errorMessage = [NSDictionary dictionaryWithObject:self.dbQueue.dataBase.lastErrorMessage forKey:NSLocalizedDescriptionKey];
	NSInteger errorCode = self.dbQueue.dataBase.lastErrorCode;
	return [NSError errorWithDomain:@"CMDataBase" code:errorCode userInfo:errorMessage];
}

@end

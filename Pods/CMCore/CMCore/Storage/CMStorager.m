//
//  CMStorager.m
//  CMCore
//
//  Created by PengTao on 2018/1/6.
//  Copyright © 2018年 CMFT Co.,Ltd. All rights reserved.
//

#import <objc/runtime.h>
#import "CMStorager.h"
#import "CMCrypto.h"
#import "CMDataBase.h"

static NSString *const kPublicUserFileName 		= @"Public";
static NSString *const kUserDBName 				= @"base.db";
static NSString *const kUserFilePathTableName 	= @"FilePath";

@interface CMStorager ()
@property(nonatomic, strong) CMDataBase *baseDB;
@end

@implementation CMStorager

- (void)dealloc {
	[_baseDB close];
}

- (instancetype)initWithRootPath:(NSString *)path {
	if (self = [super init]) {
		_rootPath = path.copy;
	}
	return self;
}

- (NSString *)filePathForKey:(NSString *)key {
	if (!key || key.length == 0) {
		return nil;
	}
	
	NSString *path = [self pathInDBWithKey:key];
	if (!path) {
		// 生成路径
		NSString *fileID = key.cm_MD5String;
		NSString *firstDir = [fileID substringWithRange:NSMakeRange(0, 2)];
		NSString *secondDir = [fileID substringWithRange:NSMakeRange(2, 2)];
		path = [NSString stringWithFormat:@"%@/%@/%@/%@", _rootPath, firstDir, secondDir, key];
	}
	
	return path;
}

- (BOOL)fileExistsWithKey:(NSString *)key {
	BOOL result = NO;
	NSString *path = [self pathInDBWithKey:key];
	if (!path) {
		result = [NSFileManager.defaultManager fileExistsAtPath:[self filePathForKey:key]];
	}
	return result;
}

- (BOOL)copyFilePath:(NSString *)fromPath withKey:(NSString *)key {
	NSString *path = [self filePathForKey:key];
	BOOL result = [NSFileManager.defaultManager copyItemAtPath:fromPath toPath:[self filePathForKey:key] error:nil];
	[self insertFilePath:path key:key];
	return result;
}
- (BOOL)moveFilePath:(NSString *)fromPath withKey:(NSString *)key {
	NSString *path = [self filePathForKey:key];
	BOOL result = [NSFileManager.defaultManager moveItemAtPath:fromPath toPath:path error:nil];
	[self insertFilePath:path key:key];
	return result;
}

- (NSData *)contentsWithKey:(NSString *)key {
	NSString *path = [self filePathForKey:key];
	return [NSData dataWithContentsOfFile:path];
}
- (BOOL)saveContents:(NSData *)contents withKey:(NSString *)key {
	NSString *path = [self filePathForKey:key];
	BOOL result = [NSFileManager.defaultManager createFileAtPath:path contents:contents attributes:nil];
	[self insertFilePath:path key:key];
	return result;
}

#pragma mark - DB

- (CMDataBase *)baseDB {
	if (!_baseDB) {
		_baseDB = [[CMDataBase alloc] initWithPath:[NSString stringWithFormat:@"%@/%@", _rootPath, kUserDBName]];
		[self createFilePathTable];
	}
	return _baseDB;
}

- (void)createFilePathTable {
	if (![_baseDB tableExists:kUserFilePathTableName]) {
		NSString *sql = [NSString stringWithFormat:@"create table %@ ("
						 "id integer primary key autoincrement"
						 ",insertTime timestamp"
						 ",updateTime timestamp"
						 ",path varchar(255)"
						 ",fileName varchar(255)"
						 "unique（id, fileName)"
						 ")"
						 , kUserFilePathTableName];
		[_baseDB executeUpdate:sql];
	}
}

- (BOOL)insertFilePath:(NSString *)path key:(NSString *)key {
	NSString *sql = [NSString stringWithFormat:@"insert or update into %@ (insertTime, path, fileName) VALUES (?,?,?)", kUserFilePathTableName];
	return [self.baseDB executeUpdate:sql, NSDate.date, path, key];
}

- (NSString *)pathInDBWithKey:(NSString *)key {
	if (!key || key.length == 0) {
		return nil;
	} else {
		NSString *columnName = @"path";
		NSString *sql = [NSString stringWithFormat:@"select %@ from %@ where fileName=%@", columnName, kUserFilePathTableName, key];
		NSArray *arr = [self.baseDB executeQuery:sql];
		NSDictionary *info = arr.firstObject;
		return info[columnName];
	}
}

@end

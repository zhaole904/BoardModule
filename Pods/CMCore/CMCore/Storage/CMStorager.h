//
//  CMStorager.h
//  CMCore
//
//  Created by PengTao on 2018/1/6.
//  Copyright © 2018年 CMFT Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 存储器
@interface CMStorager : NSObject

/// 根路径
@property(readonly, nonatomic, copy) NSString *rootPath;
/// 以跟路径初始化
- (instancetype)initWithRootPath:(NSString *)path;

/// 根据 key 判断文件是否存在
- (BOOL)fileExistsWithKey:(NSString *)key;

/// 根据 key 查找或生成路径
- (NSString *_Nullable)filePathForKey:(NSString *)key;

/// 复制文件
- (BOOL)copyFilePath:(NSString *)fromPath withKey:(NSString *)key;
/// 移动文件
- (BOOL)moveFilePath:(NSString *)fromPath withKey:(NSString *)key;

/// 获取数据
- (NSData *_Nullable)contentsWithKey:(NSString *)key;
/// 保存数据
- (BOOL)saveContents:(NSData *)contents withKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

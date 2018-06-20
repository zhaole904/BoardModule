//
//  CMCompression.h
//  CMCore
//
//  Created by PengTao on 2017/11/23.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 压缩器协议
@protocol CMCompressor <NSObject>

/**
 校验某个 Data 是否被压缩过

 @param data 被校验的Data
 @return 	 是否被压缩过
 */
+ (BOOL)isCompressedWithData:(NSData *)data;

/**
 压缩 Data 数据

 @param data  需压缩的Data数据
 @param error 错误信息
 @return 	  压缩后的Data数据
 */
+ (NSData *_Nullable)dataCompressedWithData:(NSData *)data error:(NSError *__autoreleasing *)error;

/**
 解压 Data 数据

 @param data  需解压的Data数据
 @param error 错误信息
 @return 	  解压后的Data数据
 */
+ (NSData *_Nullable)dataDecompressedWithData:(NSData *)data error:(NSError *__autoreleasing *)error;

/**
 压缩文件
 
 @param sourceFile 		源文件地址
 @param destinationFile 压缩文件存储地址
 @param error 			错误信息
 @return 				是否压缩成功
 */
+ (BOOL)compressFile:(NSURL *)sourceFile toFile:(NSURL *)destinationFile error:(NSError *__autoreleasing *)error;

/**
 解压文件

 @param sourceFile 		源文件地址
 @param destinationFile 解压文件存储地址
 @param error 			错误信息
 @return 				是否解压成功
 */
+ (BOOL)decompressFile:(NSURL *)sourceFile toFile:(NSURL *)destinationFile error:(NSError *__autoreleasing *)error;

@end


/// GZip压缩器
@interface CMGZipCompressor : NSObject <CMCompressor>


/**
 解压 Data 数据

 @param data 		需解压的Data数据
 @param level 		压缩等级(0-9): 0不压缩，9最大压缩，压缩越大解压越慢，默认压缩等级Z_DEFAULT_COMPRESSION
 @param windowBits 	窗口大小：windowBits越大压缩效果越好。The base two logarithm of the window size (the size of the history buffer). Larger values of this parameter result in better compression at the expense of memory usage.
 @param memLevel 	内存占用等级(0-8)：内存占用等级越高压缩越快，默认等级8
 @param strategy 	压缩策略：默认策略Z_DEFAULT_STRATEGY
 @param error 		错误信息
 @return 			解压后的Data数据
 */
+ (NSData *_Nullable)dataCompressedWithData:(NSData *)data
						   atLevel:(int)level
						windowBits:(int)windowBits
					   memoryLevel:(int)memLevel
						  strategy:(int)strategy
							 error:(NSError *__autoreleasing *)error;

/**
 解压 Data 数据

 @param data 		需解压的Data数据
 @param windowBits 	窗口大小：需与压缩是的一致
 @param error 		错误信息
 @return 			解压后的Data数据
 */
+ (NSData *_Nullable)dataDecompressedWithData:(NSData *)data windowBits:(int)windowBits error:(NSError **)error;

/**
 压缩文件
 
 @param sourceFile 		源文件地址
 @param destinationFile 压缩文件存储地址
 @param level 			压缩等级(0-9): 0不压缩，9最大压缩，压缩越大解压越慢，Z_DEFAULT_COMPRESSION默认压缩等级
 @param error 			错误信息
 @return 				是否压缩成功
 */
+ (BOOL)compressFile:(NSURL *)sourceFile
			  toFile:(NSURL *)destinationFile
			 atLevel:(int)level
			   error:(NSError *__autoreleasing *)error;

@end

@interface NSData (CMCompressor)

/**
 Data的GZip压缩

 @param error 错误信息
 @return 压缩后的Data数据
 */
- (NSData *_Nullable)cm_dataCompressedByGZipWithError:(NSError *__autoreleasing *)error;

/**
 Data 的 GZip 压缩
 
 @param level 		压缩等级(0-9): 0不压缩，9最大压缩，压缩越大解压越慢，默认压缩等级Z_DEFAULT_COMPRESSION
 @param windowBits 	窗口大小：windowBits越大压缩效果越好。The base two logarithm of the window size (the size of the history buffer). Larger values of this parameter result in better compression at the expense of memory usage.
 @param memLevel 	内存占用等级(0-8)：内存占用等级越高压缩越快，默认等级8
 @param strategy 	压缩策略：默认策略Z_DEFAULT_STRATEGY
 @param error 		错误信息
 @return 			解压后的Data数据
 */
- (NSData *_Nullable)cm_dataCompressedByGZipAtLevel:(int)level
										 windowBits:(int)windowBits
										memoryLevel:(int)memLevel
										   strategy:(int)strategy
											  error:(NSError *__autoreleasing *)error;

/**
 Data的GZip解缩

 @param error 错误信息
 @return 解压后的Data数据
 */
- (NSData *_Nullable)cm_dataDecompressedByGZipWithError:(NSError *__autoreleasing *)error;

/**
 Data的GZip解缩

 @param windowBits 	窗口大小：windowBits越大压缩效果越好。The base two logarithm of the window size (the size of the history buffer). Larger values of this parameter result in better compression at the expense of memory usage.
 @param error 错误信息
 @return 解压后的Data数据
 */
- (NSData *_Nullable)cm_dataDecompressedByGZipWithWindowBits:(int)windowBits error:(NSError *__autoreleasing *)error;

@end

FOUNDATION_EXPORT NSString *const CMCompressorErrorDomain; ///< 压缩错误域

NS_ASSUME_NONNULL_END

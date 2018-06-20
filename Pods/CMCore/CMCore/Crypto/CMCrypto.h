//
//  CMCrypto.h
//  CMCore
//
//  Created by PengTao on 2017/11/24.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMCryptor : NSObject

/**
 AES 加密

 @param string 被加密字符串
 @param key 密钥(Data或String，若是String会被转成UTF8的Data)
 @param iv 初始化偏移向量(Data或String，若是String会被转成UTF8的Data)
 @param error 错误信息
 @return 加密后字符串
 */
+ (NSString *)stringEncryptedByAESWithString:(NSString *)string key:(id)key iv:(id)iv error:(NSError **)error;

/**
 AES 解密

 @param string 需解密字符串
 @param key 密钥(Data或String，若是String会被转成UTF8的Data)
 @param iv 初始化偏移向量(Data或String，若是String会被转成UTF8的Data)
 @param error 错误信息
 @return 解密后字符串
 */
+ (NSString *)stringDecryptedByAESWithString:(NSString *)string key:(id)key iv:(id)iv error:(NSError **)error;


/**
 AES 加密

 @param data 被加密Data
 @param key 密钥(Data或String，若是String会被转成UTF8的Data)
 @param iv 初始化偏移向量(Data或String，若是String会被转成UTF8的Data)
 @param error 错误信息
 @return 加密后Data
 */
+ (NSData *)dataEncryptedByAESWithData:(NSData *)data key:(id)key iv:(id)iv error:(NSError **)error;


/**
 AES 解密

 @param data 需解Data
 @param key 密钥(Data或String，若是String会被转成UTF8的Data)
 @param iv 初始化偏移向量(Data或String，若是String会被转成UTF8的Data)
 @param error 错误信息
 @return 解密后Data
 */
+ (NSData *)dataDecryptedByAESWithData:(NSData *)data key:(id)key iv:(id)iv error:(NSError **)error;


/**
 DES 加密
 
 @param string 被加密字符串
 @param key 密钥(Data或String，若是String会被转成UTF8的Data)
 @param iv 初始化偏移向量(Data或String，若是String会被转成UTF8的Data)
 @param error 错误信息
 @return 加密后字符串
 */
+ (NSString *)stringEncryptedByDESWithString:(NSString *)string key:(id)key iv:(id)iv error:(NSError **)error;


/**
 DES 解密
 
 @param string 需解密字符串
 @param key 密钥(Data或String，若是String会被转成UTF8的Data)
 @param iv 初始化偏移向量(Data或String，若是String会被转成UTF8的Data)
 @param error 错误信息
 @return 解密后字符串
 */
+ (NSString *)stringDecryptedByDESWithString:(NSString *)string key:(id)key iv:(id)iv error:(NSError **)error;


/**
 DES 加密
 
 @param data 被加密Data
 @param key 密钥(Data或String，若是String会被转成UTF8的Data)
 @param iv 初始化偏移向量(Data或String，若是String会被转成UTF8的Data)
 @param error 错误信息
 @return 加密后Data
 */
+ (NSData *)dataEncryptedByDESWithData:(NSData *)data key:(id)key iv:(id)iv error:(NSError **)error;


/**
 DES 解密
 
 @param data 需解Data
 @param key 密钥(Data或String，若是String会被转成UTF8的Data)
 @param iv 初始化偏移向量(Data或String，若是String会被转成UTF8的Data)
 @param error 错误信息
 @return 解密后Data
 */
+ (NSData *)dataDecryptedByDESWithData:(NSData *)data key:(id)key iv:(id)iv error:(NSError **)error;

@end

@interface NSString (CMCrypto)

// base64编解码

- (NSData *)cm_base64EncodingData;		///< base64编码
- (NSData *)cm_base64DecodingData;		///< base64解码
- (NSString *)cm_base64EncodingString;	///< base64编码
- (NSString *)cm_base64DecodingString;	///< base64解码

// 散列函数

//- (NSString *)cm_MD2String;
//- (NSString *)cm_MD4String;
- (NSString *)cm_MD5String;			///< MD5值
//- (NSString *)cm_SHA1String;
//- (NSString *)cm_SHA256String;
//- (NSString *)cm_SHA512String;

// HMAC 散列函数

//- (NSString *)cm_hmacMD5StringWithKey:(NSString *)key;
//- (NSString *)cm_hmacSHA1StringWithKey:(NSString *)key;
//- (NSString *)cm_hmacSHA256StringWithKey:(NSString *)key;
//- (NSString *)cm_hmacSHA512StringWithKey:(NSString *)key;

// 文件 散列函数

//- (NSString *)cm_fileMD5Hash;
//- (NSString *)cm_fileSHA1Hash;
//- (NSString *)cm_fileSHA256Hash;
//- (NSString *)cm_fileSHA512Hash;

@end

@interface NSData (CMCrypto)

// base64编解码

- (NSData *)cm_base64EncodingData;		///< base64编码
- (NSData *)cm_base64DecodingData;		///< base64解码
- (NSString *)cm_base64EncodingString;	///< base64编码
- (NSString *)cm_base64DecodingString;	///< base64解码

// 散列函数

//- (NSData *)cm_MD2Data;
//- (NSData *)cm_MD4Data;
- (NSData *)cm_MD5Data;					///< MD5值
//- (NSData *)cm_SHA1Data;
//- (NSData *)cm_SHA224Data;
//- (NSData *)cm_SHA256Data;
//- (NSData *)cm_SHA384Data;
//- (NSData *)cm_SHA512Data;

// HMAC 散列函数

//- (NSData *)cm_hmacMD5DataWithKey:(id)key;
//- (NSData *)cm_hmacSHA1DataWithKey:(id)key;
//- (NSData *)cm_hmacSHA224DataWithKey:(id)key;
//- (NSData *)cm_hmacSHA256DataWithKey:(id)key;
//- (NSData *)cm_hmacSHA384DataWithKey:(id)key;
//- (NSData *)cm_hmacSHA512DataWithKey:(id)key;

@end

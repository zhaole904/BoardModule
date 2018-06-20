//
//  CMCrypto.m
//  CMCore
//
//  Created by PengTao on 2017/11/24.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import "CMCrypto.h"

NSString *const CMCryptoErrorDomain = @"CMCryptoErrorDomain";

@implementation CMCryptor

+ (NSString *)stringEncryptedByAESWithString:(NSString *)string key:(id)key iv:(id)iv error:(NSError **)error {
	return _cm_string_crypt(string, key, iv, kCCEncrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding, error);
}
+ (NSString *)stringDecryptedByAESWithString:(NSString *)string key:(id)key iv:(id)iv error:(NSError **)error {
	return _cm_string_crypt(string, key, iv, kCCDecrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding, error);
}
+ (NSData *)dataEncryptedByAESWithData:(NSData *)data key:(id)key iv:(id)iv error:(NSError **)error {
	return _cm_crypt_data(data, key, iv, kCCEncrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding, error);
}
+ (NSData *)dataDecryptedByAESWithData:(NSData *)data key:(id)key iv:(id)iv error:(NSError **)error {
	return _cm_crypt_data(data, key, iv, kCCDecrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding, error);
}

+ (NSString *)stringEncryptedByDESWithString:(NSString *)string key:(id)key iv:(id)iv error:(NSError **)error {
	return _cm_string_crypt(string, key, iv, kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding, error);
}
+ (NSString *)stringDecryptedByDESWithString:(NSString *)string key:(id)key iv:(id)iv error:(NSError **)error {
	return _cm_string_crypt(string, key, iv, kCCDecrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding, error);
}
+ (NSData *)dataEncryptedByDESWithData:(NSData *)data key:(id)key iv:(id)iv error:(NSError **)error {
	return _cm_crypt_data(data, key, iv, kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding, error);
}
+ (NSData *)dataDecryptedByDESWithData:(NSData *)data key:(id)key iv:(id)iv error:(NSError **)error {
	return _cm_crypt_data(data, key, iv, kCCDecrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding, error);
}

static NSString *_cm_string_crypt(NSString *content,
								  id key,
								  id initVector,
								  CCOperation operation,
								  CCAlgorithm algorithm,
								  CCOptions options,
								  NSError **error) {
	// NSString 需转换成 NSData
	NSData *contentData = nil;
	if (operation == kCCEncrypt) {
		contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
	} else {
		contentData = content.cm_base64DecodingData;
	}
	
	NSData *data = _cm_crypt_data(contentData, key, initVector, operation, algorithm, options, error);
	
	// NSData 需转换成 NSString
	if (operation == kCCEncrypt) {
		return data.cm_base64EncodingString;
	} else {
		return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	}
}


static NSData *_cm_crypt_data(NSData *content,
							  id key,
							  id iv,
							  CCOperation operation,
							  CCAlgorithm algorithm,
							  CCOptions options,
							  NSError **error) {
	
	NSCParameterAssert([key isKindOfClass:NSData.class] || [key isKindOfClass:NSString.class]);
	NSCParameterAssert(iv == nil || [iv isKindOfClass:NSData.class] || [iv isKindOfClass:NSString.class]);
	
	// key
	NSMutableData *keyData = nil;
	{
		if ([key isKindOfClass:NSString.class]) {
			keyData = [[key dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
		} else {
			keyData = [key mutableCopy];
		}
	}
	
	// initVector
	NSMutableData *ivData = nil;
	if (iv) {
		if ([iv isKindOfClass:NSString.class]) {
			ivData = [[(NSString *)iv dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
		} else {
			ivData = [iv mutableCopy];
		}
		ivData.length = keyData.length;
	}
	
	// buffer
	size_t bufferSize = content.length + keyData.length;
	void *buffer = malloc(bufferSize);
	if (buffer == NULL) {
		return nil;
	}
	size_t actualOutSize = 0;
	
	CCCryptorStatus cryptStatus = CCCrypt(operation,
										  algorithm,
										  options,
										  keyData.bytes,
										  (size_t)keyData.length,
										  ivData.bytes,
										  content.bytes,
										  (size_t)content.length,
										  buffer,
										  bufferSize,
										  &actualOutSize);
	
	if (cryptStatus == kCCSuccess) {
		return [NSData dataWithBytesNoCopy:buffer length:actualOutSize];
	} else {
		if (error) {
			*error = _cm_errorWithCCCryptorStatus(cryptStatus);
		}
	}
	free(buffer);
	buffer = NULL;
	return nil;
}

static NSError *_cm_errorWithCCCryptorStatus(CCCryptorStatus status) {
	NSString *description = nil, *reason = nil;
	
	switch ( status ) {
		case kCCSuccess: {
			description = @"Success";
		} break;
			
		case kCCParamError: {
			description = @"Parameter Error";
			reason = @"Illegal parameter supplied to encryption/decryption algorithm";
		} break;
			
		case kCCBufferTooSmall: {
			description = @"Buffer Too Small";
			reason = @"Insufficient buffer provided for specified operation";
		} break;
			
		case kCCMemoryFailure: {
			description = @"Memory Failure";
			reason = @"Failed to allocate memory";
		} break;
			
		case kCCAlignmentError: {
			description = @"Alignment Error";
			reason = @"Input size to encryption algorithm was not aligned correctly";
		} break;
			
		case kCCDecodeError: {
			description = @"Decode Error";
			reason = @"Input data did not decode or decrypt correctly";
		} break;
			
		case kCCUnimplemented: {
			description = @"Unimplemented Function";
			reason = @"Function not implemented for the current algorithm";
		} break;
			
		default: {
			description = @"Unknown Error";
		} break;
	}
	
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
	userInfo[NSLocalizedDescriptionKey] = description;
	
	if (reason != nil) {
		userInfo[NSLocalizedFailureReasonErrorKey] = reason;
	}
	
	NSError *result = [NSError errorWithDomain:CMCryptoErrorDomain code:status userInfo:userInfo];
#if !__has_feature(objc_arc)
	[userInfo release];
#endif
	
	return result;
}

@end

@implementation NSString (CMCrypto)

#pragma mark - String Base64

- (NSData *)cm_base64EncodingData {
	NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	return data.cm_base64EncodingData;
}
- (NSData *)cm_base64DecodingData {
	NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
	return data.cm_base64DecodingData;
//	return [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

- (NSString *)cm_base64EncodingString {
	NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	return data.cm_base64EncodingString;
}
- (NSString *)cm_base64DecodingString {
	return [[NSString alloc] initWithData:self.cm_base64DecodingData encoding:NSUTF8StringEncoding];
}

#pragma mark - String Digest

//- (NSString *)cm_MD2String {
//	const char *cStr = self.UTF8String;
//	uint8_t buffer[CC_MD2_DIGEST_LENGTH];
//	CC_MD2(cStr, (CC_LONG)strlen(cStr), buffer);
//	return [self _cm_stringFromBytes:buffer length:CC_MD2_DIGEST_LENGTH];
//}
//- (NSString *)cm_MD4String {
//	const char *cStr = self.UTF8String;
//	uint8_t buffer[CC_MD4_DIGEST_LENGTH];
//	CC_MD4(cStr, (CC_LONG)strlen(cStr), buffer);
//	return [self _cm_stringFromBytes:buffer length:CC_MD4_DIGEST_LENGTH];
//}
- (NSString *)cm_MD5String {
	const char *cStr = self.UTF8String;
	uint8_t buffer[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, (CC_LONG)strlen(cStr), buffer);
	return [self _cm_stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}
- (NSString *)cm_SHA1String {
	const char *cStr = self.UTF8String;
	uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(cStr, (CC_LONG)strlen(cStr), buffer);
	return [self _cm_stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}
- (NSString *)cm_SHA256String {
	const char *cStr = self.UTF8String;
	uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
	CC_SHA256(cStr, (CC_LONG)strlen(cStr), buffer);
	return [self _cm_stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}
- (NSString *)cm_SHA512String {
	const char *cStr = self.UTF8String;
	uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
	CC_SHA512(cStr, (CC_LONG)strlen(cStr), buffer);
	return [self _cm_stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

// HMAC 散列函数
//- (NSString *)cm_hmacMD5StringWithKey:(NSString *)key {
//	const char *keyData = key.UTF8String;
//	const char *strData = self.UTF8String;
//	uint8_t buffer[CC_MD5_DIGEST_LENGTH];
//	CCHmac(kCCHmacAlgMD5, keyData, strlen(keyData), strData, strlen(strData), buffer);
//	return [self _cm_stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
//}
//- (NSString *)cm_hmacSHA1StringWithKey:(NSString *)key {
//	const char *keyData = key.UTF8String;
//	const char *strData = self.UTF8String;
//	uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
//	CCHmac(kCCHmacAlgSHA1, keyData, strlen(keyData), strData, strlen(strData), buffer);
//	return [self _cm_stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
//}
//- (NSString *)cm_hmacSHA256StringWithKey:(NSString *)key {
//	const char *keyData = key.UTF8String;
//	const char *strData = self.UTF8String;
//	uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
//	CCHmac(kCCHmacAlgSHA256, keyData, strlen(keyData), strData, strlen(strData), buffer);
//	return [self _cm_stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
//}
//- (NSString *)cm_hmacSHA512StringWithKey:(NSString *)key {
//	const char *keyData = key.UTF8String;
//	const char *strData = self.UTF8String;
//	uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
//	CCHmac(kCCHmacAlgSHA512, keyData, strlen(keyData), strData, strlen(strData), buffer);
//	return [self _cm_stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
//}

// 文件散列函数
//#define _CMFileHashDefaultChunkSizeForReadingData 4096
//- (NSString *)cm_fileMD5Hash {
//	NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
//	if (fp == nil) return nil;
//
//	CC_MD5_CTX hashCtx;
//	CC_MD5_Init(&hashCtx);
//
//	while (YES) {
//		@autoreleasepool {
//			NSData *data = [fp readDataOfLength:_CMFileHashDefaultChunkSizeForReadingData];
//			CC_MD5_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
//			if (data.length == 0) break;
//		}
//	}
//	[fp closeFile];
//
//	uint8_t buffer[CC_MD5_DIGEST_LENGTH];
//	CC_MD5_Final(buffer, &hashCtx);
//
//	return [self _cm_stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
//}
//- (NSString *)cm_fileSHA1Hash {
//	NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
//	if (fp == nil) return nil;
//
//	CC_SHA1_CTX hashCtx;
//	CC_SHA1_Init(&hashCtx);
//
//	while (YES) {
//		@autoreleasepool {
//			NSData *data = [fp readDataOfLength:_CMFileHashDefaultChunkSizeForReadingData];
//			CC_SHA1_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
//			if (data.length == 0) break;
//		}
//	}
//	[fp closeFile];
//
//	uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
//	CC_SHA1_Final(buffer, &hashCtx);
//
//	return [self _cm_stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
//}
//- (NSString *)cm_fileSHA256Hash {
//	NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
//	if (fp == nil) return nil;
//
//	CC_SHA256_CTX hashCtx;
//	CC_SHA256_Init(&hashCtx);
//
//	while (YES) {
//		@autoreleasepool {
//			NSData *data = [fp readDataOfLength:_CMFileHashDefaultChunkSizeForReadingData];
//			CC_SHA256_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
//			if (data.length == 0) break;
//		}
//	}
//	[fp closeFile];
//
//	uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
//	CC_SHA256_Final(buffer, &hashCtx);
//
//	return [self _cm_stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
//}
//- (NSString *)cm_fileSHA512Hash {
//	NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
//	if (fp == nil) return nil;
//
//	CC_SHA512_CTX hashCtx;
//	CC_SHA512_Init(&hashCtx);
//
//	while (YES) {
//		@autoreleasepool {
//			NSData *data = [fp readDataOfLength:_CMFileHashDefaultChunkSizeForReadingData];
//			CC_SHA512_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
//			if (data.length == 0) break;
//		}
//	}
//	[fp closeFile];
//
//	uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
//	CC_SHA512_Final(buffer, &hashCtx);
//
//	return [self _cm_stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
//}

/** 返回二进制 Bytes 流的字符串表示形式, bytes: 二进制 Bytes 数组;length: 数组长度 */
- (NSString *)_cm_stringFromBytes:(uint8_t *)bytes length:(int)length {
	NSMutableString *str = [NSMutableString stringWithCapacity:length * 2];
	for (int i = 0; i < length; i++) {
		[str appendFormat:@"%02x", bytes[i]];
	}
	return str.copy;
}

@end

@implementation NSData (CMCrypto)

#pragma mark - Data Base64

- (NSData *)cm_base64EncodingData {
	return [self base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}
- (NSData *)cm_base64DecodingData {
	return [[NSData alloc] initWithBase64EncodedData:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

- (NSString *)cm_base64EncodingString {
	return [self base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}
- (NSString *)cm_base64DecodingString {
	return [[NSString alloc] initWithData:self.cm_base64DecodingData encoding:NSUTF8StringEncoding];
}

#pragma mark - Data Digest

- (NSData *)cm_MD2Data {
	unsigned char hash[CC_MD2_DIGEST_LENGTH];
	(void) CC_MD2(self.bytes, (CC_LONG)self.length, hash);
	return [NSData dataWithBytes:hash length:CC_MD2_DIGEST_LENGTH];
}
- (NSData *)cm_MD4Data {
	unsigned char hash[CC_MD4_DIGEST_LENGTH];
	(void) CC_MD4(self.bytes, (CC_LONG)self.length, hash);
	return [NSData dataWithBytes:hash length:CC_MD4_DIGEST_LENGTH];
}
- (NSData *)cm_MD5Data {
	unsigned char hash[CC_MD5_DIGEST_LENGTH];
	(void) CC_MD5(self.bytes, (CC_LONG)self.length, hash);
	return [NSData dataWithBytes:hash length:CC_MD5_DIGEST_LENGTH];
}

- (NSData *)cm_SHA1Data {
	unsigned char hash[CC_SHA1_DIGEST_LENGTH];
	(void) CC_SHA1(self.bytes, (CC_LONG)self.length, hash);
	return [NSData dataWithBytes:hash length:CC_SHA1_DIGEST_LENGTH];
}
- (NSData *)cm_SHA224Data {
	unsigned char hash[CC_SHA224_DIGEST_LENGTH];
	(void) CC_SHA224(self.bytes, (CC_LONG)self.length, hash);
	return [NSData dataWithBytes:hash length:CC_SHA224_DIGEST_LENGTH];
}
- (NSData *)cm_SHA256Data {
	unsigned char hash[CC_SHA256_DIGEST_LENGTH];
	(void) CC_SHA256(self.bytes, (CC_LONG)self.length, hash);
	return [NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH];
}
- (NSData *)cm_SHA384Data {
	unsigned char hash[CC_SHA384_DIGEST_LENGTH];
	(void) CC_SHA384(self.bytes, (CC_LONG)self.length, hash);
	return [NSData dataWithBytes:hash length:CC_SHA384_DIGEST_LENGTH];
}
- (NSData *)cm_SHA512Data {
	unsigned char hash[CC_SHA512_DIGEST_LENGTH];
	(void) CC_SHA512(self.bytes, (CC_LONG)self.length, hash );
	return [NSData dataWithBytes:hash length:CC_SHA512_DIGEST_LENGTH];
}

//- (NSData *)cm_hmacMD5DataWithKey:(id)key {
//	return [self _cm_HMACWithAlgorithm:kCCHmacAlgMD5 key:nil];
//}
//- (NSData *)cm_hmacSHA1DataWithKey:(id)key {
//	return [self _cm_HMACWithAlgorithm:kCCHmacAlgSHA1 key:nil];
//}
//- (NSData *)cm_hmacSHA224DataWithKey:(id)key {
//	return [self _cm_HMACWithAlgorithm:kCCHmacAlgSHA224 key:nil];
//}
//- (NSData *)cm_hmacSHA256DataWithKey:(id)key {
//	return [self _cm_HMACWithAlgorithm:kCCHmacAlgSHA256 key:nil];
//}
//- (NSData *)cm_hmacSHA384DataWithKey:(id)key {
//	return [self _cm_HMACWithAlgorithm:kCCHmacAlgSHA384 key:nil];
//}
//- (NSData *)cm_hmacSHA512DataWithKey:(id)key {
//	return [self _cm_HMACWithAlgorithm:kCCHmacAlgSHA512 key:nil];
//}
//- (NSData *)_cm_HMACWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key {
//	NSParameterAssert(key == nil || [key isKindOfClass:NSData.class] || [key isKindOfClass:NSString.class]);
//
//	NSData *keyData = (NSData *)key;
//	if ( [key isKindOfClass:NSString.class] ) {
//		keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
//	}
//
//	unsigned int length = CC_MD5_DIGEST_LENGTH;
//	switch (algorithm) {
//		case kCCHmacAlgMD5: 	length = CC_MD5_DIGEST_LENGTH; break;
//		case kCCHmacAlgSHA1: 	length = CC_SHA1_DIGEST_LENGTH; break;
//		case kCCHmacAlgSHA224: 	length = CC_SHA224_DIGEST_LENGTH; break;
//		case kCCHmacAlgSHA256: 	length = CC_SHA256_DIGEST_LENGTH; break;
//		case kCCHmacAlgSHA384: 	length = CC_SHA384_DIGEST_LENGTH; break;
//		case kCCHmacAlgSHA512: 	length = CC_SHA512_DIGEST_LENGTH; break;
//		default: break;
//	}
//
//	unsigned char buf[length];
//	CCHmac( algorithm, keyData.bytes, keyData.length,self.bytes, self.length, buf );
//	return [NSData dataWithBytes:buf length:(NSUInteger)length];
//}

@end

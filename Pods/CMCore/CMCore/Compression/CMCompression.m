//
//  CMCompression.m
//  CMCore
//
//  Created by PengTao on 2017/11/23.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#import <zlib.h>
#import "CMCompression.h"

NSString *const CMCompressorErrorDomain = @"CMCompressor";

static int const kGodzippaChunkSize = 1024;
static int const kGodzippaChunkSize4k = 4096;
static int const kGodzippaDefaultMemoryLevel = 8;
static int const kGodzippaDefaultWindowBits = 15;
static int const kGodzippaDefaultWindowBitsWithGZipHeader = 16 + kGodzippaDefaultWindowBits;

@implementation CMGZipCompressor

+ (BOOL)isCompressedWithData:(NSData *)data {
	const UInt8 *bytes = (const UInt8 *)data.bytes;
	return (data.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b);
}

+ (NSData *)dataCompressedWithData:(NSData *)data error:(NSError **)error {
	return [self dataCompressedWithData:data
								atLevel:Z_DEFAULT_COMPRESSION
							 windowBits:kGodzippaDefaultWindowBitsWithGZipHeader
							memoryLevel:kGodzippaDefaultMemoryLevel
							   strategy:Z_DEFAULT_STRATEGY
								  error:error];
}
+ (NSData *)dataCompressedWithData:(NSData *)data
						   atLevel:(int)level
						windowBits:(int)windowBits
					   memoryLevel:(int)memLevel
						  strategy:(int)strategy
							 error:(NSError **)error {
	if (data.length == 0 || [self isCompressedWithData:data]) {
		return data;
	}
	
	z_stream zStream;
	bzero(&zStream, sizeof(z_stream));
	
	zStream.zalloc = Z_NULL;
	zStream.zfree = Z_NULL;
	zStream.opaque = Z_NULL;
	zStream.next_in = (Bytef *)data.bytes;
	zStream.avail_in = (uInt)data.length;
	zStream.total_out = 0;
	
	OSStatus status;
	if ((status = deflateInit2(&zStream, level, Z_DEFLATED, windowBits, memLevel, strategy)) != Z_OK) {
		if (error) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedString(@"CM GZip Failed deflateInit", nil) forKey:NSLocalizedDescriptionKey];
			*error = [NSError errorWithDomain:CMCompressorErrorDomain code:status userInfo:userInfo];
		}
		return nil;
	}
	
	NSMutableData *compressedData = [NSMutableData dataWithLength:kGodzippaChunkSize];
	
	do {
		if ((status == Z_BUF_ERROR) || (zStream.total_out == compressedData.length)) {
			[compressedData increaseLengthBy:kGodzippaChunkSize];
		}
		
		zStream.next_out = (Bytef *)compressedData.mutableBytes + zStream.total_out;
		zStream.avail_out = (unsigned int)(compressedData.length - zStream.total_out);
		
		status = deflate(&zStream, Z_FINISH);
	} while ((status == Z_OK) || (status == Z_BUF_ERROR));
	
	deflateEnd(&zStream);
	
	if ((status != Z_OK) && (status != Z_STREAM_END)) {
		if (error) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedString(@"CM GZip Error deflating payload", nil) forKey:NSLocalizedDescriptionKey];
			*error = [[NSError alloc] initWithDomain:CMCompressorErrorDomain code:status userInfo:userInfo];
		}
		return nil;
	}
	
	compressedData.length = zStream.total_out;
	
	return compressedData;
}

+ (NSData *)dataDecompressedWithData:(NSData *)data error:(NSError **)error {
	return [self dataDecompressedWithData:data windowBits:kGodzippaDefaultWindowBitsWithGZipHeader error:error];
}
+ (NSData *)dataDecompressedWithData:(NSData *)data windowBits:(int)windowBits error:(NSError **)error {
	if (data.length == 0 || ![self isCompressedWithData:data]) {
		return data;
	}
	
	z_stream zStream;
	bzero(&zStream, sizeof(z_stream));
	
	zStream.zalloc = Z_NULL;
	zStream.zfree = Z_NULL;
	zStream.opaque = Z_NULL;
	zStream.avail_in = (uInt)data.length;
	zStream.next_in = (Byte *)data.bytes;
	zStream.total_out = 0;
	
	OSStatus status;
	if ((status = inflateInit2(&zStream, windowBits)) != Z_OK) {
		if (error) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedString(@"CM GZip Error deflating payload", nil) forKey:NSLocalizedDescriptionKey];
			*error = [NSError errorWithDomain:CMCompressorErrorDomain code:status userInfo:userInfo];
		}
		return nil;
	}
	
	NSUInteger estimatedLength = (NSUInteger)((double)data.length * 1.5);
	NSMutableData *decompressedData = [NSMutableData dataWithLength:estimatedLength];
	
	do {
		if ((status == Z_BUF_ERROR) || (zStream.total_out == decompressedData.length)) {
			[decompressedData increaseLengthBy:(estimatedLength / 2)];
		}
		
		zStream.next_out = (Bytef *)decompressedData.mutableBytes + zStream.total_out;
		zStream.avail_out = (unsigned int)(decompressedData.length - zStream.total_out);
		
		status = inflate(&zStream, Z_FINISH);
	} while ((status == Z_OK) || (status == Z_BUF_ERROR));
	
	inflateEnd(&zStream);
	
	if ((status != Z_OK) && (status != Z_STREAM_END)) {
		if (error) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedString(@"CM GZip Error inflating payload", nil) forKey:NSLocalizedDescriptionKey];
			*error = [NSError errorWithDomain:CMCompressorErrorDomain code:status userInfo:userInfo];
		}
		return nil;
	}
	
	decompressedData.length = zStream.total_out;
	
	return decompressedData;
}

#pragma mark -

+ (BOOL)compressFile:(NSURL *)sourceFile toFile:(NSURL *)destinationFile error:(NSError * _Nullable __autoreleasing *)error {
	return [self compressFile:sourceFile toFile:destinationFile atLevel:Z_DEFAULT_COMPRESSION error:error];
}
+ (BOOL)compressFile:(NSURL *)sourceFile toFile:(NSURL *)destinationFile atLevel:(int)level error:(NSError **)error {
	
	NSParameterAssert(sourceFile);
	NSParameterAssert(destinationFile);
	
	NSDictionary *sourceAttributes = [NSFileManager.defaultManager attributesOfItemAtPath:sourceFile.path error:error];
	if (!sourceAttributes || [sourceAttributes[NSFileSize] unsignedIntegerValue] == 0) {
		return NO;
	}
	
	const char *mode = NULL;
	if (level == Z_DEFAULT_COMPRESSION) {
		mode = "w";
	} else {
		mode = [NSString stringWithFormat:@"w%d", level].UTF8String;
	}
	
	NSFileHandle *sourceFileHandle = [NSFileHandle fileHandleForReadingFromURL:sourceFile error:error];
	{
		gzFile output = gzopen([destinationFile.path UTF8String], mode);
		{
			int numberOfBytesWritten = 0;
			do {
				@autoreleasepool {
					NSData *data = [sourceFileHandle readDataOfLength:kGodzippaChunkSize4k];
					numberOfBytesWritten = gzwrite(output, data.bytes, (unsigned) data.length);
				}
			} while (numberOfBytesWritten == kGodzippaChunkSize4k);
		}
		gzclose(output);
	}
	[sourceFileHandle closeFile];
	
	return YES;
}

+ (BOOL)decompressFile:(NSURL *)sourceFile toFile:(NSURL *)destinationFile error:(NSError **)error {
	NSParameterAssert(sourceFile);
	NSParameterAssert(destinationFile);
	
	NSDictionary *sourceAttributes = [NSFileManager.defaultManager attributesOfItemAtPath:sourceFile.path error:error];
	if (!sourceAttributes || [sourceAttributes[NSFileSize] unsignedIntegerValue] == 0) {
		return NO;
	}
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:destinationFile.path]) {
		if (![[NSFileManager defaultManager] createFileAtPath:destinationFile.path contents:nil attributes:nil]) {
			return NO;
		}
	}
	
	NSFileHandle *destinationFileHandle = [NSFileHandle fileHandleForWritingAtPath:destinationFile.path];
	{
		gzFile input = gzopen([sourceFile.path UTF8String], "r");
		{
			int numberOfBytesRead = 0;
			
			do {
				@autoreleasepool {
					NSMutableData *mutableData = [NSMutableData dataWithLength:kGodzippaChunkSize4k];
					numberOfBytesRead = gzread(input, mutableData.mutableBytes, kGodzippaChunkSize4k);
					[destinationFileHandle writeData:[mutableData subdataWithRange:NSMakeRange(0, (NSUInteger)numberOfBytesRead)]];
				}
			} while (numberOfBytesRead == kGodzippaChunkSize4k);
		}
		gzclose(input);
	}
	[destinationFileHandle synchronizeFile];
	[destinationFileHandle closeFile];
	
	return YES;
}

@end


@implementation NSData (CMCompressor)

- (NSData *)cm_dataCompressedByGZipWithError:(NSError **)error {
	return [CMGZipCompressor dataCompressedWithData:self error:error];
}
- (NSData *)cm_dataCompressedByGZipAtLevel:(int)level
							 windowBits:(int)windowBits
							memoryLevel:(int)memLevel
							   strategy:(int)strategy
								  error:(NSError **)error {
	return [CMGZipCompressor dataCompressedWithData:self atLevel:level windowBits:windowBits memoryLevel:memLevel strategy:strategy error:error];
}

- (NSData *)cm_dataDecompressedByGZipWithError:(NSError **)error {
	return [CMGZipCompressor dataDecompressedWithData:self error:error];
}
- (NSData *)cm_dataDecompressedByGZipWithWindowBits:(int)windowBits error:(NSError **)error {
	return [CMGZipCompressor dataDecompressedWithData:self windowBits:windowBits error:error];
}

@end

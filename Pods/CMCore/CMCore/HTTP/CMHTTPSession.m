//
//  CMHTTPSession.m
//  CMCore
//
//  Created by PengTao on 2017/12/7.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#import "CMHTTPSession.h"
#import "CMHTTPSerialization.h"
#import "CMHTTPDeserialization.h"
#import "CMCrypto.h"

#if __has_include(<AFNetworking/AFURLSessionManager.h>)
#import <AFNetworking/AFURLSessionManager.h>
#else
#import "AFURLSessionManager.h"
#endif

NSString *const CMHTTPErrorDomain = @"CMHTTPErrorDomain";
static NSString *const _CMHTTPRequestIncompleteDownloadFolderName = @"Incomplete";

@implementation CMHTTPSession {
	AFURLSessionManager *_sessionManager;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@, serializer: %@, deserializer: %@", NSStringFromClass(self.class), self.serializer, self.deserializer];
}

static CMHTTPSession *defaultSession;
+ (CMHTTPSession *)defaultSession {
	return [self _buildDefaultSessionWithSerializer:nil deserializer:nil];
}
+ (CMHTTPSession *)defaultSessionWithSerializer:(id<CMHTTPSerializer>)serializer
								   deserializer:(id<CMHTTPDeserializer>)deserializer {
	return [self _buildDefaultSessionWithSerializer:serializer deserializer:deserializer];
}
+ (CMHTTPSession *)_buildDefaultSessionWithSerializer:(id<CMHTTPSerializer>)serializer
										  deserializer:(id<CMHTTPDeserializer>)deserializer {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		defaultSession = [[CMHTTPSession alloc] initWithSerializer:serializer deserializer:deserializer];
	});
	return defaultSession;
}

- (instancetype)init {
	return [self initWithSerializer:nil deserializer:nil];
}
- (instancetype)initWithSerializer:(id<CMHTTPSerializer>)serializer deserializer:(id<CMHTTPDeserializer>)deserializer {
	if (self = [super init]) {
		_serializer = serializer ? [(CMHTTPSerializer *)serializer copy] : [[CMHTTPSerializer alloc] init];
		_deserializer = deserializer ?: [[CMHTTPDeserializer alloc] init];
		
		NSURLSessionConfiguration *config = serializer.sessionConfiguration ?: NSURLSessionConfiguration.defaultSessionConfiguration;
		_sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
		
		// 因 NSURLSession 初始化时，会复制 NSURLSessionConfiguration
		// 原本 serializer 中的 NSURLSessionConfiguration 就可以废弃(置为 nil)
        SEL setConfigSEL = @selector(setSessionConfiguration:);
		if ([_serializer respondsToSelector:setConfigSEL]) {
            ((void (*)(id, SEL, id))[(NSObject *)_serializer methodForSelector:setConfigSEL])(_serializer, setConfigSEL, nil);
		}
	}
	return self;
}

- (void)_hundleResponseData:(NSData *)responseData
				   response:(NSURLResponse *)response
					  error:(NSError *)error
				 completion:(CMHTTPRequestCompletionBlock)completion {
	if (error) {
//		CMLogNSError(error);
		if (completion) {
			completion(nil, nil, error);
		}
		return;
	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSError *__block deserializerError = nil;
		id responseObj = nil;
		if ([self.deserializer respondsToSelector:@selector(responseObjectByDeserializingData:response:objClass:error:)]) {
			responseObj = [self.deserializer responseObjectByDeserializingData:responseData response:(NSHTTPURLResponse *)response objClass:nil error:&deserializerError];
		} else {
			responseObj = [self.deserializer responseObjectByDeserializingData:responseData response:(NSHTTPURLResponse *)response error:&deserializerError];
		}
		
		if (deserializerError) {
//			CMLogNSError(deserializerError);
			if (completion) {
				dispatch_async(dispatch_get_main_queue(), ^{
					completion(nil, nil, deserializerError);
				});
			}
			return;
		} else {
			if (completion) {
				dispatch_async(dispatch_get_main_queue(), ^{
					completion(response, responseObj, nil);
				});
			}
		}
	});
}

- (NSURLSessionDataTask *)sendDataRequest:(NSURLRequest *)request completion:(CMHTTPRequestCompletionBlock)completion {
	return [self sendDataRequest:request uploadProgress:nil downloadProgress:nil completion:completion];
}
- (NSURLSessionDataTask *)sendDataRequest:(NSURLRequest *)request
						   uploadProgress:(CMHTTPRequestProgressBlock)uploadProgress
						 downloadProgress:(CMHTTPRequestProgressBlock)downloadProgress
							   completion:(CMHTTPRequestCompletionBlock)completion {
	__weak typeof(self) weakSelf = self;
	NSURLSessionDataTask *sessionTask = [_sessionManager dataTaskWithRequest:request uploadProgress:uploadProgress downloadProgress:downloadProgress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
		[weakSelf _hundleResponseData:responseObject response:response error:error completion:completion];
	}];
	[sessionTask resume];
	return sessionTask;
}

- (NSURLSessionUploadTask *)sendUploadRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL progress:(CMHTTPRequestProgressBlock)uploadProgress completion:(CMHTTPRequestCompletionBlock)completion {
	__weak typeof(self) weakSelf = self;
	NSURLSessionUploadTask *sessionTask = [_sessionManager uploadTaskWithRequest:request fromFile:fileURL progress:uploadProgress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
		[weakSelf _hundleResponseData:responseObject response:response error:error completion:completion];
	}];
	[sessionTask resume];
	return sessionTask;
}
- (NSURLSessionUploadTask *)sendUploadRequest:(NSURLRequest *)request fromData:(NSData *)bodyData progress:(CMHTTPRequestProgressBlock)uploadProgress completion:(CMHTTPRequestCompletionBlock)completion {
	__weak typeof(self) weakSelf = self;
	NSURLSessionUploadTask *sessionTask = [_sessionManager uploadTaskWithRequest:request fromData:bodyData progress:uploadProgress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
		[weakSelf _hundleResponseData:responseObject response:response error:error completion:completion];
	}];
	[sessionTask resume];
	return sessionTask;
}
- (NSURLSessionUploadTask *)sendStreamedUploadRequest:(NSURLRequest *)request progress:(CMHTTPRequestProgressBlock)uploadProgress completion:(CMHTTPRequestCompletionBlock)completion {
	__weak typeof(self) weakSelf = self;
	NSURLSessionUploadTask *sessionTask = [_sessionManager uploadTaskWithStreamedRequest:request progress:uploadProgress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
		[weakSelf _hundleResponseData:responseObject response:response error:error completion:completion];
	}];
	[sessionTask resume];
	return sessionTask;
}

- (NSURLSessionDownloadTask *)sendDownloadRequest:(NSURLRequest *)request progress:(CMHTTPRequestProgressBlock)downloadProgress destination:(NSURL * _Nonnull (^)(NSURL * _Nonnull, NSURLResponse * _Nonnull))destination completion:(void (^)(NSURLResponse * _Nonnull, NSURL * _Nullable, NSError * _Nullable))completion {
	NSURLSessionDownloadTask *sessionTask = [_sessionManager downloadTaskWithRequest:request progress:downloadProgress destination:destination completionHandler:completion];
	[sessionTask resume];
	return sessionTask;
}
- (NSURLSessionDownloadTask *)resumeDownloadData:(NSData *)resumeData progress:(CMHTTPRequestProgressBlock)downloadProgress destination:(NSURL * _Nonnull (^)(NSURL * _Nonnull, NSURLResponse * _Nonnull))destination completion:(void (^)(NSURLResponse * _Nonnull, NSURL * _Nullable, NSError * _Nullable))completion {
	NSURLSessionDownloadTask *sessionTask = [_sessionManager downloadTaskWithResumeData:resumeData progress:downloadProgress destination:destination completionHandler:completion];
	[sessionTask resume];
	return sessionTask;
}

- (NSURLSessionDownloadTask *)sendDownloadRequest:(NSURLRequest *)request
									 downloadPath:(NSString *)downloadPath
										 progress:(CMHTTPRequestProgressBlock)downloadProgress
									   completion:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completion {
	NSParameterAssert(request);
	
	NSString *downloadTargetPath;
	BOOL isDirectory;
	if(![NSFileManager.defaultManager fileExistsAtPath:downloadPath isDirectory:&isDirectory]) {
		isDirectory = NO;
	}
	// If targetPath is a directory, use the file name we got from the urlRequest.
	// Make sure downloadTargetPath is always a file, not directory.
	if (isDirectory) {
		NSString *fileName = request.URL.lastPathComponent;
		downloadTargetPath = [NSString pathWithComponents:@[downloadPath, fileName]];
	} else {
		downloadTargetPath = downloadPath;
	}
	
	// AFN use `moveItemAtURL` to move downloaded file to target path,
	// this method aborts the move attempt if a file already exist at the path.
	// So we remove the exist file before we start the download task.
	// https://github.com/AFNetworking/AFNetworking/issues/3775
	if ([NSFileManager.defaultManager fileExistsAtPath:downloadTargetPath]) {
		[NSFileManager.defaultManager removeItemAtPath:downloadTargetPath error:nil];
	}
	
	BOOL resumeDataFileExists = [NSFileManager.defaultManager fileExistsAtPath:[self _incompleteDownloadTempPathForDownloadPath:downloadPath].path];
	NSData *data = [NSData dataWithContentsOfURL:[self _incompleteDownloadTempPathForDownloadPath:downloadPath]];
	BOOL resumeDataIsValid = [self.class validateDownloadResumeData:data];
	
	BOOL canBeResumed = resumeDataFileExists && resumeDataIsValid;
	BOOL resumeSucceeded = NO;
	__block NSURLSessionDownloadTask *downloadTask = nil;
	// Try to resume with resumeData.
	// Even though we try to validate the resumeData, this may still fail and raise excecption.
	if (canBeResumed) {
		@try {
			downloadTask = [_sessionManager downloadTaskWithResumeData:data progress:downloadProgress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
				return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
			} completionHandler:completion];
			resumeSucceeded = YES;
		} @catch (NSException *exception) {
//			CMLogError(@"Resume download failed, reason = %@", exception.reason);
			resumeSucceeded = NO;
		}
	}
	if (!resumeSucceeded) {
		downloadTask = [_sessionManager downloadTaskWithRequest:request progress:downloadProgress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
			return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
		} completionHandler:completion];
	}
	
	[downloadTask resume];
	return downloadTask;
}

// 获取下载缓存URL路径
- (NSURL *)_incompleteDownloadTempPathForDownloadPath:(NSString *)downloadPath {
	NSString *tempPath = nil;
	tempPath = [[self _incompleteDownloadTempCacheFolder] stringByAppendingPathComponent:downloadPath.cm_MD5String];
	return [NSURL fileURLWithPath:tempPath];
}
- (NSString *)_incompleteDownloadTempCacheFolder {
	NSFileManager *fileManager = NSFileManager.defaultManager;
	static NSString *cacheFolder;
	
	if (!cacheFolder) {
		NSString *cacheDir = NSTemporaryDirectory();
		cacheFolder = [cacheDir stringByAppendingPathComponent:_CMHTTPRequestIncompleteDownloadFolderName];
	}
	
	NSError *error = nil;
	if(![fileManager createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
//		CMLogError(@"Failed to create cache directory at %@", cacheFolder);
		cacheFolder = nil;
	}
	return cacheFolder;
}

+ (BOOL)validateDownloadResumeData:(NSData *)data {
	// From http://stackoverflow.com/a/22137510/3562486
	if (!data || data.length < 1) return NO;
	
	NSError *error;
	NSDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
	if (!resumeDictionary || error) return NO;
	
	// Before iOS 9 & Mac OS X 10.11
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED < 90000)\
|| (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED < 101100)
	NSString *localFilePath = [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"];
	if (localFilePath.length < 1) return NO;
	return [NSFileManager.defaultManager fileExistsAtPath:localFilePath];
#endif
	// After iOS 9 we can not actually detects if the cache file exists. This plist file has a somehow
	// complicated structue. Besides, the plist structure is different between iOS 9 and iOS 10.
	// We can only assume that the plist being successfully parsed means the resume data is valid.
	return YES;
}

@end


@interface CMHTTPRequest ()
@property(readwrite, nonatomic, strong, nullable) NSURLRequest *URLRequest;
@property(readwrite, nonatomic, strong, nullable) NSURLResponse *URLResponse;
@property(readwrite, nonatomic, strong, nullable) NSURLSessionDataTask *URLSessionTask;
@property(readwrite, nonatomic, strong, nullable) NSData *responseData;
@property(readwrite, nonatomic, strong, nullable) id responseObj;
@property(nonatomic, copy, nullable) CMHTTPRequestProgressBlock uploadProgressHandler;
@property(nonatomic, copy, nullable) CMHTTPRequestProgressBlock downloadProgressHandler;
@property(nonatomic, copy, nullable) CMHTTPRequestCompletionBlock completionHandler;
@end
@implementation CMHTTPSession (CMHTTPRequest)

- (NSURLSessionDataTask *)sendRequest:(CMHTTPRequest *)request completion:(CMHTTPRequestCompletionBlock _Nullable)completion {
	return [self sendRequest:request uploadProgress:nil downloadProgress:nil completion:completion];
}

- (NSURLSessionDataTask *)sendRequest:(CMHTTPRequest *)request
					   uploadProgress:(CMHTTPRequestProgressBlock)uploadProgress
					 downloadProgress:(CMHTTPRequestProgressBlock)downloadProgress
						   completion:(CMHTTPRequestCompletionBlock)completion {
	NSError *error = nil;
	NSURLRequest *URLRequest = [self.serializer requestBySerializingRequest:request error:&error];
	if (!URLRequest || error) {
		if (!error) {
			NSString *errorStr = [NSString stringWithFormat:@"%@ build request failure; CMHTTPRequest: %@; CMHTTPSession: %@", NSStringFromClass(self.class), request, self];
			NSDictionary *errorInfo = @{NSLocalizedDescriptionKey : errorStr};
			error = [NSError errorWithDomain:CMHTTPErrorDomain code:0 userInfo:errorInfo];
		}
		
		[self _hundleResponseData:nil response:nil error:error completion:completion];
		
		return nil;
	}
	
	request.URLRequest = URLRequest;
	
	NSURLSessionDataTask *sessionTask = nil;
	if (request.downloadPath.length && [request.HTTPMethod isEqualToString:@"GET"]) {
		// 下载
		sessionTask = (NSURLSessionDataTask *)[self sendDownloadRequest:URLRequest downloadPath:request.downloadPath progress:downloadProgress completion:completion];
	} else {
		__weak typeof(self) weakSelf = self;
        __strong typeof(weakSelf)  strongSelf = weakSelf;
		sessionTask = [self sendDataRequest:request.URLRequest uploadProgress:uploadProgress downloadProgress:downloadProgress completion:^(NSURLResponse * _Nullable response, id  _Nullable responseObj, NSError * _Nullable error) {
			[strongSelf _hundleResponseData:responseObj response:response error:error completion:completion];
			
		}];
	}
	
	request.URLSessionTask = sessionTask;
	[sessionTask resume];
	return sessionTask;
}

@end


@implementation CMHTTPSession (CMHTTPMethods)

- (NSURLSessionDataTask *_Nullable)HEAD:(NSString *)url
                                 params:(id)params
                                success:(void (^_Nullable)(NSURLSessionDataTask *task))success
                                failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    CMHTTPRequest *request = [[CMHTTPRequest alloc] initWithUrl:url];
    request.HTTPMethod = @"HEAD";
    request.params = params;
    return [self sendRequest:request
                   completion:^(NSURLResponse * _Nullable response, id  _Nullable responseObj, NSError * _Nullable error) {
                       if (error) {
                           if (failure) {
                               failure(request.URLSessionTask, error);
                           }
                       } else {
                           if (success) {
                               success(request.URLSessionTask);
                           }
                       }
                   }];
}

- (NSURLSessionDataTask *_Nullable)GET:(NSString *)url
                                params:(id _Nullable)params
                              progress:(CMHTTPRequestProgressBlock _Nullable)downloadProgress
                               success:(void (^_Nullable)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
	CMHTTPRequest *request = [[CMHTTPRequest alloc] initWithUrl:url];
	request.HTTPMethod = @"GET";
	request.params = params;
	return [self sendRequest:request uploadProgress:nil downloadProgress:downloadProgress completion:^(NSURLResponse * _Nullable response, id  _Nullable responseObj, NSError * _Nullable error) {
		if (error) {
			if (failure) {
				failure(request.URLSessionTask, error);
			}
		} else {
			if (success) {
				success(request.URLSessionTask, responseObj);
			}
		}
	}];
}

- (NSURLSessionDataTask *_Nullable)POST:(NSString *)url
                                 params:(id _Nullable)params
                               progress:(CMHTTPRequestProgressBlock _Nullable)uploadProgress
                                success:(void (^_Nullable)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
	CMHTTPRequest *request = [[CMHTTPRequest alloc] initWithUrl:url];
	request.HTTPMethod = @"POST";
	request.params = params;
    request.HTTPShouldHandleCookies = self.serializer.HTTPShouldHandleCookies;
	return [self sendRequest:request uploadProgress:uploadProgress downloadProgress:nil completion:^(NSURLResponse * _Nullable response, id  _Nullable responseObj, NSError * _Nullable error) {
		if (error) {
			if (failure) {
				failure(request.URLSessionTask, error);
			}
		} else {
			if (success) {
				success(request.URLSessionTask, responseObj);
			}
		}
	}];
}

- (NSURLSessionDataTask *_Nullable)PUT:(NSString *)url
                                params:(id)params
                               success:(void (^_Nullable)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    CMHTTPRequest *request = [[CMHTTPRequest alloc] initWithUrl:url];
    request.HTTPMethod = @"PUT";
    request.params = params;
    request.HTTPShouldHandleCookies = self.serializer.HTTPShouldHandleCookies;
    return [self sendRequest:request
                  completion:^(NSURLResponse * _Nullable response, id  _Nullable responseObj, NSError * _Nullable error) {
                      if (error) {
                          if (failure) {
                              failure(request.URLSessionTask, error);
                          }
                      } else {
                          if (success) {
                              success(request.URLSessionTask, responseObj);
                          }
                      }
                  }];
}

- (NSURLSessionDataTask *_Nullable)PATCH:(NSString *)url
                                  params:(id)params
                                 success:(void (^_Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                                 failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    CMHTTPRequest *request = [[CMHTTPRequest alloc] initWithUrl:url];
    request.HTTPMethod = @"PATCH";
    request.params = params;
    request.HTTPShouldHandleCookies = self.serializer.HTTPShouldHandleCookies;
    return [self sendRequest:request
                  completion:^(NSURLResponse * _Nullable response, id  _Nullable responseObj, NSError * _Nullable error) {
                      if (error) {
                          if (failure) {
                              failure(request.URLSessionTask, error);
                          }
                      } else {
                          if (success) {
                              success(request.URLSessionTask, responseObj);
                          }
                      }
                  }];
}

- (NSURLSessionDataTask *_Nullable)DELETE:(NSString *)url
                                   params:(id)params
                                  success:(void (^_Nullable)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    CMHTTPRequest *request = [[CMHTTPRequest alloc] initWithUrl:url];
    request.HTTPMethod = @"DELETE";
    request.params = params;
    request.HTTPShouldHandleCookies = self.serializer.HTTPShouldHandleCookies;
    return [self sendRequest:request
                  completion:^(NSURLResponse * _Nullable response, id  _Nullable responseObj, NSError * _Nullable error) {
                      if (error) {
                          if (failure) {
                              failure(request.URLSessionTask, error);
                          }
                      } else {
                          if (success) {
                              success(request.URLSessionTask, responseObj);
                          }
                      }
                  }];
}

@end

@implementation CMHTTPRequest (CMHTTPSession)

- (void)cancel {
	if (self.isRequesting) {
		[self.URLSessionTask cancel];
	}
}

- (void)sendWithCompletion:(CMHTTPRequestCompletionBlock)completion {
	self.completionHandler = completion;
	[self sendWithSession:CMHTTPSession.defaultSession];
}

- (void)send {
	[self sendWithSession:CMHTTPSession.defaultSession];
}

- (void)sendWithSession:(CMHTTPSession *)session {
	session = session ?: CMHTTPSession.defaultSession;
	[session sendRequest:self
		  uploadProgress:self.uploadProgressHandler
		downloadProgress:self.downloadProgressHandler
			  completion:self.completionHandler];
}
- (void)sendWithSession:(CMHTTPSession *)session completion:(CMHTTPRequestCompletionBlock _Nullable)completion {
	self.completionHandler = completion;
	[self sendWithSession:session];
}

@end

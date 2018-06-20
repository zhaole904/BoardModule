//
//  CMHTTPSession.h
//  CMCore
//
//  Created by PengTao on 2017/12/7.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMHTTPRequest.h"

@protocol CMHTTPSerializer;
@protocol CMHTTPDeserializer;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const CMHTTPErrorDomain;

/**
 请求完成回调
 
 @param response 	请求响应
 @param responseObj 响应数据对象
 @param error 	 	请求错误
 */
typedef void (^CMHTTPRequestCompletionBlock)(NSURLResponse *_Nullable response, id _Nullable responseObj, NSError *_Nullable error);

/**
 请求进度回调(上传/下载)
 
 @param progress 进度对象
 */
typedef void (^CMHTTPRequestProgressBlock)(NSProgress *progress);

@interface CMHTTPSession : NSObject

/// 序列化器(请求序列化)
@property(readonly, nonatomic, strong) id<CMHTTPSerializer> serializer;
/// 反序列化器(响应序列化)
@property(readonly, nonatomic, strong) id<CMHTTPDeserializer> deserializer;


/**
 init

 @param serializer 序列化器
 @param deserializer 反序列化器
 @return 创建的Session
 */
- (instancetype)initWithSerializer:(id<CMHTTPSerializer> _Nullable)serializer
					  deserializer:(id<CMHTTPDeserializer> _Nullable)deserializer NS_DESIGNATED_INITIALIZER;


/// 单例，默认Session
@property(class, readonly, nonatomic, strong) CMHTTPSession *defaultSession;
+ (CMHTTPSession *)defaultSessionWithSerializer:(id<CMHTTPSerializer> _Nullable)serializer
								   deserializer:(id<CMHTTPDeserializer> _Nullable)deserializer;

- (NSURLSessionDataTask *)sendDataRequest:(NSURLRequest *)request
							   completion:(CMHTTPRequestCompletionBlock _Nullable)completion;
- (NSURLSessionDataTask *)sendDataRequest:(NSURLRequest *)request
						   uploadProgress:(CMHTTPRequestProgressBlock _Nullable)uploadProgress
						 downloadProgress:(CMHTTPRequestProgressBlock _Nullable)downloadProgress
							   completion:(CMHTTPRequestCompletionBlock _Nullable)completion;

- (NSURLSessionUploadTask *)sendUploadRequest:(NSURLRequest *)request
									 fromFile:(NSURL *)fileURL
									 progress:(CMHTTPRequestProgressBlock _Nullable)uploadProgress
								   completion:(CMHTTPRequestCompletionBlock _Nullable)completion;
- (NSURLSessionUploadTask *)sendUploadRequest:(NSURLRequest *)request
									 fromData:(NSData *_Nullable)bodyData
									 progress:(CMHTTPRequestProgressBlock _Nullable)uploadProgress
								   completion:(CMHTTPRequestCompletionBlock _Nullable)completion;
- (NSURLSessionUploadTask *)sendStreamedUploadRequest:(NSURLRequest *)request
											 progress:(CMHTTPRequestProgressBlock _Nullable)uploadProgress
										   completion:(CMHTTPRequestCompletionBlock _Nullable)completion;

- (NSURLSessionDownloadTask *)sendDownloadRequest:(NSURLRequest *)request
										 progress:(CMHTTPRequestProgressBlock _Nullable)downloadProgress
									  destination:(NSURL * (^_Nullable)(NSURL *targetPath, NSURLResponse *response))destination
									   completion:(void (^_Nullable)(NSURLResponse *response, NSURL *_Nullable filePath, NSError *_Nullable error))completion;
- (NSURLSessionDownloadTask *)resumeDownloadData:(NSData *)resumeData
										progress:(CMHTTPRequestProgressBlock _Nullable)downloadProgress
									 destination:(NSURL * (^_Nullable)(NSURL *targetPath, NSURLResponse *response))destination
									  completion:(void (^_Nullable)(NSURLResponse *response, NSURL *_Nullable filePath, NSError *_Nullable error))completion;

/// 下载(自动判断是否断点续传)
- (NSURLSessionDownloadTask *)sendDownloadRequest:(NSURLRequest *)URLRequest
									 downloadPath:(NSString *)downloadPath
										 progress:(CMHTTPRequestProgressBlock)downloadProgress
									   completion:(void (^_Nullable)(NSURLResponse *response, NSURL *_Nullable filePath, NSError *_Nullable error))completion;

@end

@interface CMHTTPSession (CMHTTPRequest)

- (NSURLSessionDataTask *)sendRequest:(CMHTTPRequest *)request
						   completion:(CMHTTPRequestCompletionBlock _Nullable)completion;

- (NSURLSessionDataTask *)sendRequest:(CMHTTPRequest *)request
					   uploadProgress:(CMHTTPRequestProgressBlock _Nullable)uploadProgress
					 downloadProgress:(CMHTTPRequestProgressBlock _Nullable)downloadProgress
						   completion:(CMHTTPRequestCompletionBlock _Nullable)completion;

@end


@interface CMHTTPSession (CMHTTPMethods)

- (NSURLSessionDataTask *_Nullable)HEAD:(NSString *)url
                                 params:(id)params
                                success:(void (^_Nullable)(NSURLSessionDataTask *task))success
                                failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (NSURLSessionDataTask *_Nullable)GET:(NSString *)url
								params:(id _Nullable)params
							  progress:(CMHTTPRequestProgressBlock _Nullable)downloadProgress
							   success:(void (^_Nullable)(NSURLSessionDataTask *task, id _Nullable responseObject))success
							   failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (NSURLSessionDataTask *_Nullable)POST:(NSString *)url
								 params:(id _Nullable)params
							   progress:(CMHTTPRequestProgressBlock _Nullable)uploadProgress
								success:(void (^_Nullable)(NSURLSessionDataTask *task, id _Nullable responseObject))success
								failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (NSURLSessionDataTask *_Nullable)PUT:(NSString *)url
                                params:(id)params
                               success:(void (^_Nullable)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (NSURLSessionDataTask *_Nullable)PATCH:(NSString *)url
                                  params:(id)params
                                 success:(void (^_Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                                 failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (NSURLSessionDataTask *_Nullable)DELETE:(NSString *)url
                                   params:(id)params
                                  success:(void (^_Nullable)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

@end

@interface CMHTTPRequest (CMHTTPSession)

@property(nonatomic, copy, nullable) CMHTTPRequestProgressBlock uploadProgressHandler;	///< 上传进度回调
@property(nonatomic, copy, nullable) CMHTTPRequestProgressBlock downloadProgressHandler;///< 下载进度回调
@property(nonatomic, copy, nullable) CMHTTPRequestCompletionBlock completionHandler;	///< 请求结束回调

- (void)send;
- (void)sendWithCompletion:(CMHTTPRequestCompletionBlock _Nullable)completion;
- (void)sendWithSession:(CMHTTPSession *_Nullable)session
			 completion:(CMHTTPRequestCompletionBlock _Nullable)completion;

/**
 发送请求，若未传 session 则调用 CMHTTPSession.defaultSession

 @param session 请求会话
 */
- (void)sendWithSession:(CMHTTPSession *_Nullable)session;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END

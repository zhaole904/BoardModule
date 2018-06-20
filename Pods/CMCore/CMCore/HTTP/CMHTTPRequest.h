//
//  CMHTTPRequest.h
//  CMCore
//
//  Created by PengTao on 2017/12/11.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMHTTPFormData : NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) id body;
@property(nonatomic, copy) NSString *fileName;
@property(nonatomic, copy) NSString *mimeType;
@end

@interface CMHTTPRequest : NSObject

@property(readonly, nonatomic, strong, nullable) NSURLRequest *URLRequest;	///< URLRequest对象
@property(readonly, nonatomic, strong, nullable) NSURLResponse *URLResponse;///< NSHTTPURLResponse对象
@property(readonly, nonatomic, strong, nullable) NSURLSessionDataTask *URLSessionTask;	///< URL会话任务
@property(readonly, nonatomic, strong, nullable) NSData *responseData;		///< 请求响应Data数据
@property(readonly, nonatomic, strong, nullable) id responseObj;			///< 请求响应数据解析后对象

@property(readonly, nonatomic, copy) NSString *url;	///< URL地址
- (instancetype)initWithUrl:(NSString *)url NS_DESIGNATED_INITIALIZER;	///< 初始化方法

@property(nonatomic, copy) NSString *HTTPMethod;	///< 请求方法
@property(nonatomic, copy, nullable) NSDictionary<NSString *, NSString *> *headers;	///< 请求头

@property(nonatomic, copy, nullable) id params;		///< 请求参数
@property(nonatomic, assign) NSTimeInterval timeoutInterval;///< 请求超时设置
@property(nonatomic, assign) BOOL allowsCellularAccess;		///< 是否允许蜂窝网络
@property(nonatomic, assign) BOOL HTTPShouldHandleCookies;	///< 是否允许处理 Cookies
@property(nonatomic, assign) NSURLRequestNetworkServiceType networkServiceType;	///< 设置网络服务类型

@property(nonatomic, readonly) BOOL isRequesting;	///< 是否正在请求

@end

#pragma mark - Download

@interface CMHTTPRequest (Download)

@property(nonatomic, copy, nullable) NSString *downloadPath;	///< 下载存储路径

@end

#pragma mark - Upload

@interface CMHTTPRequest (Upload)

@property(readonly, nonatomic, strong, nullable) NSArray<CMHTTPFormData *> *formDataArray;

/**
 添加上传Data数据
 
 @param data 上传数据
 @param name 名称
 */
- (void)addFormData:(NSData *)data withName:(NSString *)name;

/**
 添加上传文件数据
 
 @param data 	 上传数据
 @param name 	 参数名
 @param fileName 文件名
 @param mimeType MIME类型
 */
- (void)addFormData:(NSData *)data
			   name:(NSString *)name
		   fileName:(NSString *)fileName
		   mimeType:(NSString *)mimeType;

/**
 添加上传文件
 
 @param fileURL 文件地址
 @param name 	参数名
 */
- (void)addFormDataWithFileURL:(NSURL *)fileURL name:(NSString *)name;

/**
 添加上传文件
 
 @param fileURL	 文件地址
 @param name 	 参数名
 @param fileName 文件名
 @param mimeType MIME类型
 */
- (void)addFormDataWithFileURL:(NSURL *)fileURL
						  name:(NSString *)name
					  fileName:(NSString *)fileName
					  mimeType:(NSString *)mimeType;

@end

NS_ASSUME_NONNULL_END

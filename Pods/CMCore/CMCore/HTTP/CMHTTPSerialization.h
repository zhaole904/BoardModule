//
//  CMHTTPSerialization.h
//  CMCore
//
//  Created by PengTao on 2017/12/14.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMHTTPRequest;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSTimeInterval const CMHTTPDefaultTimeoutInterval;

#pragma mark - 

@protocol CMHTTPSerializer <NSObject, NSCopying>

/**
 系统会话配置
 系统 NSURLSession 创建时会copy此属性，然后这个配置就无用了可置为nil
 */
@property(readonly, nonatomic, nullable) NSURLSessionConfiguration *sessionConfiguration;

@property(readonly, nonatomic, nullable) NSURL *baseURL;	///< host
@property(readonly, nonatomic, nullable) NSDictionary<NSString *, NSString *> *HTTPRequestHeaders; ///< [全局默认] 请求头
@property(readonly, nonatomic) NSTimeInterval timeoutInterval;	///< 超时
@property(readonly, nonatomic) BOOL allowsCellularAccess;	///< 是否允许蜂窝网络
@property(readonly, nonatomic) BOOL HTTPShouldHandleCookies;///< 是否允许处理 Cookie
@property(readonly, nonatomic) NSURLRequestNetworkServiceType networkServiceType; ///< 网络服务类型

/**
 请求转换( 将 CMHTTPRequest 转换成系统可用的 NSURLRequest )

 @param request 自定义请求类对象( CMHTTPRequest )
 @param error 错误对象
 @return 系统类对象
 */
- (NSURLRequest *_Nullable)requestBySerializingRequest:(CMHTTPRequest *)request error:(NSError *__autoreleasing _Nullable *)error NS_SWIFT_NOTHROW;

@end

#pragma mark -

@interface CMHTTPSerializer : NSObject <CMHTTPSerializer>

@property(nonatomic, strong, nullable) NSURL *baseURL;
@property(nonatomic, strong, nullable) NSURLSessionConfiguration *sessionConfiguration;

@property(nonatomic, nullable) NSDictionary<NSString *, NSString *> *HTTPRequestHeaders;
@property(nonatomic, assign) NSTimeInterval timeoutInterval;
@property(nonatomic, assign) BOOL allowsCellularAccess;
@property(nonatomic, assign) BOOL HTTPShouldHandleCookies; ///< 是否允许处理Cookie 默认YES
@property(nonatomic, assign) NSURLRequestNetworkServiceType networkServiceType;

@end

#pragma mark - 

@interface CMJSONSerializer : CMHTTPSerializer

@end

NS_ASSUME_NONNULL_END

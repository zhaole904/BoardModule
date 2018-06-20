//
//  OABoardHTTPManager.m
//  BoardModule
//
//  Created by 赵乐 on 2018/5/21.
//

#import "OABoardHTTPManager.h"
#import <RHBaseKit/RHDevice.h>
//#import <RHLog/RHLog.h>
#import <CMModuleCenter/CMModuleCenter.h>
#import <CMCore/CMCore.h>

//生产环境baseUrl
NSString *const CM_OA_BOARD_URL_HOST_PRODUCT = @"https://gw.cmrh.com";

//开发环境baseUrl
NSString *const CM_OA_BOARD_URL_HOST_Develop = @"https://gw.dev.cmrh.com:5001";

//测试环境baseUrl
NSString *const CM_OA_BOARD_URL_HOST_Beta = @"https://gw.dev.cmrh.com:5001";

NSString *const CM_OA_BOARD_Net_UserAgent = @"com.cmrh.app";

@implementation OABoardHTTPManager

+ (instancetype)sharedManager {
    static OABoardHTTPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OABoardHTTPManager alloc] init];
        manager.baseUrlStr = CM_OA_BOARD_URL_HOST_PRODUCT;  //默认是生产环境
        
        if ([CMAppContext shareContext].environment == CMAppEnvironmentProduct) {
            manager.baseUrlStr = CM_OA_BOARD_URL_HOST_PRODUCT;
        } else if ([CMAppContext shareContext].environment == CMAppEnvironmentBeta) {
            manager.baseUrlStr = CM_OA_BOARD_URL_HOST_Beta;
        } else {
            manager.baseUrlStr = CM_OA_BOARD_URL_HOST_Develop;
        }

    });
    return manager;
}

- (NSURLSessionDataTask *)POST:(NSString *)url params:(NSDictionary *)params completion:(RHOAHTTPResponseBlock)completion {
    NSString *paramsString = [NSString stringWithFormat:@"%@", params];
    
//    RHLogDebugT(@"HTTP",
//                @"---------- HTTP Request Start ----------"
//                "\nURL: %@"
//                "\nMethods: POST"
//                "\nParams: %@"
//                "\n------------------ End ------------------"
//                , url
//                , paramsString
//                );
    
    CMHTTPSerializer *serializer = [[CMJSONSerializer alloc] init];
    serializer.baseURL = [NSURL URLWithString:self.baseUrlStr];
    
    CMHTTPSession *session = [[CMHTTPSession alloc] initWithSerializer:serializer deserializer:nil];
    
    NSURLSessionDataTask *sessiontask = [session POST:url params:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
        RHHttpResultModel *httpResult = [self requrstSuccessWithResponse:response andObject:responseObject];
        if (httpResult.result) {
            NSLog(@"HTTP",
                        @"---------- HTTP Request Success ----------"
                        "\nURL: %@"
                        "\nMethods: POST"
                        "\nParams: %@"
                        "\nStatusCode: %zi"
                        "\nResponse: %@"
                        "\n------------------ End ------------------"
                        , url
                        , paramsString
                        , response.statusCode
                        , httpResult.data
                        );
        } else {
            NSLog(@"HTTP",
                        @"---------- HTTP Request Failure ----------"
                        "\nURL: %@"
                        "\nMethods: POST"
                        "\nStatusCode: %zi"
                        "\nError: %@"
                        "\n------------------ End ------------------"
                        , url
                        , response.statusCode
                        , httpResult.message
                        );
        }
        completion(httpResult);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
        NSLog(@"HTTP",
                    @"---------- HTTP Request Failure ----------"
                    "\nURL: %@"
                    "\nMethods: POST"
                    "\nStatusCode: %zi"
                    "\nError: %@"
                    "\n------------------ End ------------------"
                    , url
                    , response.statusCode
                    , error.localizedDescription
                    );
        
        
        RHHttpResultModel *httpResult = [[RHHttpResultModel alloc] init];
        httpResult.response = response;
        httpResult.result = NO;
        httpResult.message = @"网络异常，请稍后再试";
        httpResult.statusCode = response.statusCode;
        httpResult.data = nil;
        
        completion(httpResult);
    }];
    return sessiontask;
}

- (RHHttpResultModel *)requrstSuccessWithResponse:(NSHTTPURLResponse *)httpResponse andObject:(id)responseObject {
    RHHttpResultModel *httpResult = [[RHHttpResultModel alloc]init];
    httpResult.response = httpResponse;
    
    if (httpResponse.statusCode == 200) {
        NSError *error = nil;
        //        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        
        if (error) {
            
            httpResult.result = NO;
            httpResult.message = @"服务器异常(200)";
            httpResult.statusCode = httpResponse.statusCode;
            httpResult.data = nil;
            
        } else {
            
            httpResult.result = YES;
            httpResult.message = @"请求成功";
            httpResult.statusCode = httpResponse.statusCode;
            httpResult.data = responseObject;
            
        }
    } else {
        
        httpResult.result = NO;
        httpResult.message = @"服务器异常，请稍后再试";
        httpResult.statusCode = httpResponse.statusCode;
        httpResult.data = nil;
        
    }
    
    return httpResult;
}

#pragma mark - Utils

+ (NSString *)clientInfo {
    NSString *clientInfo = nil; // 应用名/应用版本(机型及型号;操作系统版本;屏幕分辨率);
#if TARGET_OS_IOS
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    clientInfo = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)",
                  NSBundle.mainBundle.infoDictionary[(__bridge NSString *)kCFBundleExecutableKey] ?: NSBundle.mainBundle.infoDictionary[(__bridge NSString *)kCFBundleIdentifierKey],
                  NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"] ?: NSBundle.mainBundle.infoDictionary[(__bridge NSString *)kCFBundleVersionKey],
                  RHDevice.platformString ?: UIDevice.currentDevice.model,
                  UIDevice.currentDevice.systemVersion,
                  UIScreen.mainScreen.scale];
#elif TARGET_OS_WATCH
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    clientInfo = [NSString stringWithFormat:@"%@/%@ (%@; watchOS %@; Scale/%0.2f)",
                  NSBundle.mainBundle.infoDictionary[(__bridge NSString *)kCFBundleExecutableKey] ?: NSBundle.mainBundle.infoDictionary[(__bridge NSString *)kCFBundleIdentifierKey],
                  NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"] ?: NSBundle.mainBundle.infoDictionary[(__bridge NSString *)kCFBundleVersionKey],
                  RHDevice.platformString ?: WKInterfaceDevice.currentDevice.model,
                  WKInterfaceDevice.currentDevice.systemVersion,
                  WKInterfaceDevice.currentDevice.screenScale];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    clientInfo = [NSString stringWithFormat:@"%@/%@ (macOS %@)",
                  NSBundle.mainBundle.infoDictionary[(__bridge NSString *)kCFBundleExecutableKey] ?: NSBundle.mainBundle.infoDictionary[(__bridge NSString *)kCFBundleIdentifierKey],
                  NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"] ?: NSBundle.mainBundle.infoDictionary[(__bridge NSString *)kCFBundleVersionKey],
                  NSProcessInfo.processInfo.operatingSystemVersionString];
#endif
    if (clientInfo) {
        if (![clientInfo canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableClientInfo = [clientInfo mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)mutableClientInfo,
                                  NULL,
                                  (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove",
                                  false)) {
                clientInfo = mutableClientInfo;
            }
        }
    }
    
    return clientInfo;
}
@end

@implementation OABoardHTTPManager (Action)

- (NSURLSessionDataTask *)loginRequestDataWithUser:(NSString *)user password:(NSString *)pwd deviceId:(NSString *)deviceId completion:(RHOAHTTPResponseBlock)backResult{
    
    NSMutableDictionary *detailParams = [NSMutableDictionary dictionary];
    detailParams[@"action"]         = @"login";
    detailParams[@"username"]       = user;
    detailParams[@"password"]       = pwd;
    detailParams[@"RF—DEVICE-ID"]   = deviceId;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"login";
    params[@"params"] = detailParams;
    
    return [self POST:@"/login" params:params completion:backResult];
}

- (NSURLSessionDataTask *)logoutRequestDataWithCompletion:(RHOAHTTPResponseBlock)backResult{
    return [self POST:@"/logout" params:@{} completion:backResult];
}

- (NSURLSessionDataTask *)chkVersion:(NSString *)appId appSysType:(NSString *)appSysType buildNo:(NSNumber *)buildNo completion:(RHOAHTTPResponseBlock)backResult{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"]       = self.userID ?: @"";
    params[@"appId"]        = appId;
    params[@"appSysType"]   = appSysType;
    params[@"buildNo"]      = buildNo;
    
    return [self POST:@"/RH_MAS/base/v1.0/chkVersion" params:params completion:backResult];
}

- (NSURLSessionDataTask *)addLoginInfo:(NSString *)deviceId deviceToken:(NSString *)deviceToken tokenType:(NSString *)tokenType completion:(RHOAHTTPResponseBlock)backResult{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appId"]      = @"moa";
    params[@"deviceId"]   = deviceId ?: @"";
    params[@"deviceToken"]= deviceToken ?: @"";
    params[@"tokenType"]  = tokenType ?: @"";
    
    return [self POST:@"/RH_MAS/base/v1.0/addLoginInfo" params:params completion:backResult];
}

- (NSURLSessionDataTask *)invalidLoginInfo:(NSString *)deviceId completion:(RHOAHTTPResponseBlock)backResult {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appId"]      = @"moa";
    params[@"deviceId"]   = deviceId;
    
    return [self POST:@"/RH_MAS/base/v1.0/invalidLoginInfo" params:params completion:backResult];
}

- (NSURLSessionDataTask *)showPasswordViewCompletion:(RHOAHTTPResponseBlock)backResult{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    return [self POST:@"https://ws.cmrh.com/RH_UM/password" params:params completion:backResult];
}

- (NSURLSessionDataTask *)getDeviceIdFromServerWithCompletion:(RHOAHTTPResponseBlock)backResult{
    return [self POST:@"/RH_MAS/base/v1.0/getDeviceId" params:@{} completion:backResult];
}

- (NSURLSessionDataTask *)getUserLimitBranchData:(NSString *)brancePara completion:(RHOAHTTPResponseBlock)backResult {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"brancePara"] = brancePara;
    
    return [self POST:@"/RH_MAS/bus/v1.0/stmmp/report/userLimitBranch" params:params completion:backResult];
}

- (NSURLSessionDataTask *)getBranchSumData:(NSString *)deptTypePara brancePara:(NSString *)brancePara flagPara:(NSString *)flagPara completion:(RHOAHTTPResponseBlock)backResult {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deptTypePara"] = deptTypePara;
    params[@"brancePara"] = brancePara;
    params[@"flagPara"] = flagPara;
    
    return [self POST:@"/RH_MAS/bus/v1.0/stmmp/report/getBranchSumData" params:params completion:backResult];
}

- (NSURLSessionDataTask *)getBranchDetailData:(NSString *)deptTypePara brancePara:(NSString *)brancePara flagPara:(NSString *)flagPara completion:(RHOAHTTPResponseBlock)backResult {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deptTypePara"] = deptTypePara;
    params[@"brancePara"] = brancePara;
    params[@"flagPara"] = flagPara;
    
    return [self POST:@"/RH_MAS/bus/v1.0/stmmp/report/getBranchDetailData" params:params completion:backResult];
}

- (NSURLSessionDataTask *)getScaleRankData:(NSString *)deptTypePara brancePara:(NSString *)brancePara flagPara:(NSString *)flagPara completion:(RHOAHTTPResponseBlock)backResult {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deptTypePara"] = deptTypePara;
    params[@"brancePara"] = brancePara;
    params[@"flagPara"] = flagPara;
    
    return [self POST:@"/RH_MAS/bus/v1.0/stmmp/report/scaleRank" params:params completion:backResult];
}

- (NSURLSessionDataTask *)getProductData:(NSString *)deptTypePara brancePara:(NSString *)brancePara flagPara:(NSString *)flagPara completion:(RHOAHTTPResponseBlock)backResult {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deptTypePara"] = deptTypePara;
    params[@"brancePara"] = brancePara;
    params[@"flagPara"] = flagPara;
    
    return [self POST:@"/RH_MAS/bus/v1.0/stmmp/report/product" params:params completion:backResult];
}

- (NSURLSessionDataTask *)getBranchInfoData:(NSString *)brancePara flagPara:(NSString *)flagPara completion:(RHOAHTTPResponseBlock)backResult {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"brancePara"] = brancePara;
    params[@"flagPara"] = flagPara;
    
    return [self POST:@"/RH_MAS/bus/v1.0/stmmp/report/branchInfo" params:params completion:backResult];
}

- (NSURLSessionDataTask *)getInsuranceperformanceDataWithKey:(NSString *)key params:(NSDictionary *)params completion:(RHOAHTTPResponseBlock)backResult {
    
    NSString *urlStr = [NSString stringWithFormat:@"/RH_MAS/bus/v1.0/stmmp/report/%@",key];
    return [self POST:urlStr params:params completion:backResult];
}

@end

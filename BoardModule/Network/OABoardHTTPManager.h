//
//  OABoardHTTPManager.h
//  BoardModule
//
//  Created by 赵乐 on 2018/5/21.
//

#import <Foundation/Foundation.h>
//#import <AFNetworking/AFNetworking.h>
#import <RHBaseKit/RHHttpResultModel.h>

#define KgetResultFlag(data) [data[@"flag"] isEqualToString:@"Y"]
#define KgetResultMessage(data) data[@"message"]
#define KgetResultParam(data,key) data[@"param"][key]

typedef void (^RHOAHTTPResponseBlock)(RHHttpResultModel *resultData);

@interface OABoardHTTPManager : NSObject

@property(class, nonatomic, readonly) NSString *clientInfo;
@property(nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *baseUrlStr;

+ (instancetype)sharedManager;

- (RHHttpResultModel *)requrstSuccessWithResponse:(NSHTTPURLResponse *)httpResponse andObject:(id)object;

- (NSURLSessionDataTask *)POST:(NSString *)url
params:(NSDictionary *)params
                    completion:(RHOAHTTPResponseBlock)completion;

- (NSURLSessionDataTask *)GET:(NSString *)url
                       params:(NSDictionary *)params
                   completion:(RHOAHTTPResponseBlock)completion;
@end


@interface OABoardHTTPManager (Action)
- (NSURLSessionDataTask *)showPasswordViewCompletion:(RHOAHTTPResponseBlock)backResult;
/**
 登录GW
 
 @param user 登录账号
 @param pwd 登录密码
 @param deviceId 设备唯一标识
 @param backResult 返回结果（具体内容看接口问题）
 */
- (NSURLSessionDataTask *)loginRequestDataWithUser:(NSString *)user
                                  password:(NSString *)pwd
                                  deviceId:(NSString *)deviceId
                                completion:(RHOAHTTPResponseBlock)backResult;
/**
 清除GW登录信息
 
 @param backResult 返回结果（具体内容看接口问题）
 */
- (NSURLSessionDataTask *)logoutRequestDataWithCompletion:(RHOAHTTPResponseBlock)backResult;

/**
 判断当前版本的App是否是否需要升级
 
 @param appId App标识
 @param appSysType 系统类型
 @param buildNo 内部版本号
 @param backResult 返回结果（具体内容看接口问题）
 */
- (NSURLSessionDataTask *)chkVersion:(NSString *)appId
                          appSysType:(NSString *)appSysType
                             buildNo:(NSNumber *)buildNo
                          completion:(RHOAHTTPResponseBlock)backResult;

/**
 上传登录用户信息
 
 @param deviceId 设备唯一标识
 @param deviceToken 推送Token
 @param tokenType 推送平台类型
 @param backResult 返回结果（具体内容看接口问题）
 */
- (NSURLSessionDataTask *)addLoginInfo:(NSString *)deviceId
                           deviceToken:(NSString *)deviceToken
                             tokenType:(NSString *)tokenType
                            completion:(RHOAHTTPResponseBlock)backResult;

/**
 从服务器生产设备唯一标识
 
 @param backResult 返回结果（具体内容看接口问题）
 */
- (NSURLSessionDataTask *)getDeviceIdFromServerWithCompletion:(RHOAHTTPResponseBlock)backResult;

/**
 MAS上注销登录用户信息
 
 @param deviceId 设备唯一标识
 @param backResult 返回结果（具体内容看接口问题）
 */
- (NSURLSessionDataTask *)invalidLoginInfo:(NSString *)deviceId
                                completion:(RHOAHTTPResponseBlock)backResult;

/**
 用户个险产看权限
 @param brancePara 机构代码
 @param backResult 返回结果（具体内容看接口问题）
 */
- (NSURLSessionDataTask *)getUserLimitBranchData:(NSString *)brancePara completion:(RHOAHTTPResponseBlock)backResult;


/**
  个险接口总汇（个险总汇，个险明细，规保排名，产品结构）

 @param key /api
 @param params 入参
 @param backResult 返回结果
 */
- (NSURLSessionDataTask *)getInsuranceperformanceDataWithKey:(NSString *)key params:(NSDictionary *)params completion:(RHOAHTTPResponseBlock)backResult;



/**
 个险总汇
 @param deptTypePara 业务代码
 01 - 传统／ 40 - 招证 ／41 - 经代／ A - 个险
 
 @param brancePara 机构代码
 @param flagPara 是否选择机构
 @param backResult 返回结果（具体内容看接口问题）
 */
- (NSURLSessionDataTask *)getBranchSumData:(NSString *)deptTypePara brancePara:(NSString *)brancePara flagPara:(NSString *)flagPara completion:(RHOAHTTPResponseBlock)backResult;

/**
 个险明细
 */
- (NSURLSessionDataTask *)getBranchDetailData:(NSString *)deptTypePara brancePara:(NSString *)brancePara flagPara:(NSString *)flagPara completion:(RHOAHTTPResponseBlock)backResult;

/**
 规保排名
 */
- (NSURLSessionDataTask *)getScaleRankData:(NSString *)deptTypePara brancePara:(NSString *)brancePara flagPara:(NSString *)flagPara completion:(RHOAHTTPResponseBlock)backResult;

/**
 产品结构
 */
- (NSURLSessionDataTask *)getProductData:(NSString *)deptTypePara brancePara:(NSString *)brancePara flagPara:(NSString *)flagPara completion:(RHOAHTTPResponseBlock)backResult;

/**
 切换机构
 @param deptTypePara 业务代码
 01 - 传统／ 40 - 招证 ／41 - 经代／ A - 个险
 
 @param brancePara 机构代码
 @param flagPara 是否选择机构
 @param backResult 返回结果（具体内容看接口问题）
 */
- (NSURLSessionDataTask *)getBranchInfoData:(NSString *)brancePara flagPara:(NSString *)flagPara completion:(RHOAHTTPResponseBlock)backResult;

@end




//
//  CMHTTPSerialization.m
//  CMCore
//
//  Created by PengTao on 2017/12/14.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#import "CMHTTPSerialization.h"
#import "CMHTTPRequest.h"
//#import "CMSerializer.h"

#if __has_include(<AFNetworking/AFURLRequestSerialization.h>)
#import <AFNetworking/AFURLRequestSerialization.h>
#else
#import "AFURLRequestSerialization.h"
#endif

extern NSString *const CMHTTPErrorDomain;

NSTimeInterval const CMHTTPDefaultTimeoutInterval = 60.f;

@interface CMHTTPSerializer ()
{
    @public
    AFHTTPRequestSerializer *_afSerializer;
}
//@property(nonatomic, strong) AFHTTPRequestSerializer *afSerializer;
@end

@implementation CMHTTPSerializer

@dynamic HTTPRequestHeaders, timeoutInterval, allowsCellularAccess, HTTPShouldHandleCookies, networkServiceType;

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ baseURL - %@", NSStringFromClass(self.class), self.baseURL];
}

- (instancetype)init {
	if (self = [super init]) {
		_sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
		self.timeoutInterval = CMHTTPDefaultTimeoutInterval;
        self.HTTPShouldHandleCookies = YES;
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	CMHTTPSerializer *obj = [[[self class] allocWithZone:zone] init];
	
	obj.baseURL = self.baseURL;
	obj.sessionConfiguration = self.sessionConfiguration;
	
	return obj;
}

- (NSDictionary<NSString *,NSString *> *)HTTPRequestHeaders {
	return self.afSerializer.HTTPRequestHeaders;
}
- (void)setHTTPRequestHeaders:(NSDictionary<NSString *,NSString *> *)HTTPRequestHeaders {
	for (NSString *header in HTTPRequestHeaders) {
		[self.afSerializer setValue:HTTPRequestHeaders[header] forHTTPHeaderField:header];
	}
}

- (NSTimeInterval)timeoutInterval {
	return self.afSerializer.timeoutInterval;
}
- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
	self.afSerializer.timeoutInterval = timeoutInterval;
}

- (BOOL)allowsCellularAccess {
	return self.afSerializer.allowsCellularAccess;
}
- (void)setAllowsCellularAccess:(BOOL)allowsCellularAccess {
	self.afSerializer.allowsCellularAccess = allowsCellularAccess;
}

- (BOOL)HTTPShouldHandleCookies {
	return self.afSerializer.HTTPShouldHandleCookies;
}
- (void)setHTTPShouldHandleCookies:(BOOL)HTTPShouldHandleCookies {
	self.afSerializer.HTTPShouldHandleCookies = HTTPShouldHandleCookies;
}

- (NSURLRequestNetworkServiceType)networkServiceType {
	return self.afSerializer.networkServiceType;
}
- (void)setNetworkServiceType:(NSURLRequestNetworkServiceType)networkServiceType {
	self.afSerializer.networkServiceType = networkServiceType;
}

- (AFHTTPRequestSerializer *)afSerializer {
	if (!_afSerializer) {
		_afSerializer = [AFHTTPRequestSerializer serializer];
	}
	return _afSerializer;
}

#pragma mark -

- (NSURLRequest *)requestBySerializingRequest:(CMHTTPRequest *)request error:(NSError * _Nullable __autoreleasing *)error {
	
	NSString *errorStr = nil;
	if (!request) {
		errorStr = @"request should not be nil";
	} else if (request.HTTPMethod.length == 0) {
		errorStr = @"request HTTPMethod should not be nil";
	} else if (request.url.length == 0) {
		errorStr = @"request Url should not be nil";
	}
	
	if (errorStr) {
		if (error) {
			*error = [NSError errorWithDomain:CMHTTPErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey:errorStr}];
		}
		return nil;
	}
	
	NSMutableURLRequest *URLRequest = nil;
	NSString *HTTPMethod = request.HTTPMethod;
	NSString *url = [NSURL URLWithString:request.url relativeToURL:self.baseURL].absoluteString;
	id params = request.params;
	
	if (request.formDataArray.count > 0 && [HTTPMethod isEqualToString:@"POST"]) {
		URLRequest = [self.afSerializer multipartFormRequestWithMethod:HTTPMethod URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
			for (CMHTTPFormData *formDataObj in request.formDataArray) {
				if ([formDataObj.body isKindOfClass:NSData.class]) {
					if (!formDataObj.fileName) {
						[formData appendPartWithFormData:formDataObj.body name:formDataObj.name];
					} else {
						[formData appendPartWithFileData:formDataObj.body name:formDataObj.name fileName:formDataObj.fileName mimeType:formDataObj.mimeType];
					}
				} else {
					if (!formDataObj.fileName) {
						[formData appendPartWithFileURL:formDataObj.body name:formDataObj.name error:error];
					} else {
						[formData appendPartWithFileURL:formDataObj.body name:formDataObj.name fileName:formDataObj.fileName mimeType:formDataObj.mimeType error:error];
					}
				}
			}
		} error:error];
	} else {
		URLRequest = [self.afSerializer requestWithMethod:HTTPMethod URLString:url parameters:params error:error];
	}
	
	if (URLRequest) {
		for(NSString *header in request.headers) {
			[URLRequest setValue:request.headers[header] forHTTPHeaderField:header];
		}
		URLRequest.timeoutInterval 			= request.timeoutInterval;
		URLRequest.allowsCellularAccess 	= request.allowsCellularAccess;
		URLRequest.HTTPShouldHandleCookies 	= request.HTTPShouldHandleCookies;
		URLRequest.networkServiceType 		= request.networkServiceType;
		
//		URLRequest.HTTPBody = [CMSerializer dataSerializedWithData:URLRequest.HTTPBody format:nil error:error];
		
	} else {
		if (error) {
			if (!*error) {
				errorStr = [NSString stringWithFormat:@"BuildURLRequest with Url-%@ Method-%@ failure : %@", request.url, request.HTTPMethod, errorStr];
				*error = [NSError errorWithDomain:CMHTTPErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:@{NSLocalizedDescriptionKey:errorStr}];
			}
		}
	}
	
	return URLRequest;
}

@end

#pragma mark -


#pragma mark -

@implementation CMJSONSerializer

- (AFHTTPRequestSerializer *)afSerializer {
    if (!_afSerializer) {
        _afSerializer = [AFJSONRequestSerializer serializer];
    }
    return _afSerializer;
}

@end

//
//  CMHTTPRequest.m
//  CMCore
//
//  Created by PengTao on 2017/12/11.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#import "CMHTTPRequest.h"

@implementation CMHTTPFormData
@end

@interface CMHTTPRequest ()

@property(readwrite, nonatomic, strong, nullable) NSURLRequest *URLRequest;
@property(readwrite, nonatomic, strong, nullable) NSURLResponse *URLResponse;
@property(readwrite, nonatomic, strong, nullable) NSURLSessionDataTask *URLSessionTask;
@property(readwrite, nonatomic, strong, nullable) NSData *responseData;
@property(readwrite, nonatomic, strong, nullable) id responseObj;

@property(nonatomic, copy, nullable) NSString *downloadPath;
@property(readwrite, nonatomic, strong, nullable) NSArray<CMHTTPFormData *> *formDataArray;

@end

@implementation CMHTTPRequest {
	NSString *_url;
}

@dynamic isRequesting;

- (NSString *)description {
	return [NSString stringWithFormat:@"%@", NSStringFromClass(self.class)];
}

- (instancetype)init {
	return [self initWithUrl:@""];
}
- (instancetype)initWithUrl:(NSString *)url {
	if (self = [super init]) {
		NSAssert(url || url.length > 0, @"CMHTTPRequest 初始化的 URL 不能为空");
		
		_url = url.copy;
		_HTTPMethod = @"GET";
		_timeoutInterval = 60;
	}
	return self;
}

#pragma mark - Upload

- (void)addFormData:(NSData *)data withName:(NSString *)name {
	NSParameterAssert(data);
	NSParameterAssert(name);
	
	CMHTTPFormData *formData = [[CMHTTPFormData alloc] init];
	formData.body = data;
	formData.name = name;
	[(NSMutableArray *)self.formDataArray addObject:formData];
}

- (void)addFormData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
	NSParameterAssert(data);
	NSParameterAssert(name);
	NSParameterAssert(fileName);
	NSParameterAssert(mimeType);
	
	CMHTTPFormData *formData = [[CMHTTPFormData alloc] init];
	formData.body = data;
	formData.name = name;
	formData.fileName = fileName;
	formData.mimeType = mimeType;
	[(NSMutableArray *)self.formDataArray addObject:formData];
}

- (void)addFormDataWithFileURL:(NSURL *)fileURL name:(NSString *)name {
	NSParameterAssert(fileURL);
	NSParameterAssert(name);
	
	CMHTTPFormData *formData = [[CMHTTPFormData alloc] init];
	formData.body = fileURL;
	formData.name = name;
	[(NSMutableArray *)self.formDataArray addObject:formData];
}

- (void)addFormDataWithFileURL:(NSURL *)fileURL name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
	NSParameterAssert(fileURL);
	NSParameterAssert(name);
	NSParameterAssert(fileName);
	NSParameterAssert(mimeType);
	
	CMHTTPFormData *formData = [[CMHTTPFormData alloc] init];
	formData.body = fileURL;
	formData.name = name;
	formData.fileName = fileName;
	formData.mimeType = mimeType;
	[(NSMutableArray *)self.formDataArray addObject:formData];
}

#pragma mark -

- (BOOL)isRequesting {
	if (_URLSessionTask) {
		switch (_URLSessionTask.state) {
			case NSURLSessionTaskStateRunning:
			case NSURLSessionTaskStateSuspended:
				return YES;
			default:return NO;
		}
	}
	return NO;
}

- (NSArray<CMHTTPFormData *> *)formDataArray {
	if (!_formDataArray) {
		_formDataArray = [NSMutableArray array];
	}
	return _formDataArray;
}

@end

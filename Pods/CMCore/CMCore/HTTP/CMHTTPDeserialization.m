//
//  CMHTTPDeserialization.m
//  CMCore
//
//  Created by PengTao on 2017/12/14.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#import "CMHTTPDeserialization.h"
//#import "CMSerializer.h"

#if __has_include(<AFNetworking/AFURLResponseSerialization.h>)
#import <AFNetworking/AFURLResponseSerialization.h>
#else
#import "AFURLResponseSerialization.h"
#endif

extern NSString *const CMHTTPErrorDomain;

@implementation CMHTTPDeserializer {
	AFJSONResponseSerializer *_jsonResponseSerializer;
	AFXMLParserResponseSerializer *_xmlParserResponseSerialzier;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@", NSStringFromClass(self.class)];
}

- (id)responseObjectByDeserializingData:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError * _Nullable __autoreleasing *)error {
	
//	data = [CMSerializer dataDeserializedWithData:data format:response.allHeaderFields[@"dataModel"] error:error];
	
	return [self.jsonResponseSerializer responseObjectForResponse:response data:data error:error];
}

- (id)responseObjectByDeserializingData:(NSData *)data response:(NSHTTPURLResponse *)response objClass:(Class)objClass error:(NSError * _Nullable __autoreleasing *)error {
	
	id responseObj = data;
	
	if (objClass && responseObj) {
		if ([responseObj isKindOfClass:NSDictionary.class]) {
			
			id obj = [[objClass alloc] init];
			[obj setValuesForKeysWithDictionary:(NSDictionary *)responseObj];
			
			return obj;
			
		} else if ([responseObj isKindOfClass:NSArray.class]) {
			
			NSMutableArray *objArray = [NSMutableArray array];
			for (id aObj in (NSArray *)responseObj) {
				id obj = [[objClass alloc] init];
				[obj setValuesForKeysWithDictionary:(NSDictionary *)aObj];
				[objArray addObject:obj];
			}
			
			return objArray;
		}
	}
	
	return responseObj;
}

- (void)setacceptableContentTypes:(NSSet <NSString *> *)acceptableContentTypes {
    self.jsonResponseSerializer.acceptableContentTypes = acceptableContentTypes;
}

- (NSSet <NSString *> *)acceptableContentTypes {
    return self.jsonResponseSerializer.acceptableContentTypes;
}

- (AFJSONResponseSerializer *)jsonResponseSerializer {
	if (!_jsonResponseSerializer) {
		_jsonResponseSerializer = [AFJSONResponseSerializer serializer];
		_jsonResponseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
	}
	return _jsonResponseSerializer;
}

- (AFXMLParserResponseSerializer *)xmlParserResponseSerialzier {
	if (!_xmlParserResponseSerialzier) {
		_xmlParserResponseSerialzier = [AFXMLParserResponseSerializer serializer];
		_xmlParserResponseSerialzier.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
	}
	return _xmlParserResponseSerialzier;
}


@end

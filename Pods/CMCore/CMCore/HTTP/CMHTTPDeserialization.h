//
//  CMHTTPDeserialization.h
//  CMCore
//
//  Created by PengTao on 2017/12/14.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CMHTTPDeserializer <NSObject>
- (id _Nullable)responseObjectByDeserializingData:(NSData *_Nullable)data
										response:(NSHTTPURLResponse *_Nullable)response
										   error:(NSError *__autoreleasing _Nullable *)error NS_SWIFT_NOTHROW;
@optional
- (id _Nullable)responseObjectByDeserializingData:(NSData *_Nullable)data
										response:(NSHTTPURLResponse *_Nullable)response
										objClass:(Class _Nullable)objClass
										   error:(NSError *__autoreleasing _Nullable *)error NS_SWIFT_NOTHROW;

- (void)setacceptableContentTypes:(NSSet <NSString *> *)acceptableContentTypes;

- (NSSet <NSString *> *)acceptableContentTypes;

@end

@interface CMHTTPDeserializer : NSObject <CMHTTPDeserializer>
@end

NS_ASSUME_NONNULL_END

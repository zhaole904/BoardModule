//
//  RHHttpResultModel.h
//  RHBaseKit
//
//  Created by song.zhang on 16/7/14.
//
//

#import <Foundation/Foundation.h>

@interface RHHttpResultModel : NSObject

@property(nonatomic, strong) NSHTTPURLResponse *response;

@property(nonatomic, assign) BOOL result;
@property(nonatomic, assign) NSInteger statusCode;
@property(nonatomic, copy  ) NSString *message;
@property(nonatomic, strong) id        data;

@end

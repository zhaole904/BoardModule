//
//  RHObserver.h
//  RHBaseKit
//
//  Created by PengTao on 2017/8/11.
//  Copyright © 2017年 CMRH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RHObserver : NSObject

@property(nonatomic, weak, readonly) id obj;
@property(nonatomic, copy, readonly) NSString *keyPath;
@property(nonatomic, assign, readonly) NSKeyValueObservingOptions options;

- (instancetype)initWithObserve:(id)obj
                        keyPath:(NSString *)keyPath
                        options:(NSKeyValueObservingOptions)options
                      didChange:(void(^_Nullable)(void))didChangeBlock;
- (instancetype)initWithObserve:(id)obj
                        keyPath:(NSString *)keyPath
                        options:(NSKeyValueObservingOptions)options
                         target:(id)target
                         action:(SEL)action;

+ (instancetype)observe:(id)obj
                keyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
              didChange:(void(^_Nullable)(void))didChangeBlock;
+ (instancetype)observe:(id)obj
                keyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                 target:(id)target
                 action:(SEL)action;

@property(nonatomic, copy, nullable) void(^didChangeBlock)(void) ;
- (void)addTarget:(id)target action:(SEL)action;
- (void)removeTarget:(id)target action:(SEL)action;

- (void)startObserveIfCan;
- (void)endObservation;

@end


@interface NSObject (RHObserver)

@property(nonatomic, readonly) NSSet *rh_observerMap;

- (RHObserver *)rh_observe:(id)obj
                   keyPath:(NSString *)keyPath
                   options:(NSKeyValueObservingOptions)options
                    target:(id)target
                    action:(SEL)action;

- (RHObserver *)rh_observe:(id)obj
                   keyPath:(NSString *)keyPath
                   options:(NSKeyValueObservingOptions)options
                 didChange:(void(^_Nullable)(void))didChangeBlock;

- (void)rh_removeObserve:(id)obj keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options;
- (void)rh_removeAllRHObserver;

@end

NS_ASSUME_NONNULL_END

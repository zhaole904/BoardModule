//
//  RHObserver.m
//  RHBaseKit
//
//  Created by PengTao on 2017/8/11.
//  Copyright © 2017年 CMRH. All rights reserved.
//

#import "RHObserver.h"
#import <objc/runtime.h>

@interface _RHObserverTargetInfo : NSObject
@property(nonatomic, weak) id target;
@property(nonatomic, strong) NSMutableSet<NSString *> *actionSet;
@end
@implementation _RHObserverTargetInfo
- (instancetype)init {
    if (self = [super init]) {
        _actionSet = [NSMutableSet set];
    }
    return self;
}
@end

@interface RHObserver ()

@property(nonatomic, weak, readwrite) id obj;
@property(nonatomic, copy, readwrite) NSString *keyPath;
@property(nonatomic, assign, readwrite) NSKeyValueObservingOptions options;

@property(nonatomic, strong) NSMutableSet<_RHObserverTargetInfo *> *targetMap;
@property(nonatomic, getter=isObserving) BOOL observing;

@end

@implementation RHObserver

- (instancetype)init {
    @throw [NSException exceptionWithName:NSMallocException reason:@"禁止使用该方法" userInfo:nil];
}

- (void)dealloc {
    [self endObservation];
}

#pragma mark - PublicMethods

+ (instancetype)observe:(id)obj
                keyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
              didChange:(void(^)(void))didChangeBlock {
    return [[RHObserver alloc] initWithObserve:obj keyPath:keyPath options:options didChange:didChangeBlock];
}
+ (instancetype)observe:(id)obj
                keyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                 target:(id)target
                 action:(SEL)action {
    return [[RHObserver alloc] initWithObserve:obj keyPath:keyPath options:options target:target action:action];
}
- (instancetype)initWithObserve:(id)obj
                        keyPath:(NSString *)keyPath
                        options:(NSKeyValueObservingOptions)options
                      didChange:(void(^)(void))didChangeBlock {
    
    if (self = [super init]) {
        _obj = obj;
        _keyPath = keyPath.copy;
        _options = options;
        _didChangeBlock = [didChangeBlock copy];
        _observing = NO;
        [self startObserveIfCan];
    }
    return self;
}
- (instancetype)initWithObserve:(id)obj
                        keyPath:(NSString *)keyPath
                        options:(NSKeyValueObservingOptions)options
                         target:(id)target
                         action:(SEL)action {
    
    if (self = [super init]) {
        _obj = obj;
        _keyPath = keyPath.copy;
        _options = options;
        _observing = NO;
        [self addTarget:target action:action];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action {
    for (_RHObserverTargetInfo *info in self.targetMap) {
        if (info.target == target) {
            if (![info.actionSet containsObject:NSStringFromSelector(action)]) {
                [info.actionSet addObject:NSStringFromSelector(action)];
            }
            [self startObserveIfCan];
            return;
        }
    }
    
    _RHObserverTargetInfo *info = [[_RHObserverTargetInfo alloc] init];
    info.target = target;
    [info.actionSet addObject:NSStringFromSelector(action)];
    
    @synchronized (self.targetMap) {
        [self.targetMap addObject:info];
    }
    
    [self startObserveIfCan];
}
- (void)removeTarget:(id)target action:(SEL)action {
    for (_RHObserverTargetInfo *info in self.targetMap) {
        if (info.target == target) {
            if ([info.actionSet containsObject:NSStringFromSelector(action)]) {
                [info.actionSet removeObject:NSStringFromSelector(action)];
            }
            if (info.actionSet.count == 0) {
                @synchronized (self.targetMap) {
                    [self.targetMap removeObject:info];
                }
            }
            break;
        }
    }
    
    [self _endObserveIfNeed];
}

- (void)startObserveIfCan {
    if ((_didChangeBlock != nil || _targetMap.count != 0) && _obj && !self.isObserving) {
        [self willChangeValueForKey:@"observing"];
        [_obj addObserver:self forKeyPath:_keyPath options:_options context:(__bridge void*)self];
        self.observing = YES;
        [self didChangeValueForKey:@"observing"];
    }
}
- (void)endObservation {
    if (self.isObserving && _obj != nil && _keyPath != nil) {
        [self willChangeValueForKey:@"observing"];
        [_obj removeObserver:self forKeyPath:_keyPath context:(__bridge void*)self];
        self.observing = NO;
        [self didChangeValueForKey:@"observing"];
    }
}
- (void)_endObserveIfNeed {
    // 删除失效target
    NSMutableSet *setTemp = [NSMutableSet set];
    for (_RHObserverTargetInfo *info in self.targetMap) { if (info.target == nil) { [setTemp addObject:info]; } }
    for (_RHObserverTargetInfo *info in setTemp) { [self.targetMap removeObject:info]; }
    
    if (_didChangeBlock == nil && _targetMap.count == 0) {
        [self endObservation];
    }
}

#pragma mark - Observe

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context != (__bridge void*)self) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if (_obj == object || [_keyPath isEqualToString:keyPath]) {
        switch (_options) {
            case NSKeyValueObservingOptionNew:
                if ([change.allKeys containsObject:NSKeyValueChangeNewKey]) {
                    [self _valueOfKeyPathDidChange];
                }
                break;
            case NSKeyValueObservingOptionOld:
                if ([change.allKeys containsObject:NSKeyValueChangeOldKey]) {
                    [self _valueOfKeyPathDidChange];
                }
                break;
            case NSKeyValueObservingOptionInitial:
                if (change.allKeys.count == 0 && [change.allKeys containsObject:NSKeyValueChangeKindKey]) {
                    [self _valueOfKeyPathDidChange];
                }
                break;
            case NSKeyValueObservingOptionPrior:
                if ([change.allKeys containsObject:NSKeyValueChangeNotificationIsPriorKey]) {
                    [self _valueOfKeyPathDidChange];
                }
                break;
                
            default:
                break;
        }
    }
}

- (void)_valueOfKeyPathDidChange {
    [self _endObserveIfNeed];
    if (!self.isObserving) { return; }
    
    if (self.didChangeBlock) {
        self.didChangeBlock();
    }
    
    for (_RHObserverTargetInfo *info in self.targetMap) {
        for (NSString *acion in info.actionSet) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [info.target performSelector:NSSelectorFromString(acion)];
#pragma clang diagnostic pop
        }
    }
}

#pragma mark - Getters & Setters

- (NSMutableSet<_RHObserverTargetInfo *> *)targetMap {
    if (!_targetMap) {
        _targetMap = [NSMutableSet set];
    }
    return _targetMap;
}

- (void)setDidChangeBlock:(void(^)(void))didChangeBlock {
    _didChangeBlock = [didChangeBlock copy];
    [self _endObserveIfNeed];
}

@end

@implementation NSObject (RHObserver)

- (RHObserver *)rh_observe:(id)obj
                   keyPath:(NSString *)keyPath
                   options:(NSKeyValueObservingOptions)options
                    target:(id)target
                    action:(SEL)action {
    return [self _rh_addObserve:self keyPath:keyPath options:options target:target action:action didChange:nil];
}

- (RHObserver *)rh_observe:(id)obj
                   keyPath:(NSString *)keyPath
                   options:(NSKeyValueObservingOptions)options
                 didChange:(void(^)(void))didChangeBlock {
    return [self _rh_addObserve:obj keyPath:keyPath options:options target:nil action:NULL didChange:didChangeBlock];
}

- (void)rh_removeObserve:(id)obj keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options {
    @synchronized (self) {
        NSMutableSet *set = self._rh_obobserver_Map;
        
        NSMutableSet *setTemp = [NSMutableSet set];
        for (RHObserver *observer in set) {
            if (![observer isKindOfClass:[RHObserver class]]) {
                [setTemp addObject:observer];
                continue;
            }
            if (observer.obj == obj && [observer.keyPath isEqualToString:keyPath] && observer.options == options) {
                [setTemp addObject:observer];
            }
        }
        
        for (RHObserver *observer in setTemp) {
            [set removeObject:observer];
        }
    }
}

- (void)rh_removeAllRHObserver {
    @synchronized (self) {
        [self._rh_obobserver_Map removeAllObjects];
        [self _rh_update_Observer_Map:nil];
    }
}

- (NSSet *)rh_observerMap {
    return self._rh_obobserver_Map.copy;
}

- (RHObserver *)_rh_addObserve:(id)obj
                       keyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                        target:(id)target
                        action:(SEL)action
                     didChange:(void(^)(void))didChangeBlock {
    NSMutableSet *set = self._rh_obobserver_Map;
    if (!set) {
        set = [NSMutableSet set];
        @synchronized (self) {
            [self _rh_update_Observer_Map:set];
        }
    }
    
    for (RHObserver *observer in set) {
        if (observer.obj == obj && [observer.keyPath isEqualToString:keyPath] && observer.options == options) {
            if (target != nil) {
                [observer addTarget:target action:action];
            } else if (didChangeBlock != nil) {
                observer.didChangeBlock = didChangeBlock;
            }
            return observer;
        }
    }
    
    RHObserver *observer = nil;
    if (target != nil) {
        observer = [RHObserver observe:obj keyPath:keyPath options:options target:target action:action];
    } else {
        observer = [RHObserver observe:obj keyPath:keyPath options:options didChange:didChangeBlock];
    }
    
    @synchronized (self) {
        [set addObject:observer];
    }
    return observer;
}

- (NSMutableSet *)_rh_obobserver_Map {
    return objc_getAssociatedObject(self, @selector(_rh_obobserver_Map));
}
- (void)_rh_update_Observer_Map:(NSMutableSet *)observerMap {
    objc_setAssociatedObject(self, @selector(_rh_obobserver_Map), observerMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

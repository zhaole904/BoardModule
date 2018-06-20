//
//  OABoardModule.m
//  BoardModule
//
//  Created by 赵乐 on 2018/5/22.
//

#import "OABoardModule.h"
#import <CMModuleCenter/CMModuleCenter.h>
#import "OABoardService.h"
#import "BoardModule-Swift.h"

@interface OABoardModule () <CMModule, OABoardService>

@end

@implementation OABoardModule
CM_MODULE_EXPORT

- (id)service:(Protocol *)service {
    if (service == @protocol(OABoardService)) {
        return self;
    }
    return nil;
}

- (UIViewController *)boardViewController {
    return [[OABoardViewController alloc] init];
}

- (UIViewController *)gbRankViewController {
    return [[OABoardGBRankViewController alloc] init];
}

- (UIViewController *)productMixViewController {
    return [[OABoardProductMixViewController alloc] init];
}

- (UIViewController *)switchOrganViewController {
    return [[OABoardSwitchOrganViewController alloc] init];
}
@end

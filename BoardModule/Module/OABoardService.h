//
//  OABoardService.h
//  BoardModule
//
//  Created by 赵乐 on 2018/5/21.
//

static NSString *const CMOAReloadEntrustDataNotification = @"CMOAReloadEntrustDataNotification"; /// 重载委托数据通

@protocol OABoardService <NSObject>

@property(nonatomic, readonly) UIViewController *gbRankViewController;  /// 规保排名

@property(nonatomic, readonly) UIViewController *productMixViewController;  /// 产品结构

@property(nonatomic, readonly) UIViewController *switchOrganViewController;  /// 切换机构

@property(nonatomic, readonly) UIViewController *boardViewController;  /// 主界面
@end

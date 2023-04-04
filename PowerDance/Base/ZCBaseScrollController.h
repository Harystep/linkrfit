//
//  ZCBaseScrollController.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/15.
//

#import "ZCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCBaseScrollController : ZCBaseViewController

@property (nonatomic,strong) UIScrollView *scView;
@property (nonatomic,strong) UIView *contentView;

@end

NS_ASSUME_NONNULL_END

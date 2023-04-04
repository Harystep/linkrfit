//
//  ZCBaseSlideController.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/9.
//

#import "ZCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCBaseSlideController : ZCBaseViewController

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView        *scrollView;
@property (nonatomic, assign) NSInteger pageIndex;

@end

NS_ASSUME_NONNULL_END

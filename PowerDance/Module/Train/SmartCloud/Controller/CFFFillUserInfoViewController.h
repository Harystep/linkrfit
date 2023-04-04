//
//  CFFFillUserInfoViewController.h
//  CofoFit
//
//  Created by PC-N121 on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import "CFFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CFFFillUserInfoViewController : ZCBaseViewController<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *topView;
@property (nonatomic,strong) UILabel *lblStep;
@property (nonatomic,strong) UILabel *lblMsg;
@property (nonatomic,strong) UILabel *lblSubMsg;
@property (nonatomic,strong) UIPageControl *pageIndex;

@property (nonatomic,strong) UIButton *btnBottom;


@end

NS_ASSUME_NONNULL_END

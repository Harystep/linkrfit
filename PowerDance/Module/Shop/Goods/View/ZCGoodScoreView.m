//
//  ZCGoodScoreView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/19.
//

#import "ZCGoodScoreView.h"

@interface ZCGoodScoreView ()<ZCStarRateViewDelegate>

@end

@implementation ZCGoodScoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"整体评价", nil) font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self).offset(AUTO_MARGIN(20));
    }];
            
    ZCStarRateView *rateView = [[ZCStarRateView alloc] initWithFrame:CGRectMake(AUTO_MARGIN(20), 55, (SCREEN_WIDTH - AUTO_MARGIN(80)), 30)];
    rateView.rateStyle = HalfStar;
    rateView.isAnimation = YES;
    rateView.delegate = self;
    self.rateView = rateView;
    [self addSubview:rateView];
}

- (void)starRateView:(ZCStarRateView *)starRateView currentScore:(CGFloat)currentScore {
    if(self.saveScoreOperate){
        self.saveScoreOperate(currentScore);
    }
}

@end

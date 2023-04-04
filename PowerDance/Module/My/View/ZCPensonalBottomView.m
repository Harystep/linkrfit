//
//  ZCPensonalBottomView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/12/2.
//

#import "ZCPensonalBottomView.h"

@implementation ZCPensonalBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.backgroundColor = [ZCConfigColor bgColor];
    
    CGFloat width = (SCREEN_W-AUTO_MARGIN(15)*3)/2.0;
    UIView *autoView = [[UIView alloc] init];
    [self addSubview:autoView];
    autoView.backgroundColor = [ZCConfigColor whiteColor];
    [autoView setViewCornerRadiu:AUTO_MARGIN(5)];
    [autoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(15));
        make.height.mas_equalTo(75);
        make.width.mas_equalTo(width);
    }];
    autoView.tag = 0;
    
    UIView *trainView = [[UIView alloc] init];
    [self addSubview:trainView];
    trainView.backgroundColor = [ZCConfigColor whiteColor];
    [trainView setViewCornerRadiu:AUTO_MARGIN(5)];
    [trainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.leading.mas_equalTo(autoView.mas_trailing).offset(AUTO_MARGIN(15));
        make.height.mas_equalTo(75);
        make.width.mas_equalTo(width);
    }];
    trainView.tag = 1;
    
    [self setupTargetView:autoView];
    [self setupTargetView:trainView];
    
    UIView *orderView = [[UIView alloc] init];
    [self addSubview:orderView];
    orderView.backgroundColor = [ZCConfigColor whiteColor];
    [orderView setViewCornerRadiu:AUTO_MARGIN(5)];
    [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(15));
        make.top.mas_equalTo(autoView.mas_bottom).offset(AUTO_MARGIN(10));
        make.height.mas_equalTo(75);
    }];
    orderView.tag = 2;
    [self setupTargetView:orderView];
}

- (void)setupTargetView:(UIView *)targetView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topViewClick:)];
    [targetView addGestureRecognizer:tap];
    NSDictionary *contentDic;
    if (targetView.tag == 0) {
        contentDic = @{@"title":NSLocalizedString(@"自由练习", nil), @"sub":NSLocalizedString(@"去练习", nil), @"image":@"personal_auto_icon"};
    } else if (targetView.tag == 1) {
        contentDic = @{@"title":NSLocalizedString(@"跟随练", nil), @"sub":NSLocalizedString(@"去练习", nil), @"image":@"home_train_plan_day"};
    } else {
        contentDic = @{@"title":NSLocalizedString(@"我的订单", nil), @"sub":NSLocalizedString(@"查看订单", nil), @"image":@"personal_order_icon"};
    }
    
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(contentDic[@"image"])];
    [targetView addSubview:iconIv];
    CGFloat marginX = AUTO_MARGIN(6);
    CGFloat iconMarginX = 18;
    CGFloat marginTop = 24;
    if (targetView.tag == 2) {
        marginX = 0;
        iconMarginX = 0;
        marginTop = 16;
    }
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(targetView.mas_centerY);
        make.leading.mas_equalTo(targetView.mas_leading).offset(iconMarginX);
    }];
    UILabel *titleL = [self createSimpleLabelWithTitle:contentDic[@"title"] font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [targetView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(targetView.mas_top).offset(marginTop);
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(marginX);
    }];
    
    UILabel *subL = [self createSimpleLabelWithTitle:contentDic[@"sub"] font:AUTO_MARGIN(9) bold:NO color:[ZCConfigColor subTxtColor]];
    [targetView addSubview:subL];
    [subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleL.mas_bottom).offset(4);
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(marginX);
    }];
        
}

- (void)topViewClick:(UITapGestureRecognizer *)tap {
    if (tap.view.tag == 1) {//跟随练   FollowTrain
        [HCRouter router:@"FollowTrain" params:@{} viewController:self.superViewController animated:YES];
    } else if(tap.view.tag == 2) {//我的订单
        [HCRouter router:@"MyOrderList" params:@{} viewController:self.superViewController animated:YES];
    } else {//自由练
        [HCRouter router:@"AutoExercise" params:@{} viewController:self.superViewController animated:YES];
    }
}

@end

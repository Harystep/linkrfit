//
//  ZCHomeTrainRangeGuideView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/30.
//

#import "ZCHomeTrainRangeGuideView.h"

@interface ZCHomeTrainRangeGuideView ()

@property (nonatomic,strong) UILabel *dayL;
@property (nonatomic,strong) UILabel *classL;
@property (nonatomic,strong) UILabel *basicL;

@end

@implementation ZCHomeTrainRangeGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [ZCConfigColor whiteColor];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_plan_guide_bg")];
    [self addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"计划安排", nil) font:14 bold:NO color:[ZCConfigColor point8TxtColor]];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(20));
    }];
    
    UIButton *btn = [self createSimpleButtonWithTitle:NSLocalizedString(@"使用计划", nil) font:AUTO_MARGIN(14) color:[ZCConfigColor whiteColor]];
    [self addSubview:btn];
    btn.backgroundColor = [ZCConfigColor whiteColor];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(35));
        make.width.mas_equalTo(AUTO_MARGIN(126));
        make.height.mas_equalTo(36);
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(12));
        
    }];
    [btn addTarget:self action:@selector(nextOperate) forControlEvents:UIControlEventTouchUpInside];
    [btn configureLeftToRightViewColorGradient:btn width:AUTO_MARGIN(126) height:36 one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:18];
    
    UIButton *resetBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"重新设定", nil) font:AUTO_MARGIN(14) color:rgba(138, 205, 215, 1)];
    [self addSubview:resetBtn];
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(35));
        make.width.mas_equalTo(AUTO_MARGIN(126));
        make.height.mas_equalTo(36);
        make.centerY.mas_equalTo(btn.mas_centerY);
    }];
    [resetBtn setViewBorderWithColor:1 color:rgba(138, 205, 215, 1)];
    [resetBtn addTarget:self action:@selector(resetOperate) forControlEvents:UIControlEventTouchUpInside];
    [resetBtn setViewCornerRadiu:18];
    
    CGFloat width = (SCREEN_W - AUTO_MARGIN(20)*2-AUTO_MARGIN(24)*2-AUTO_MARGIN(6)*2)/3.0;
    UIView *dayView = [[UIView alloc] init];
    [self addSubview:dayView];
    [dayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(24));
        make.height.mas_equalTo(109);
        make.top.mas_equalTo(lb.mas_bottom).offset(15);
    }];
    [dayView configureViewColorGradient:dayView width:width height:109 one:rgba(255, 241, 220, 1) two:rgba(255, 255, 255, 1) cornerRadius:5];
    
    UIView *classView = [[UIView alloc] init];
    [self addSubview:classView];
    [classView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(109);
        make.centerY.mas_equalTo(dayView.mas_centerY);
    }];
    [classView configureViewColorGradient:classView width:width height:109 one:rgba(253, 219, 204, 1) two:rgba(255, 255, 255, 1) cornerRadius:5];
    
    UIView *basicView = [[UIView alloc] init];
    [self addSubview:basicView];
    [basicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.leading.mas_equalTo(classView.mas_trailing).offset(AUTO_MARGIN(6));
        make.height.mas_equalTo(109);
        make.centerY.mas_equalTo(dayView.mas_centerY);
    }];
    [basicView configureViewColorGradient:basicView width:width height:109 one:rgba(213, 254, 251, 1) two:rgba(255, 255, 255, 1) cornerRadius:5];
    
    [self configureDayViewSubviews:dayView];
    [self configureClassViewSubviews:classView];
    [self configureBasicViewSubviews:basicView];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    [self addSubview:leftBtn];
    [leftBtn setImage:kIMAGE(@"home_guide_arrow_left") forState:UIControlStateNormal];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lb.mas_centerY);
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
    }];
    [leftBtn addTarget:self action:@selector(backOperate) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.alpha = 0.6;
}

- (void)backOperate {
    [self routerWithEventName:@"rangeBack" userInfo:@{}];
}

- (void)configureDayViewSubviews:(UIView *)targetView {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_train_plan_day")];
    [targetView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(targetView.mas_centerX);
        make.top.mas_equalTo(targetView.mas_top).offset(15);
    }];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"计划天数", nil) font:10 bold:NO color:[ZCConfigColor point6TxtColor]];
    [targetView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(targetView.mas_centerX);
        make.top.mas_equalTo(targetView.mas_top).offset(50);
    }];
    
    self.dayL = [self createSimpleLabelWithTitle:@"" font:20 bold:YES color:[ZCConfigColor txtColor]];
    [targetView addSubview:self.dayL];
    [self.dayL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(targetView.mas_centerX);
        make.top.mas_equalTo(lb.mas_bottom).offset(5);
    }];
}

- (void)configureClassViewSubviews:(UIView *)targetView {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_train_plan_class")];
    [targetView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(targetView.mas_centerX);
        make.top.mas_equalTo(targetView.mas_top).offset(15);
    }];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"计划课程数", nil) font:10 bold:NO color:[ZCConfigColor point6TxtColor]];
    [targetView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(targetView.mas_centerX);
        make.top.mas_equalTo(targetView.mas_top).offset(50);
    }];
    
    self.classL = [self createSimpleLabelWithTitle:@"" font:20 bold:YES color:[ZCConfigColor txtColor]];
    [targetView addSubview:self.classL];
    [self.classL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(targetView.mas_centerX);
        make.top.mas_equalTo(lb.mas_bottom).offset(5);
    }];
}

- (void)configureBasicViewSubviews:(UIView *)targetView {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_train_plan_basic")];
    [targetView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(targetView.mas_centerX);
        make.top.mas_equalTo(targetView.mas_top).offset(15);
    }];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"训练难度", nil) font:10 bold:NO color:[ZCConfigColor point6TxtColor]];
    [targetView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(targetView.mas_centerX);
        make.top.mas_equalTo(targetView.mas_top).offset(50);
    }];
    
    self.basicL = [self createSimpleLabelWithTitle:@"" font:20 bold:YES color:[ZCConfigColor txtColor]];
    [targetView addSubview:self.basicL];
    [self.basicL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(targetView.mas_centerX);
        make.top.mas_equalTo(lb.mas_bottom).offset(5);
    }];
}

- (void)nextOperate {
    [self routerWithEventName:@"rangeNext" userInfo:@{}];
}

- (void)resetOperate {
    [self routerWithEventName:@"resetOperate" userInfo:@{}];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.dayL.text = checkSafeContent(dataDic[@"sustainedDays"]);
    self.classL.text = checkSafeContent(dataDic[@"courseCount"]);
    self.basicL.text = checkSafeContent(dataDic[@"difficulty"]);
}

@end

//
//  ZCHomeTrainPlanSexGuideView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/29.
//

#import "ZCHomeTrainPlanSexGuideView.h"

@interface ZCHomeTrainPlanSexGuideView ()

@property (nonatomic,strong) UIImageView *leftSelectIv;
@property (nonatomic,strong) UIImageView *rightSelectIv;

@property (nonatomic,strong) UIImageView *selectIv;

@property (nonatomic,strong) UIView *leftView;//勾选视图 - 女

@property (nonatomic,strong) UIView *rightView;//勾选视图 - 男

@end

@implementation ZCHomeTrainPlanSexGuideView

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
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"8、请选择你的性别", nil) font:14 bold:NO color:[ZCConfigColor point8TxtColor]];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(20));
    }];
    
    UIImageView *leftIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_train_women_nor")];
    [self addSubview:leftIv];
    [leftIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(53);
        make.centerX.mas_equalTo(self.mas_centerX).offset(AUTO_MARGIN(-70));
    }];
    leftIv.userInteractionEnabled = YES;
    leftIv.tag = 2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSexType:)];
    [leftIv addGestureRecognizer:tap];
    
    UIImageView *rightIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_train_man_nor")];
    [self addSubview:rightIv];
    [rightIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(leftIv.mas_top).offset(23);
        make.centerX.mas_equalTo(self.mas_centerX).offset(AUTO_MARGIN(70));
    }];
    rightIv.userInteractionEnabled = YES;
    rightIv.tag = 1;
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSexType:)];
    [rightIv addGestureRecognizer:rightTap];
    
    UIView *leftView = [[UIView alloc] init];
    [self addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(leftIv.mas_bottom);
        make.width.height.mas_equalTo(25);
        make.leading.mas_equalTo(leftIv.mas_trailing).offset(-16);
    }];
    leftView.userInteractionEnabled = NO;
    [leftView setViewCornerRadiu:12.5];
    [leftView setViewBorderWithColor:1 color:rgba(138, 205, 215, 0.99)];
    
    UIView *rightView = [[UIView alloc] init];
    rightView.userInteractionEnabled = NO;
    [self addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(rightIv.mas_bottom);
        make.width.height.mas_equalTo(25);
        make.leading.mas_equalTo(rightIv.mas_trailing).offset(-32);
    }];
    [rightView setViewCornerRadiu:12.5];
    [rightView setViewBorderWithColor:1 color:rgba(138, 205, 215, 0.99)];
    
    self.leftView = leftView;
    self.rightView = rightView;
 
    self.leftSelectIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_plan_train_finish")];
    [leftView addSubview:self.leftSelectIv];
    [self.leftSelectIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(23);
        make.centerX.mas_equalTo(leftView);
        make.centerY.mas_equalTo(leftView);
    }];
    self.leftSelectIv.hidden = YES;
    
    self.rightSelectIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_plan_train_finish")];
    [rightView addSubview:self.rightSelectIv];
    [self.rightSelectIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(23);
        make.centerX.mas_equalTo(rightView);
        make.centerY.mas_equalTo(rightView);
    }];
    self.rightSelectIv.hidden = YES;
    
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
    [self routerWithEventName:@"sexBack" userInfo:@{}];
}

- (void)selectSexType:(UITapGestureRecognizer *)tap {
    UIImageView *selectIv = (UIImageView *)tap.view;
    if (self.selectIv == selectIv) return;
    
    if (selectIv.tag == 1) {//男
        selectIv.image = kIMAGE(@"home_train_man_sel");
        self.selectIv.image = kIMAGE(@"home_train_women_nor");
        self.rightSelectIv.hidden = NO;
        self.leftSelectIv.hidden = YES;
        [self.rightView setViewBorderWithColor:1 color:[ZCConfigColor whiteColor]];
        [self.leftView setViewBorderWithColor:1 color:rgba(138, 205, 215, 0.99)];
    } else {
        selectIv.image = kIMAGE(@"home_train_women_sel");
        self.selectIv.image = kIMAGE(@"home_train_man_nor");
        self.rightSelectIv.hidden = YES;
        self.leftSelectIv.hidden = NO;
        [self.leftView setViewBorderWithColor:1 color:[ZCConfigColor whiteColor]];
        [self.rightView setViewBorderWithColor:1 color:rgba(138, 205, 215, 0.99)];
    }
    self.selectIv = selectIv;
    
    [self routerWithEventName:@"sexNext" userInfo:@{@"sex":@(selectIv.tag)}];
}

@end

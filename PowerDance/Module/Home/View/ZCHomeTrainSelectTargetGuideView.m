//
//  ZCHomeTrainSelectTargetGuideView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/29.
//

#import "ZCHomeTrainSelectTargetGuideView.h"

@interface ZCHomeTrainSelectTargetGuideView ()

@property (nonatomic,strong) UIView *selectView;

@end

@implementation ZCHomeTrainSelectTargetGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [ZCConfigColor whiteColor];
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_plan_guide_bg")];
    [self addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"1、请选择你的健身目标", nil) font:14 bold:NO color:[ZCConfigColor point8TxtColor]];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(20);
    }];
    
    UIView *reduceView = [[UIView alloc] init];
    [self addSubview:reduceView];
    [reduceView setViewCornerRadiu:5];
    reduceView.backgroundColor = [UIColor whiteColor];
    [reduceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.leading.mas_equalTo(AUTO_MARGIN(56));
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(titleL.mas_bottom).offset(30);
    }];
    [reduceView setViewBorderWithColor:1 color:rgba(138, 205, 215, 1)];
    reduceView.tag = 0;
    
    UIView *muscleView = [[UIView alloc] init];
    [self addSubview:muscleView];
    [muscleView setViewCornerRadiu:5];
    muscleView.backgroundColor = [UIColor whiteColor];
    [muscleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.leading.mas_equalTo(AUTO_MARGIN(56));
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(reduceView.mas_bottom).offset(10);
    }];
    [muscleView setViewBorderWithColor:1 color:rgba(138, 205, 215, 1)];
    muscleView.tag = 1;
    
    [self configureTargetView:reduceView];
    [self configureMuscleTargetView:muscleView];
}

- (void)configureTargetView:(UIView *)targetView {
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [targetView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_equalTo(targetView).inset(1);
    }];
    [bgView layoutIfNeeded];
    [bgView configureLeftToRightViewColorGradient:bgView width:SCREEN_W-AUTO_MARGIN(56)*2-AUTO_MARGIN(20)*2 height:43 one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:5];
    bgView.hidden = YES;
    
    UIButton *itemBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"减脂", nil) font:13 color:[ZCConfigColor txtColor]];
    [targetView addSubview:itemBtn];
    [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(targetView);
    }];
    itemBtn.userInteractionEnabled = NO;
    //home_train_muscle
    [itemBtn setImage:kIMAGE(@"home_train_reduce") forState:UIControlStateNormal];
    [itemBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleLeft space:5];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTargetType:)];
    [targetView addGestureRecognizer:tap];
    
}

- (void)configureMuscleTargetView:(UIView *)targetView {
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [targetView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_equalTo(targetView).inset(1);
        make.top.bottom.mas_equalTo(targetView).inset(1);
    }];
    [bgView layoutIfNeeded];
    [bgView configureLeftToRightViewColorGradient:bgView width:SCREEN_W-AUTO_MARGIN(56)*2-AUTO_MARGIN(20)*2 height:43 one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:5];
    bgView.hidden = YES;
    
    UIButton *itemBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"增肌", nil) font:13 color:[ZCConfigColor txtColor]];
    [targetView addSubview:itemBtn];
    [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(targetView);
    }];
    itemBtn.userInteractionEnabled = NO;
    [itemBtn setImage:kIMAGE(@"home_train_muscle") forState:UIControlStateNormal];
    [itemBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleLeft space:5];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTargetType:)];
    [targetView addGestureRecognizer:tap];
    
}

- (void)selectTargetType:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    if (self.selectView == view) return;
    [self setupTargetViewStatus:view status:YES];
    [self setupTargetViewStatus:self.selectView status:NO];
    self.selectView = view;
    [self routerWithEventName:@"target" userInfo:@{@"target":@(view.tag)}];
}

- (void)setupTargetViewStatus:(UIView *)view status:(BOOL)status {
    if (status) {
        for (UIView *item in view.subviews) {
            if ([item isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)item;
                [btn setTitleColor:[ZCConfigColor whiteColor] forState:UIControlStateNormal];
            }
            
            if ([item isKindOfClass:[UIImageView class]]) {
                item.hidden = NO;
            }
        }
        [view setViewBorderWithColor:1 color:[ZCConfigColor whiteColor]];
    } else {
        for (UIView *item in view.subviews) {
            if ([item isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)item;
                [btn setTitleColor:[ZCConfigColor txtColor] forState:UIControlStateNormal];
            }
            if ([item isKindOfClass:[UIImageView class]]) {
                item.hidden = YES;
            }
        }
        [view setViewBorderWithColor:1 color:rgba(138, 205, 215, 1)];
    }
}

@end

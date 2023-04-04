//
//  ZCHomeTrainPlanExperienceGuideView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/29.
//

#import "ZCHomeTrainPlanExperienceGuideView.h"

@interface ZCHomeTrainPlanExperienceGuideView ()

@property (nonatomic,strong) UIView *selectView;

@end

@implementation ZCHomeTrainPlanExperienceGuideView

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
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"3、你当前健身经验", nil) font:14 bold:NO color:[ZCConfigColor point8TxtColor]];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(20));
    }];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    [self addSubview:leftBtn];
    [leftBtn setImage:kIMAGE(@"home_guide_arrow_left") forState:UIControlStateNormal];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lb.mas_centerY);
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
    }];
    [leftBtn addTarget:self action:@selector(backOperate) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.alpha = 0.6;
    
    CGFloat height = 45;
    CGFloat marginY = 10;
    NSArray *titleArr = @[NSLocalizedString(@"每周运动≤1次", nil), NSLocalizedString(@"每周运动2~3次", nil), NSLocalizedString(@"每周运动≥4次", nil)];
    for (int i = 0; i < titleArr.count; i ++) {
        UIView *targetView = [[UIView alloc] init];
        [self addSubview:targetView];
        [targetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(lb.mas_bottom).offset(20+(height+marginY)*i);
            make.height.mas_equalTo(height);
            make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(56));
        }];
        targetView.backgroundColor = [ZCConfigColor whiteColor];
        [targetView setViewBorderWithColor:1 color:rgba(138, 205, 215, 1)];
        targetView.tag = i;
        [targetView setViewCornerRadiu:5];
        [self configureTargetView:targetView title:titleArr[i]];
    }
}


- (void)configureTargetView:(UIView *)targetView title:(NSString *)title {
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [targetView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_equalTo(targetView).inset(1);
    }];
    [bgView layoutIfNeeded];
    [bgView configureLeftToRightViewColorGradient:bgView width:SCREEN_W-AUTO_MARGIN(56)*2-AUTO_MARGIN(20)*2 height:43 one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:5];
    bgView.hidden = YES;
    
    UIButton *itemBtn = [self createSimpleButtonWithTitle:title font:13 color:[ZCConfigColor txtColor]];
    [targetView addSubview:itemBtn];
    [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(targetView);
    }];
    itemBtn.titleLabel.font = FONT_BOLD(13);
    itemBtn.userInteractionEnabled = NO;
    //home_train_muscle
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTargetType:)];
    [targetView addGestureRecognizer:tap];
    
}

- (void)selectTargetType:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    [self setupTargetViewStatus:view status:YES];
    [self setupTargetViewStatus:self.selectView status:NO];
    self.selectView = view;
    [self routerWithEventName:@"experienceTag" userInfo:@{@"experience":@(view.tag)}];
}

- (void)backOperate {
    [self routerWithEventName:@"experienceBack" userInfo:@{}];
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

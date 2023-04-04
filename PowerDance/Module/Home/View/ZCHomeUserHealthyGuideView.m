//
//  ZCHomeUserHealthyGuideView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/30.
//

#import "ZCHomeUserHealthyGuideView.h"

@interface ZCHomeUserHealthyGuideView ()

@property (nonatomic,strong) UILabel *bimL;
@property (nonatomic,strong) UILabel *cycleL;
@property (nonatomic,strong) UILabel *levelL;

@property (nonatomic,strong) UILabel *centerBimL;
@property (nonatomic,strong) UILabel *leftBimL;
@property (nonatomic,strong) UILabel *rightBimL;

@end

@implementation ZCHomeUserHealthyGuideView

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
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"您的健康指数", nil) font:14 bold:NO color:[ZCConfigColor point8TxtColor]];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(20));
    }];
    
    UIImageView *coverIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_guide_cover")];
    [self addSubview:coverIv];
    [coverIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.mas_equalTo(self);
        make.top.mas_equalTo(lb.mas_bottom).offset(20);
        make.height.mas_equalTo(109);
    }];
    coverIv.userInteractionEnabled = YES;
    
    UIButton *btn = [self createSimpleButtonWithTitle:NSLocalizedString(@"定制专属计划", nil) font:AUTO_MARGIN(14) color:[ZCConfigColor whiteColor]];
    [self addSubview:btn];
    btn.backgroundColor = [ZCConfigColor whiteColor];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(AUTO_MARGIN(182));
        make.height.mas_equalTo(36);
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(12));
        
    }];
    [btn addTarget:self action:@selector(nextOperate) forControlEvents:UIControlEventTouchUpInside];
    [btn configureLeftToRightViewColorGradient:btn width:AUTO_MARGIN(182) height:36 one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:18];
    
    UILabel *bimTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"身体质量指数(BIM)", nil) font:11 bold:NO color:[ZCConfigColor point6TxtColor]];
    [coverIv addSubview:bimTL];
    [bimTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(coverIv.mas_top).offset(10);
        make.leading.mas_equalTo(coverIv.mas_leading).offset(AUTO_MARGIN(40));
    }];
    
    UILabel *centerTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"锻炼", nil) font:11 bold:NO color:[ZCConfigColor point6TxtColor]];
    [coverIv addSubview:centerTL];
    [centerTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bimTL.mas_centerY);
        make.centerX.mas_equalTo(coverIv.mas_centerX);
    }];
    
    UILabel *sportTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"运动水平", nil) font:11 bold:NO color:[ZCConfigColor point6TxtColor]];
    [coverIv addSubview:sportTL];
    [sportTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bimTL.mas_centerY);
        make.trailing.mas_equalTo(coverIv.mas_trailing).inset(AUTO_MARGIN(40));
    }];
    
    self.bimL = [self createSimpleLabelWithTitle:@" " font:22 bold:YES color:[ZCConfigColor txtColor]];
    [coverIv addSubview:self.bimL];
    
    self.cycleL = [self createSimpleLabelWithTitle:@" " font:15 bold:YES color:[ZCConfigColor txtColor]];
    [coverIv addSubview:self.cycleL];
    
    self.levelL = [self createSimpleLabelWithTitle:@" " font:15 bold:YES color:[ZCConfigColor txtColor]];
    [coverIv addSubview:self.levelL];
    
    [self setupViewContrainsWithTopView:bimTL targetView:self.bimL];
    [self setupViewContrainsWithTopView:centerTL targetView:self.cycleL];
    [self setupViewContrainsWithTopView:sportTL targetView:self.levelL];
    
    [self setupLevelViewSubviews:coverIv];
    
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
    [self routerWithEventName:@"healthyBack" userInfo:@{}];
}
#pragma -- mark 创建等级视图
- (void)setupLevelViewSubviews:(UIView *)view {
    NSArray *titleArr = @[@{@"title":NSLocalizedString(@"偏瘦", nil), @"color":rgba(91, 175, 252, 1)},
                          @{@"title":NSLocalizedString(@"正常", nil), @"color":rgba(57, 215, 149, 1)},
                          @{@"title":NSLocalizedString(@"偏胖", nil), @"color":rgba(250, 181, 86, 1)},
                          @{@"title":NSLocalizedString(@"肥胖", nil), @"color":rgba(252, 95, 98, 1)}
    ];
    CGFloat marginX = 3;
    CGFloat width = (SCREEN_W - AUTO_MARGIN(20)*4 - 9)/4.0;
    for (int i = 0; i < titleArr.count; i ++) {
        NSDictionary *dic = titleArr[i];
        UILabel *titleL = [self createSimpleLabelWithTitle:dic[@"title"] font:10 bold:NO color:[ZCConfigColor point8TxtColor]];
        [view addSubview:titleL];
        titleL.textAlignment = NSTextAlignmentCenter;
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(view.mas_leading).offset(AUTO_MARGIN(20)+(width+marginX)*i);
            make.width.mas_equalTo(width);
            make.bottom.mas_equalTo(view.mas_bottom).inset(8);
        }];
        
        UIView *colorView = [[UIView alloc] init];
        [view addSubview:colorView];
        [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(titleL.mas_centerX);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(3);
            make.bottom.mas_equalTo(titleL.mas_top).inset(6);
        }];
        colorView.backgroundColor = dic[@"color"];
    }
    
    self.centerBimL = [self createSimpleLabelWithTitle:@"" font:9 bold:NO color:[ZCConfigColor subTxtColor]];
    [view addSubview:self.centerBimL];
    [self.centerBimL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.bottom.mas_equalTo(view.mas_bottom).inset(35);
    }];
    
    self.leftBimL = [self createSimpleLabelWithTitle:@"" font:9 bold:NO color:[ZCConfigColor subTxtColor]];
    [view addSubview:self.leftBimL];
    [self.leftBimL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.centerBimL.mas_leading).inset(width-15);
        make.centerY.mas_equalTo(self.centerBimL.mas_centerY);
    }];
    
    self.rightBimL = [self createSimpleLabelWithTitle:@"" font:9 bold:NO color:[ZCConfigColor subTxtColor]];
    [view addSubview:self.rightBimL];
    [self.rightBimL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.centerBimL.mas_trailing).offset(width-15);
        make.centerY.mas_equalTo(self.centerBimL.mas_centerY);
    }];
    
}

- (void)setupViewContrainsWithTopView:(UIView *)view targetView:(UIView *)targetView {
    [targetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.top.mas_equalTo(view.mas_bottom).offset(5);
        make.height.mas_equalTo(17);
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.bimL.text = checkSafeContent(dataDic[@"bmi"]);
    self.cycleL.text = checkSafeContent(dataDic[@"cycle"]);
    self.levelL.text = checkSafeContent(dataDic[@"level"]);
    NSDictionary *bmiStandard = dataDic[@"bmiStandard"];
    NSDictionary *center = bmiStandard[@"正常"];
    NSDictionary *left = bmiStandard[@"偏瘦"];
    NSDictionary *right = bmiStandard[@"肥胖"];
    self.centerBimL.text = checkSafeContent(center[@"max"]);
    self.rightBimL.text = checkSafeContent(right[@"max"]);
    self.leftBimL.text = checkSafeContent(left[@"max"]);
    
}

- (void)nextOperate {
    [self routerWithEventName:@"healthyNext" userInfo:@{}];
}

@end

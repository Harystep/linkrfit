//
//  ZCHomeTrainPlanAgeGuideView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/29.
//

#import "ZCHomeTrainPlanAgeGuideView.h"
#import "ZCHomePlanSelectTimePickView.h"

@interface ZCHomeTrainPlanAgeGuideView ()

@property (nonatomic,strong) ZCHomePlanSelectTimePickView *timeView;

@end

@implementation ZCHomeTrainPlanAgeGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}
//
- (void)createSubviews {
    
    self.backgroundColor = [ZCConfigColor whiteColor];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_plan_guide_bg")];
    [self addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"9、请选择你的年龄", nil) font:14 bold:NO color:[ZCConfigColor point8TxtColor]];
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
    
    UIButton *btn = [self createSimpleButtonWithTitle:NSLocalizedString(@"确定", nil) font:AUTO_MARGIN(14) color:[ZCConfigColor whiteColor]];
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
    
    ZCHomePlanSelectTimePickView *timeView = [[ZCHomePlanSelectTimePickView alloc] init];
    [coverIv addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(coverIv);
    }];
    self.timeView = timeView;
    
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
    [self routerWithEventName:@"ageBack" userInfo:@{}];
}

- (void)nextOperate {
    NSString *content = [NSString stringWithFormat:@"%@-%@-%@", self.timeView.valueStr, self.timeView.minuteStr, self.timeView.mouseStr];
    content = [content stringByReplacingOccurrencesOfString:@"年" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"月" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"日" withString:@""];
    [self routerWithEventName:@"ageNext" userInfo:@{@"age":content}];
}

@end

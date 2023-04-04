//
//  ZCSuitNextTrainView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/8/1.
//

#import "ZCSuitNextTrainView.h"

@interface ZCSuitNextTrainView ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UILabel *targetNumL;

@property (nonatomic,strong) UILabel *timeL;

@end

@implementation ZCSuitNextTrainView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.backgroundColor = [ZCConfigColor whiteColor];
    
    UIButton *maskBtn = [[UIButton alloc] init];
    [self addSubview:maskBtn];
    [maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.height.mas_equalTo(SCREEN_H);
    }];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"下一组训练", nil) font:AUTO_MARGIN(20) bold:NO color:[ZCConfigColor txtColor]];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(NAV_BAR_HEIGHT + AUTO_MARGIN(20)));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    self.iconIv = [[UIImageView alloc] init];
    [self addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGIN(25));
        make.height.width.mas_equalTo(AUTO_MARGIN(140));
    }];
    self.iconIv.contentMode = UIViewContentModeScaleAspectFit;
    self.iconIv.backgroundColor = [ZCConfigColor bgColor];
    [self.iconIv setViewCornerRadiu:AUTO_MARGIN(10)];
    
    self.nameL = [self createSimpleLabelWithTitle:@" " font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.iconIv.mas_centerX);
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.nameL.mas_bottom).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(100));
    }];
    [contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    contentView.backgroundColor = [ZCConfigColor bgColor];
    
    UILabel *targetTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"目标次数/个", nil) font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor txtColor]];
    [contentView addSubview:targetTL];
    [targetTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX).offset(-AUTO_MARGIN(20));
        make.top.mas_equalTo(contentView.mas_top).offset(AUTO_MARGIN(21));
    }];
    
    self.targetNumL = [self createSimpleLabelWithTitle:@"300" font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.targetNumL];
    [self.targetNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(targetTL.mas_trailing).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(contentView.mas_top).offset(AUTO_MARGIN(21));
    }];
    
    UILabel *timeTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"目标时长/分", nil) font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor txtColor]];
    [contentView addSubview:timeTL];
    [timeTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX).offset(-AUTO_MARGIN(20));
        make.bottom.mas_equalTo(contentView.mas_bottom).inset(AUTO_MARGIN(21));
    }];
    
    self.timeL = [self createSimpleLabelWithTitle:@"5" font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(timeTL.mas_trailing).offset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(contentView.mas_bottom).inset(AUTO_MARGIN(21));
    }];
   
    
    UILabel *alertL = [self createSimpleLabelWithTitle:NSLocalizedString(@"请更换设备，更换好之后，点击下方确定开始", nil) font:AUTO_MARGIN(12) bold:NO color:[ZCConfigColor txtColor]];
    [alertL setContentLineFeedStyle];
    [self addSubview:alertL];
    [alertL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(contentView.mas_bottom).offset(AUTO_MARGIN(40));
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
    }];
    alertL.textAlignment = NSTextAlignmentCenter;
    
    UIButton *confireBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"确定", nil) font:AUTO_MARGIN(14) color:[ZCConfigColor whiteColor]];
    [self addSubview:confireBtn];
    [confireBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(AUTO_MARGIN(50)));
        make.top.mas_equalTo(alertL.mas_bottom).offset(AUTO_MARGIN(20));
//        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [confireBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    [confireBtn addTarget:self action:@selector(comfireOperate) forControlEvents:UIControlEventTouchUpInside];
    confireBtn.backgroundColor = [ZCConfigColor txtColor];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.targetNumL.text = checkSafeContent(dataDic[@"num"]);
    self.timeL.text = checkSafeContent(dataDic[@"time"]);
    self.nameL.text = [ZCBluthDataTool convertSuitNameWithMode:checkSafeContent(dataDic[@"mode"])];
    self.iconIv.image = [self convertIconWithMode:checkSafeContent(dataDic[@"mode"])];
}

- (UIImage *)convertIconWithMode:(NSString *)mode {
    UIImage *image;
    if ([mode integerValue] == 1) {
        image = kIMAGE(@"family_suit_jfl");
    } else if ([mode integerValue] == 2) {
        image = kIMAGE(@"family_suit_jump");
    } else {
        image = kIMAGE(@"family_suit_llq");
    }
    return image;
}

- (void)comfireOperate {
    [self routerWithEventName:@"next" userInfo:@{}];
}

@end

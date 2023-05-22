//
//  ZCPowerStationAlertView.m
//  PowerDance
//
//  Created by oneStep on 2023/4/25.
//

#import "ZCPowerStationAlertView.h"
#import "FLAnimatedImageView+WebCache.h"

#define kTestFlag NO

@interface ZCPowerStationAlertView ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UITextField *contentF;

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UIView *baseView;//基本信息视图

@property (nonatomic,strong) FLAnimatedImageView *updateIv;//更新视图

@property (nonatomic,strong) UIButton *deleteBtn;

@property (nonatomic,strong) NSData *gifData;

@property (nonatomic,strong) UIView *faiView;//升级失败视图

@property (nonatomic,strong) UIButton *operateBtn;

@property (nonatomic,strong) UIView *updateSuccessView;

@end

@implementation ZCPowerStationAlertView

- (UIButton *)maskBtn {
    if (!_maskBtn) {
        _maskBtn = [[UIButton alloc] init];
        _maskBtn.backgroundColor = rgba(0, 0, 0, 0.4);
        _maskBtn.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    }
    return _maskBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    [self addSubview:self.maskBtn];
    
    UIView *contentView = [[UIView alloc] init];
    self.contentView = contentView;
    [self addSubview:contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(155);
        make.width.mas_equalTo(297);
        make.height.mas_equalTo(390);
    }];
    
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:kIMAGE(@"power_station_update_bg")];
    [contentView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentView);
    }];
    
    self.baseView = [[UIView alloc] init];
    [contentView addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(contentView);
        make.top.mas_equalTo(contentView.mas_top).offset(186);
    }];
    
    UILabel *alertL = [self createSimpleLabelWithTitle:NSLocalizedString(@"固件升级", nil) font:24 bold:YES color:[ZCConfigColor whiteColor]];
    [contentView addSubview:alertL];
    [alertL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView.mas_top).offset(92);
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(42);
    }];
    
    self.titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"你有新固件可升级", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self.baseView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.baseView.mas_top);
        make.centerX.mas_equalTo(self.baseView.mas_centerX);
    }];
    
    UIImageView *currentIv = [[UIImageView alloc] initWithImage:kIMAGE(@"power_station_current")];
    [self.baseView  addSubview:currentIv];
    [currentIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.baseView.mas_leading).offset(60);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(22);
    }];
    
    UIImageView *lasterIv = [[UIImageView alloc] initWithImage:kIMAGE(@"power_station_laster")];
    [self.baseView  addSubview:lasterIv];
    [lasterIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.baseView.mas_trailing).inset(60);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(22);
    }];
    
    UIImageView *centerIv = [[UIImageView alloc] initWithImage:kIMAGE(@"power_station_update_process")];
    [self.baseView  addSubview:centerIv];;
    [centerIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(currentIv.mas_centerY);
        make.centerX.mas_equalTo(self.baseView.mas_centerX);
    }];
    
    self.updateIv = [[FLAnimatedImageView alloc] init];
    [contentView addSubview:self.updateIv];
    [self.updateIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.bottom.mas_equalTo(contentView.mas_bottom).inset(62);
        make.height.mas_equalTo(135);
        make.width.mas_equalTo(133);
    }];
    self.updateIv.hidden = YES;
    if(kTestFlag) {
        UILabel *contentL = [self createSimpleLabelWithTitle:@"正在加载····" font:12 bold:NO color:[ZCConfigColor subTxtColor]];
        [self.updateIv addSubview:contentL];
        [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.updateIv.mas_centerX);
            make.centerY.mas_equalTo(self.updateIv.mas_centerY);
        }];
    }
    
    UIButton *sure = [self createSimpleButtonWithTitle:NSLocalizedString(@"立即升级", nil) font:14 color:[ZCConfigColor whiteColor]];
    [self.contentView  addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(40);
        make.width.mas_equalTo(182);
        make.height.mas_equalTo(42);
    }];
    [sure addTarget:self action:@selector(sureOperate) forControlEvents:UIControlEventTouchUpInside];
    [sure layoutIfNeeded];
    
    [sure configureLeftToRightViewColorGradient:sure width:182 height:42 one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:21];
    self.operateBtn = sure;
    
    self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setImage:kIMAGE(@"power_station_delete") forState:UIControlStateNormal];
    [self addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(contentView.mas_bottom);
    }];
    [self.deleteBtn addTarget:self action:@selector(deleteOperate) forControlEvents:UIControlEventTouchUpInside];
    
    if(kTestFlag) {
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"power_update" ofType:@"gif"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.gifData = [NSData dataWithContentsOfFile:path];
            FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:self.gifData];
            self.updateIv.animatedImage = image;
        });
    }
}

- (void)setFailFlag:(NSInteger)failFlag {
    [self createFailViewSubviews];
}

- (void)setSuccessFlag:(NSInteger)successFlag {
    [self createSuccessViewSubviews];
}

- (void)createSuccessViewSubviews {
    self.contentView.hidden = YES;
    self.deleteBtn.hidden = YES;
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(206);
        make.width.mas_equalTo(297);
        make.height.mas_equalTo(338);
    }];
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:kIMAGE(@"power_station_alert_bg")];
    [contentView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentView);
    }];
    
    UIImageView *statusIv = [[UIImageView alloc] initWithImage:kIMAGE(@"power_station_update_suc")];
    [contentView addSubview:statusIv];
    [statusIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.top.mas_equalTo(contentView.mas_top).offset(52);
    }];
    
    UIButton *sure = [self createSimpleButtonWithTitle:NSLocalizedString(@"返回设置", nil) font:14 color:[ZCConfigColor whiteColor]];
    [contentView  addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.bottom.mas_equalTo(contentView.mas_bottom).inset(52);
        make.width.mas_equalTo(182);
        make.height.mas_equalTo(42);
    }];
    [sure addTarget:self action:@selector(sureOperate) forControlEvents:UIControlEventTouchUpInside];
    [sure layoutIfNeeded];
    
    [sure configureLeftToRightViewColorGradient:sure width:182 height:42 one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:21];
    [sure addTarget:self action:@selector(hideAlertView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createFailViewSubviews {
    self.updateIv.hidden = YES;
    self.operateBtn.hidden = NO;
    self.faiView = [[UIView alloc] init];
    [self.contentView addSubview:self.faiView];
    [self.faiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.operateBtn.mas_top).inset(20);
        make.top.mas_equalTo(self.contentView.mas_top).offset(198);
    }];
    
    UIImageView *failIv = [[UIImageView alloc] initWithImage:kIMAGE(@"power_station_update_fail")];
    [self.faiView addSubview:failIv];
    [failIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.faiView.mas_centerX);
        make.top.mas_equalTo(self.faiView.mas_top);
    }];
     
    [self.operateBtn setTitle:@"重新更新" forState:UIControlStateNormal];
        
}

- (void)showAlertView {
    self.frame = UIScreen.mainScreen.bounds;
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.maskBtn.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideAlertView {
    self.maskBtn.hidden = YES;
    self.contentView.hidden = YES;
    [self removeFromSuperview];
}

- (void)sureOperate {
    self.updateIv.hidden = NO;
    self.baseView.hidden = YES;
    self.faiView.hidden = YES;
    self.operateBtn.hidden = YES;
    if(self.updateBlock) {
        self.updateBlock();
    }
}

- (void)deleteOperate {
    [self hideAlertView];
}

@end

//
//  ZCAutoTimerController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/17.
//

#import "ZCAutoTimerController.h"
#import "ZCCircleDialView.h"
#import "ZCSimpleTimeView.h"
#import "ZCAutoTimerAlertView.h"

@interface ZCAutoTimerController ()

@property (nonatomic,strong) ZCCircleDialView *dialView;

@property (nonatomic,strong) UIScrollView *scView;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) ZCAutoTimerAlertView *alertView;

@property (nonatomic,strong) UIButton *alertBtn;

@end

@implementation ZCAutoTimerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
    
    [ZCDataTool saveTimerTypeStatus:1];
    
    self.scView = [[UIScrollView alloc] init];
    self.scView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scView];
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom);
    }];
    
    self.contentView = [[UIView alloc] init];
    [self.scView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scView);
        make.width.mas_equalTo(self.scView);
    }];
    
    self.dialView = [[ZCCircleDialView alloc] init];    
    [self.contentView addSubview:self.dialView];
    [self.dialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(15));
        make.width.height.mas_equalTo(307);
    }];
    
    UILabel *timeL = [self.view createSimpleLabelWithTitle:@"00:00" font:36 bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.dialView.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    
    UIButton *alertBtn = [self.view createSimpleButtonWithTitle:self.params[@"data"] font:20 color:[ZCConfigColor txtColor]];
    self.alertBtn = alertBtn;
    [self.contentView addSubview:alertBtn];
    [alertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(timeL.mas_bottom).offset(AUTO_MARGIN(35));
    }];
    alertBtn.titleLabel.font = FONT_BOLD(20);
    [alertBtn setImage:kIMAGE(@"train_alert_icon") forState:UIControlStateNormal];
    [alertBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleRight space:2];
    [alertBtn addTarget:self action:@selector(alertBtnOperate) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = rgba(246, 246, 246, 1);
    [self.contentView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(alertBtn.mas_bottom).offset(AUTO_MARGIN(35));
        make.height.mas_equalTo(AUTO_MARGIN(95));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(110));
    }];
    [contentView setViewCornerRadiu:10];
    ZCSimpleTimeView *timeView = [[ZCSimpleTimeView alloc] init];
    [contentView addSubview:timeView];
    timeView.backgroundColor = rgba(246, 246, 246, 1);
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(contentView.mas_centerY);
    }];
    timeView.mode = [ZCBluthDataTool convertAutoModeToIndex:self.params[@"data"]];
    
    UIButton *startBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"开始", nil) font:14 color:[ZCConfigColor whiteColor]];
    [self.view addSubview:startBtn];
    startBtn.backgroundColor = [ZCConfigColor txtColor];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(50));
    }];
    [startBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    [startBtn addTarget:self action:@selector(startBtnOperate) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)startBtnOperate {
    [HCRouter router:@"AutoTimerTrain" params:self.params viewController:self animated:YES];
}

- (void)alertBtnOperate {
    [self.view addSubview:self.maskBtn];
    self.maskBtn.hidden = NO;
    self.maskBtn.alpha = 0.2;
    [self.view addSubview:self.alertView];
    self.alertView.hidden = NO;
    self.alertView.type = self.params[@"data"];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.alertBtn.mas_top);
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
    }];
}

- (void)maskBtnClick {
    self.maskBtn.hidden = YES;
    self.alertView.hidden = YES;
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = [NSString stringWithFormat:@"%@/%@", NSLocalizedString(@"在线计时器", nil), self.params[@"data"]];
    self.titlePostionStyle = UINavTitlePostionStyleRight;
}

- (ZCAutoTimerAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[ZCAutoTimerAlertView alloc] init];
    }
    return _alertView;
}

@end

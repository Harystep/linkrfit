//
//  ZCSmartCloudBaseController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/7/28.
//

#import "ZCSmartCloudBaseController.h"
#import "ZCCloudBaseView.h"

@interface ZCSmartCloudBaseController ()

@property (nonatomic,strong) ZCCloudBaseView *baseView;

@end

@implementation ZCSmartCloudBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZCCloudBaseView *baseView = [[ZCCloudBaseView alloc] init];
    [self.view addSubview:baseView];
    self.baseView = baseView;
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(NAV_BAR_HEIGHT - AUTO_MARGIN(20));
    }];
    
    [self configureBaseInfo];
    
    UIView *detailView = [[UIView alloc] init];
    [self.view addSubview:detailView];
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.baseView.mas_bottom).offset(AUTO_MARGIN(10));
        make.height.mas_equalTo(AUTO_MARGIN(320));
    }];
    [detailView setViewCornerRadiu:AUTO_MARGIN(10)];
    detailView.backgroundColor= rgba(255, 255, 255, 0.14);
    
    UILabel *descL = [self.view createSimpleLabelWithTitle:@"" font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor whiteColor]];
    [detailView addSubview:descL];
    [descL setContentLineFeedStyle];
    [descL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(detailView).inset(AUTO_MARGIN(20));
    }];
    NSString *desc = NSLocalizedString(@"填写信息浏览更多数据\n·数据对比\n·体重目标对比\n·体重目标对比\n·体脂率\n·肌肉量\n·更多9项身体数据", nil);
    [descL setAttributeStringContent:desc space:15 font:FONT_SYSTEM(AUTO_MARGIN(14)) alignment:NSTextAlignmentLeft];
    
    UIButton *confireBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"去填写", nil) font:AUTO_MARGIN(14) color:[ZCConfigColor txtColor]];
    [detailView addSubview:confireBtn];
    [confireBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(detailView).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(44));
        make.bottom.mas_equalTo(detailView.mas_bottom).inset(AUTO_MARGIN(25));
    }];
    confireBtn.backgroundColor = [ZCConfigColor whiteColor];
    [confireBtn setViewCornerRadiu:AUTO_MARGIN(22)];
    [confireBtn addTarget:self action:@selector(comfireOperate) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)comfireOperate {
    [HCRouter router:@"FillUserInfoStep1" params:@{} viewController:self animated:YES];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = @"";
    self.backStyle = UINavBackButtonColorStyleWhite;
    self.view.backgroundColor = rgba(43, 42, 51, 1);
}

@end

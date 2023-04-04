//
//  ZCOrderSuccessController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/15.
//

#import "ZCOrderSuccessController.h"

@interface ZCOrderSuccessController ()

@end

@implementation ZCOrderSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBaseInfo];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"order_pay_suc")];
    [self.view addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(60));
    }];
    UILabel *signL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"支付成功！", nil) font:20 bold:YES color:[ZCConfigColor txtColor]];
    [self.view addSubview:signL];
    [signL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(iconIv.mas_centerX);
        make.top.mas_equalTo(iconIv.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    
    UILabel *subL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"我们将尽快安排发货，请收货人保持手机畅通，以便快递哥哥能第一时间联系到您", nil) font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    [subL setContentLineFeedStyle];
    subL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:subL];
    [subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(40));
        make.top.mas_equalTo(signL.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    
    UIButton *orderBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"查看订单", nil) font:14 color:[ZCConfigColor whiteColor]];
    orderBtn.backgroundColor = [ZCConfigColor txtColor];
    [self.view addSubview:orderBtn];
    orderBtn.tag = 0;
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(subL.mas_bottom).offset(AUTO_MARGIN(30));
        make.width.mas_equalTo(AUTO_MARGIN(150));
        make.height.mas_equalTo(AUTO_MARGIN(50));
    }];
    [orderBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    [orderBtn addTarget:self action:@selector(operateBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *backBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"返回首页", nil) font:14 color:[ZCConfigColor txtColor]];
    backBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:backBtn];
    backBtn.tag = 1;
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(orderBtn.mas_bottom).offset(AUTO_MARGIN(15));
        make.width.mas_equalTo(AUTO_MARGIN(150));
        make.height.mas_equalTo(AUTO_MARGIN(50));
    }];
    [backBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    [backBtn addTarget:self action:@selector(operateBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backOperate {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)operateBtn:(UIButton *)sender {
    if (sender.tag) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
        [HCRouter router:@"MyOrderList" params:@{@"type":@"1"} viewController:self animated:YES];
    }
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"支付信息", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleBack;
    self.view.backgroundColor = rgba(246, 246, 246, 1);
}

@end

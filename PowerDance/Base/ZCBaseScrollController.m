//
//  ZCBaseScrollController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/15.
//

#import "ZCBaseScrollController.h"

@interface ZCBaseScrollController ()

@end

@implementation ZCBaseScrollController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
}

- (void)setupSubViews {
    self.scView = [[UIScrollView alloc] init];
    self.scView.showsVerticalScrollIndicator = NO;
    self.scView.bounces = NO;
    [self.view addSubview:self.scView];
    if (@available(iOS 11.0, *)) {
        self.scView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets      = NO;
    }
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    self.contentView = [[UIView alloc] init];
    [self.scView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scView);
        make.width.mas_equalTo(self.scView);
    }];
}
- (void)setShowNavStatus:(BOOL)showNavStatus {
    if (showNavStatus) {
        [self.view addSubview:self.naviView];
        [self.scView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.view);
            make.top.mas_equalTo(self.naviView.mas_bottom);
            make.bottom.mas_equalTo(self.view);
        }];
    }
}
- (void)backOperate {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

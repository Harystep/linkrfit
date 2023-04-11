//
//  ZCPowerPlatformController.m
//  PowerDance
//
//  Created by oneStep on 2023/4/11.
//

#import "ZCPowerPlatformController.h"
#import "ZCPowerPlatformTypeView.h"

@interface ZCPowerPlatformController ()

@property (nonatomic,strong) ZCPowerPlatformTypeView *topView;

@end

@implementation ZCPowerPlatformController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    self.showNavStatus = YES;
    self.navBgIcon.hidden = NO;
    self.titleStr = NSLocalizedString(@"力量台", nil);
    self.titlePostionStyle = UINavTitlePostionStyleCenter;
    self.backStyle = UINavBackButtonColorStyleBack;
    
    self.topView = [[ZCPowerPlatformTypeView alloc] init];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(5);
    }];
    
}


@end

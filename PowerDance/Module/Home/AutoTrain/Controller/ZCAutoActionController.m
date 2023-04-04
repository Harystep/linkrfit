//
//  ZCAutoActionController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/24.
//

#import "ZCAutoActionController.h"

@interface ZCAutoActionController ()

@end

@implementation ZCAutoActionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"动作库", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleBack;
    
}

@end

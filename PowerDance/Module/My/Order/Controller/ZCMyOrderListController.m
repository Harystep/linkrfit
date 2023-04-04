//
//  ZCMyOrderListController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/9.
//

#import "ZCMyOrderListController.h"
#import "ZCShopOrderExenView.h"

@interface ZCMyOrderListController ()

@end

@implementation ZCMyOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    [self configureBaseInfo];
    [self configureCategoryInfo];
    [self setupSubViews];
}

- (void)setupSubViews {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.categoryView.titles];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZCShopOrderExenView *billView = [[ZCShopOrderExenView alloc] init];
        if (@available(iOS 11.0, *)) {
            billView.frame = CGRectMake(SCREEN_W * idx, 44, SCREEN_W, CGRectGetHeight(self.scrollView.frame) - 49 - STATUS_H);
        } else {
            billView.frame = CGRectMake(SCREEN_W * idx, 44, SCREEN_W, CGRectGetHeight(self.scrollView.frame));
        }
        billView.type = idx;
        [self.scrollView addSubview:billView];
        
    }];
    self.pageIndex = 0;
    self.categoryView.defaultSelectedIndex = 0;
}

- (void)configureCategoryInfo {
    self.categoryView.frame = CGRectMake(0, NAV_BAR_HEIGHT, AUTO_MARGIN(160), 44);
    self.categoryView.titles = @[NSLocalizedString(@"待收货", nil), NSLocalizedString(@"已完成", nil)];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"我的订单", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleBack;
}

- (void)backOperate {
    if ([self.params[@"type"] integerValue] == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

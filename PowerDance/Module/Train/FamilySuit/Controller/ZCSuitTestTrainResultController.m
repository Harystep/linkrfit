//
//  ZCSuitTestTrainResultController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/8/2.
//

#import "ZCSuitTestTrainResultController.h"
#import "ZCSuitTestResultItemCell.h"

@interface ZCSuitTestTrainResultController ()

@property (nonatomic,strong) UIImage *bgImage;

@property (nonatomic,strong) UILabel *scoreL;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ZCSuitTestTrainResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:self.bgImage];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(self.view);
    }];
    
    UIView *testView = [[UIView alloc] init];
    [self.view addSubview:testView];
    [testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(AUTO_MARGIN(30)+NAV_BAR_HEIGHT);
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(200));
    }];
    testView.backgroundColor = [ZCConfigColor whiteColor];
    [testView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    [self configureBaseInfo];
    
    bgView.image = self.bgImage;
    
    [self createTestViewSubviews:testView];
    
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(testView.mas_bottom).offset(AUTO_MARGIN(15));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(100));
    }];
    bottomView.backgroundColor = [ZCConfigColor whiteColor];
    [bottomView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    [self createBottomViewSubviews:bottomView];
    
    UIButton *confireBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"返回", nil) font:AUTO_MARGIN(14) color:[ZCConfigColor whiteColor]];
    [self.view addSubview:confireBtn];
    [confireBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(25));
    }];
    [confireBtn addTarget:self action:@selector(comfireOperate) forControlEvents:UIControlEventTouchUpInside];
    confireBtn.backgroundColor = [ZCConfigColor txtColor];
    [confireBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    
}

- (void)comfireOperate {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCSuitTestResultItemCell *cell = [ZCSuitTestResultItemCell suitTestItemCellWithTableView:tableView idnexPath:indexPath];
    return cell;
}

#pragma -- mark 配置底部视图
- (void)createBottomViewSubviews:(UIView *)bottomView {
    
    UILabel *titleL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"测试历史", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [bottomView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomView.mas_top);
        make.height.mas_equalTo(AUTO_MARGIN(40));
        make.leading.mas_equalTo(bottomView.mas_leading).offset(AUTO_MARGIN(20));
    }];
    
    [bottomView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(bottomView);
        make.top.mas_equalTo(titleL.mas_bottom);
    }];
}

#pragma -- mark 添加测试视图
- (void)createTestViewSubviews:(UIView *)testView {
    self.scoreL = [self.view createSimpleLabelWithTitle:@"96分" font:AUTO_MARGIN(40) bold:YES color:rgba(250, 100, 0, 1)];
    [testView addSubview:self.scoreL];
    [self.scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(testView.mas_centerX);
        make.top.mas_equalTo(testView.mas_top).offset(AUTO_MARGIN(63));
        make.height.mas_equalTo(AUTO_MARGIN(40));
    }];
    
    UILabel *titleL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"测试指数", nil) font:AUTO_MARGIN(20) bold:NO color:[ZCConfigColor txtColor]];
    [testView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scoreL.mas_centerX);
        make.top.mas_equalTo(self.scoreL.mas_bottom).offset(AUTO_MARGIN(10));
    }];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    NSDictionary *dataDic = self.params[@"data"];
    self.titleStr = [NSString stringWithFormat:@"%@%@", dataDic[@"title"], NSLocalizedString(@"测试", nil)];
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.bgImage = [self convertImageWithTitle:dataDic[@"title"]];
    self.backStyle = UINavBackButtonColorStyleWhite;
    self.view.backgroundColor = [ZCConfigColor bgColor];
}

- (UIImage *)convertImageWithTitle:(NSString *)title {
    UIImage *image;
    if ([title isEqualToString:NSLocalizedString(@"耐力", nil)]) {
        image = kIMAGE(@"suit_test_endurance");
    } else if ([title isEqualToString:NSLocalizedString(@"心肺", nil)]) {
        image = kIMAGE(@"suit_test_lungs");
    } else {
        image = kIMAGE(@"suit_test_power");
    }
    return image;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[ZCSuitTestResultItemCell class] forCellReuseIdentifier:@"ZCSuitTestResultItemCell"];
        
    }
    return _tableView;
}

@end

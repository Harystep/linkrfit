//
//  ZCSuitTrainFinishController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/8/1.
//

#import "ZCSuitTrainFinishController.h"
#import "ZCSuitTrainResultCell.h"
#import "ZCSuitFtrainFinishTopView.h"

@interface ZCSuitTrainFinishController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSDictionary *baseDic;

@property (nonatomic,strong) ZCSuitFtrainFinishTopView *topView;

@end

@implementation ZCSuitTrainFinishController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBaseInfo];
    
    ZCSuitFtrainFinishTopView *contentView = [[ZCSuitFtrainFinishTopView alloc] init];
    [self.view addSubview:contentView];
    self.topView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom);
    }];
    [contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    contentView.dataDic = self.baseDic;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(contentView.mas_bottom);
    }];
        
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCSuitTrainResultCell *cell = [ZCSuitTrainResultCell suitTrainResultCellWithTableView:tableView idnexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"训练结束", nil);
    self.backStyle = UINavBackButtonColorStyleBack;
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.view.backgroundColor = [ZCConfigColor bgColor];
    self.dataArr = self.params[@"data"];
    NSMutableArray *rateArr = self.params[@"rate"];
    NSInteger avg = [[rateArr valueForKeyPath:@"@avg.floatValue"] intValue];
    NSInteger max =[[rateArr valueForKeyPath:@"@max.floatValue"] intValue];
    NSInteger min =[[rateArr valueForKeyPath:@"@min.floatValue"] intValue];
    self.baseDic = @{@"avg":[NSString stringWithFormat:@"%tu", avg],
                     @"max":[NSString stringWithFormat:@"%tu", max],
                     @"min":[NSString stringWithFormat:@"%tu", min]
    };
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [ZCConfigColor bgColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        [_tableView registerClass:[ZCSuitTrainResultCell class] forCellReuseIdentifier:@"ZCSuitTrainResultCell"];
        
    }
    return _tableView;
}

- (void)backOperate {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

//
//  ZCShopCommentController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/15.
//

#import "ZCShopCommentController.h"
#import "ZCShopCommentCell.h"
#import "ZCGoodScoreView.h"
#import "ZCStarRateView.h"

@interface ZCShopCommentController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ZCShopCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(15));
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(15));
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
        
    self.tableView.tableHeaderView = [self createHeaderView];
    
    [self getGoodsCommentListInfo];
}

- (UIView *)createHeaderView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 60)];
    UIView *contentView = [[UIView alloc] init];
    [headView addSubview:contentView];
    contentView.backgroundColor = [ZCConfigColor whiteColor];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(headView);
        make.top.mas_equalTo(headView.mas_top);
        make.height.mas_equalTo(60);
    }];
    
    UILabel *lb = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"整体评价:", nil) font:15 bold:NO color:[ZCConfigColor txtColor]];
    [contentView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentView.mas_centerY);
//        make.top.mas_equalTo(contentView.mas_top).offset(AUTO_MARGIN(10));
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(20));
    }];
    
    ZCStarRateView *rateView = [[ZCStarRateView alloc] initWithFrame:CGRectMake(AUTO_MARGIN(80), 30, AUTO_MARGIN(80), AUTO_MARGIN(15))];
    rateView.rateStyle = HalfStar;
    rateView.isAnimation = YES;
    rateView.currentScore = [[ZCDataTool reviseString:self.params[@"scope"]] doubleValue];
    rateView.userInteractionEnabled = NO;
    [contentView addSubview:rateView];
    [rateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lb.mas_centerY);
        make.width.mas_equalTo(AUTO_MARGIN(80));
        make.height.mas_equalTo(AUTO_MARGIN(15));
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(AUTO_MARGIN(12));
    }];
    
    NSString *scoreStr = [ZCDataTool reviseString:self.params[@"scope"]];
    UILabel *scoreL = [self.view createSimpleLabelWithTitle:[NSString stringWithFormat:@"%.1f", [scoreStr doubleValue]] font:30 bold:YES color:rgba(255, 138, 59, 1)];
    [headView addSubview:scoreL];
    [scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(lb.mas_trailing).offset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(contentView.mas_centerY);
    }];
    
    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCShopCommentCell *cell = [ZCShopCommentCell shopCommentCellWithTableView:tableView idnexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)getGoodsCommentListInfo {
    [ZCShopManage queryGoodsCommentListInfo:@{@"productId":checkSafeContent(self.params[@"productId"])} completeHandler:^(id  _Nonnull responseObj) {
        self.dataArr = responseObj[@"data"][@"records"];
        [self.tableView reloadData];
    }];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"最新评论", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleBack;
    self.view.backgroundColor = rgba(246, 246, 246, 1);
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 100.f;
        _tableView.backgroundColor = rgba(246, 246, 246, 1);
        [_tableView registerClass:[ZCShopCommentCell class] forCellReuseIdentifier:@"ZCShopCommentCell"];
        
    }
    return _tableView;
}

@end

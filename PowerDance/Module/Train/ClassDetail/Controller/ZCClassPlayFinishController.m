//
//  ZCClassPlayFinishController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/6.
//

#import "ZCClassPlayFinishController.h"
#import "ZCClassPlayFinishTopView.h"
#import "ZCRecommendClassCell.h"

@interface ZCClassPlayFinishController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) ZCClassPlayFinishTopView *topView;

@property (nonatomic,strong) NSArray *recommendArr;

@end

@implementation ZCClassPlayFinishController

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
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom);
        make.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(70));
    }];
    
    ZCClassPlayFinishTopView *topView = [[ZCClassPlayFinishTopView alloc] init];
    self.topView = topView;
    CGFloat height = [topView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = CGRectMake(0, 0, SCREEN_W, height);
    frame.size.height = height;
    topView.frame = frame;
    [self.tableView beginUpdates];
    self.tableView.tableHeaderView = topView;
    [self.tableView endUpdates];
    NSDictionary *parmDic = self.params[@"data"];
    topView.dataDic = self.params[@"data"];
    
    UIButton *exit = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"退出", nil) font:15 color:[ZCConfigColor whiteColor]];
    exit.backgroundColor = [ZCConfigColor txtColor];
    [exit setViewCornerRadiu:AUTO_MARGIN(25)];
    [self.view addSubview:exit];
    [exit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(50));
    }];
    [exit addTarget:self action:@selector(exitOperate) forControlEvents:UIControlEventTouchUpInside];
    
    [self queryRecommentListInfo];
    NSDictionary *dic = kUserStore.userData;
    if (dic == nil) {
        [self getUserInfo];
    } else {
        self.topView.userDic = dic;
    }
    if (parmDic[@"planId"] != nil) {
        [self finishTrainClassOperate];
    }
}

- (void)finishTrainClassOperate {
    NSDictionary *parmDic = self.params[@"data"];
    [ZCTrainManage finishTrainPlanClassOperateURL:@{@"userPlanId":checkSafeContent(parmDic[@"planId"])} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"finish:%@", responseObj);
    }];
}

- (void)getUserInfo {
    [ZCProfileManage getUserBaseInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        kUserStore.userData = responseObj[@"data"];
        self.topView.userDic = responseObj[@"data"];
    }];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"训练完成", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.view.backgroundColor = rgba(246, 246, 246, 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCRecommendClassCell *cell = [ZCRecommendClassCell recommendClassCellWithTableView:tableView idnexPath:indexPath];
    cell.backgroundColor = rgba(246, 246, 246, 1);
    cell.dataDic = self.recommendArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.recommendArr[indexPath.row];
    [HCRouter router:@"ClassDetail" params:dic viewController:self animated:YES];
}

- (void)queryRecommentListInfo {
    [ZCClassSportManage classRecommendListInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"recomment:%@", responseObj);
        NSArray *listArr = [ZCDataTool convertEffectiveData:responseObj[@"data"]];
        if (listArr.count > 0) {
            self.recommendArr = listArr;
            [self.tableView reloadData];
        }
    }];
}

- (void)backOperate {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)exitOperate {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = rgba(246, 246, 246, 1);
        [_tableView registerClass:[ZCRecommendClassCell class] forCellReuseIdentifier:@"ZCRecommendClassCell"];
        
    }
    return _tableView;
}

@end

//
//  ZCAutoWRCMiddleController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/21.
//

#import "ZCAutoWRCMiddleController.h"
#import "ZCAutoWRCModelSimpleCell.h"
#import "ZCAutoWRCMiddleTopView.h"

@interface ZCAutoWRCMiddleController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) ZCAutoWRCMiddleTopView *topView;

@end

@implementation ZCAutoWRCMiddleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(90));
    }];
    self.topView = [[ZCAutoWRCMiddleTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 450)];
    self.tableView.tableHeaderView = self.topView;
    self.topView.roundL.text = checkSafeContent(self.params[@"circle"]);
    
    [self setupBottomOperateView];
    
    NSInteger totalMouse = 0;
    for (int i = 0; i < self.dataArr.count; i ++) {
        NSDictionary *dic = self.dataArr[i];
        totalMouse += ([[ZCDataTool convertStringTimeToMouse:dic[@"time"]] integerValue] * [self.params[@"circle"] integerValue]);
        if ([[ZCDataTool convertStringTimeToMouse:dic[@"rest"]] integerValue] > 0) {
            totalMouse += ([[ZCDataTool convertStringTimeToMouse:dic[@"rest"]] integerValue] * [self.params[@"circle"] integerValue]);
        }
    }
    self.topView.timeL.text = [ZCDataTool convertMouseToMSTimeString:totalMouse];
}

- (void)configureBaseInfo {
    self.view.backgroundColor = [ZCConfigColor whiteColor];
    self.showNavStatus = YES;
    self.titleStr = [NSString stringWithFormat:@"%@/WRC", NSLocalizedString(@"在线计时器", nil)];
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleBack;
    NSArray *dataArr = self.params[@"data"];
    NSMutableArray *temArr = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i ++) {
        NSDictionary *dic = dataArr[i];
        if ([[ZCDataTool convertStringTimeToMouse:dic[@"time"]] integerValue] > 0) {
            [temArr addObject:dic];
        }
    }
    self.dataArr = temArr;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCAutoWRCModelSimpleCell *cell = [ZCAutoWRCModelSimpleCell wrcModelCellWithTableView:tableView idnexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];    
    return cell;
}

- (void)saveOperate {
    [HCRouter router:@"AutoWRCSportTrain" params:@{@"data":self.dataArr, @"circle":self.params[@"circle"]} viewController:self animated:YES];
}

- (void)setupBottomOperateView {
            
    ZCSimpleButton *sureBtn = [self.view createShadowButtonWithTitle:NSLocalizedString(@"确定", nil) font:15 color:[ZCConfigColor whiteColor]];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    sureBtn.backgroundColor = [ZCConfigColor txtColor];
    [sureBtn addTarget:self action:@selector(saveOperate) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setViewCornerRadiu:AUTO_MARGIN(25)];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.estimatedRowHeight = 100.0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        [_tableView registerClass:[ZCAutoWRCModelSimpleCell class] forCellReuseIdentifier:@"ZCAutoWRCModelSimpleCell"];
        
    }
    return _tableView;
}


@end

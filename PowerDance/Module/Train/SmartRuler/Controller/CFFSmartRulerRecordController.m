//
//  CFFSmartRulerRecordController.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/14.
//

#import "CFFSmartRulerRecordController.h"
#import "CFFSmartManager.h"
#import "CFFSmartRulerRecordModel.h"
#import "CFFSmartRulerRecordCell.h"

@interface CFFSmartRulerRecordController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation CFFSmartRulerRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.needNavBar = YES;
    self.backButtonStyle = CFFBackButtonStyleBlack;
    self.title = NSLocalizedString(@"数据记录", nil);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.customNavBar.mas_bottom);
    }];
    
    [self getRulerRecordInfoList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CFFSmartRulerRecordCell *cell = [CFFSmartRulerRecordCell smartRulerRecordCellWithTableView:tableView idnexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CFFSmartRulerRecordModel *model = self.dataArr[indexPath.row];
    [HCRouter router:@"SmartRulerRecordDetail" params:@{@"data":model, @"all":self.dataArr} viewController:self animated:YES];
}

- (void)getRulerRecordInfoList {
    [CFFSmartManager queryRulerRecordInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        self.dataArr = [CFFSmartRulerRecordModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
        if (self.dataArr.count == 0) {
            self.noneView.hidden = NO;
        }
        [self.tableView reloadData];
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = UIColor.groupTableViewBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[CFFSmartRulerRecordCell class] forCellReuseIdentifier:@"CFFSmartRulerRecordCell"];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end

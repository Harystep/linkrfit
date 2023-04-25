//
//  ZCPowerPlatformSetController.m
//  PowerDance
//
//  Created by oneStep on 2023/4/25.
//

#import "ZCPowerPlatformSetController.h"
#import "ZCMoreSetSimpleCell.h"
#import "ZCUpdateVersionView.h"
#import "ZCPowerStationAlertView.h"
#import "ZCPowerStationSetLanguageView.h"
#import "ZCPowerStationSetUnitView.h"
#import "ZCPowerStationVoiceView.h"
#import "ZCPowerStationAboutView.h"

@interface ZCPowerPlatformSetController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ZCPowerPlatformSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    [self configureNavi];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(10);
    }];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(60))];
    self.tableView.tableFooterView = footerView;
    footerView.backgroundColor = rgba(246, 246, 246, 1);
    [self setupFooterSubViews:footerView];
     
}

- (void)configureAlertView:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *conform = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [ZCDataTool loginOut];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
    [alert addAction:conform];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma -- mark 设置底部视图
- (void)setupFooterSubViews:(UIView *)footerView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [ZCConfigColor whiteColor];
    [footerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(footerView);
        make.bottom.mas_equalTo(footerView);
        make.top.mas_equalTo(footerView.mas_top).offset(AUTO_MARGIN(10));
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutOperate)];
    [view addGestureRecognizer:tap];
    
    UILabel *titleL = [footerView createSimpleLabelWithTitle:NSLocalizedString(@"关于本机", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.leading.mas_equalTo(view).offset(AUTO_MARGIN(15));
    }];
    
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:kIMAGE(@"profile_simple_arrow")];
    [view addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(view.mas_trailing).inset(AUTO_MARGIN(15));
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCMoreSetSimpleCell *cell = [ZCMoreSetSimpleCell moreSetSimpleCellWithTableView:tableView idnexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self updateOperate];
            break;
            
        case 1:
            [self voiceOperate];
            break;
            
        case 2:
            [self languageOperate];
            break;
            
        case 3:
            [self unitOperate];
            break;
            
        default:
            break;
    }
}

- (void)updateOperate {
    ZCPowerStationAlertView *alertView = [[ZCPowerStationAlertView alloc] init];
    [alertView showAlertView];
}

- (void)unitOperate {
    ZCPowerStationSetUnitView *alertView = [[ZCPowerStationSetUnitView alloc] init];
    [alertView showAlertView];
}

- (void)languageOperate {
    ZCPowerStationSetLanguageView *alertView = [[ZCPowerStationSetLanguageView alloc] init];
    [alertView showAlertView];
}

- (void)aboutOperate {
    ZCPowerStationAboutView *alertView = [[ZCPowerStationAboutView alloc] init];
    [alertView showAlertView];
}

- (void)voiceOperate {
    ZCPowerStationVoiceView *alertView = [[ZCPowerStationVoiceView alloc] init];
    [alertView showAlertView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = rgba(246, 246, 246, 1);
        [_tableView registerClass:[ZCMoreSetSimpleCell class] forCellReuseIdentifier:@"ZCMoreSetSimpleCell"];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {                
        _dataArr = [NSMutableArray arrayWithArray:@[
            @{@"title":NSLocalizedString(@"固件升级", nil), @"content":@""},
            @{@"title":NSLocalizedString(@"设置音量", nil), @"content":@""},
            @{@"title":NSLocalizedString(@"设置语言", nil), @"content":@""},
            @{@"title":NSLocalizedString(@"设置单位", nil), @"content":@""},
        ]];
    }
    return _dataArr;
}

- (void)configureNavi {
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    self.showNavStatus = YES;
    self.navBgIcon.hidden = NO;
    self.titleStr = NSLocalizedString(@"设置", nil);
    self.titlePostionStyle = UINavTitlePostionStyleCenter;
    self.backStyle = UINavBackButtonColorStyleBack;
}

@end

//
//  ZCMoreSetController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/9.
//

#import "ZCMoreSetController.h"
#import "ZCMoreSetSimpleCell.h"
#import "ZCUpdateVersionView.h"

@interface ZCMoreSetController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ZCMoreSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"更多设置", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleBack;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(60))];
    self.tableView.tableFooterView = footerView;
    footerView.backgroundColor = rgba(246, 246, 246, 1);
    [self setupFooterSubViews:footerView];
 
    UIButton *exitBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"退出登录", nil) font:AUTO_MARGIN(14) color:[UIColor redColor]];
    [self.view addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(44));
    }];
    [exitBtn setViewCornerRadiu:AUTO_MARGIN(22)];
    [exitBtn setViewBorderWithColor:1 color:[UIColor redColor]];
    [exitBtn addTarget:self action:@selector(exitOperate) forControlEvents:UIControlEventTouchUpInside];
}
#pragma -- mark 退出登录
- (void)exitOperate {
    
    [self configureAlertView:NSLocalizedString(@"确定要退出登录吗？", nil)];
}
#pragma -- mark 注销账号
- (void)logout {
    [self configureAlertView:NSLocalizedString(@"确定要注销该账号吗？\n(确定后，账号将在3～5个工作日处理)", nil)];
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
        make.leading.trailing.mas_equalTo(footerView).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(footerView);
        make.top.mas_equalTo(footerView.mas_top).offset(AUTO_MARGIN(10));
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logout)];
    [view addGestureRecognizer:tap];
    
    UILabel *titleL = [footerView createSimpleLabelWithTitle:NSLocalizedString(@"注销账号", nil) font:14 bold:NO color:rgba(246, 48, 93, 1)];
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
            [HCRouter router:@"ProcotolDetail" params:@{@"data":k_User_Agreement_URL} viewController:self animated:YES];
            break;
            
        case 1:
            [HCRouter router:@"ProcotolDetail" params:@{@"data":k_User_PRIVACY_URL} viewController:self animated:YES];
            break;
            
        case 2:
            [self jumpAppStore];
            break;
            
        case 3:
            [self getAppVersionInfo];
            break;
            
        default:
            break;
    }
}

- (void)getAppVersionInfo {
    [ZCProfileManage checkAppVersionInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSArray *dataArr = responseObj[@"data"];
        if (dataArr.count > 0) {
            NSDictionary *contentDic = dataArr[0];
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            //CFBundleVersion
            NSInteger app_version = [[infoDic objectForKey:@"CFBundleVersion"] integerValue];
            NSInteger curVersions = [contentDic[@"version"] integerValue];
            if (app_version >= curVersions) {
                [self.view makeToast:NSLocalizedString(@"已是最新版本", nil) duration:2.0 position:CSToastPositionCenter];
            } else { // 跳转到appstore
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ZCDataTool getVersionInfo]];
                if(app_version < curVersions) {
                    NSLog(@"跳转到appstore");
                    ZCUpdateVersionView *alert = [[ZCUpdateVersionView alloc] init];
                    alert.message = checkSafeContent(contentDic[@"content"]);
                    alert.alertMessage.textAlignment = NSTextAlignmentLeft;
                    alert.cancleTitle = NSLocalizedString(@"取消", nil);
                    alert.confirmTitle  = NSLocalizedString(@"更新", nil);
                    if ([contentDic[@"update"] integerValue] == 1) {
                        alert.hideCancelBtn = YES;
                    }
                    alert.confirmBlock = ^{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://apps.apple.com/cn/app/%E6%94%B6%E9%93%B6%E5%91%97%E5%AE%98%E6%96%B9%E7%89%88/id1601368783"]];
                    };
                    alert.cancelBlock = ^{
                        [dic setValue:@"1" forKey:@"status"];
                        [dic setValue:[NSString stringWithFormat:@"%zd", curVersions] forKey:@"version"];
                        [ZCDataTool saveVersionInfo:dic];
                    };
                    [alert showAlertView];
                }
               
            }
        } else {
            [self.view makeToast:NSLocalizedString(@"已是最新版本", nil) duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

- (void)jumpAppStore {
    if ( @available(iOS 10 , * )) {
        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly
                                      :@(NO)};
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://apps.apple.com/cn/app/%E6%94%B6%E9%93%B6%E5%91%97%E5%AE%98%E6%96%B9%E7%89%88/id1601368783?action=write-review&mt-8"] options:options completionHandler:^(BOOL success) {
          
              NSLog(@"已经进入 App Store 页面了");
          }];
      } else {
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://apps.apple.com/cn/app/%E6%94%B6%E9%93%B6%E5%91%97%E5%AE%98%E6%96%B9%E7%89%88/id1601368783?action=write-review&mt-8"]];
      }
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
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        _dataArr = [NSMutableArray arrayWithArray:@[
//            @{@"title":NSLocalizedString(@"关联手机号", nil), @"content":@""},
            @{@"title":NSLocalizedString(@"用户协议", nil), @"content":@""},
            @{@"title":NSLocalizedString(@"隐私政策", nil), @"content":@""},
            @{@"title":NSLocalizedString(@"去应用商城评分", nil), @"content":@""},
            @{@"title":NSLocalizedString(@"检查更新", nil), @"content":app_Version},
        ]];
    }
    return _dataArr;
}

@end

//
//  ZCHomeController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/25.
//

#import "ZCHomeController.h"
#import "ZCUpdateVersionView.h"
#import "ZCHomeRecommendClassCell.h"
#import "ZCHomePlanClassCell.h"
#import "ZCHomeTopHeaderView.h"
#import "ZCHomePlanFinishHeaderView.h"
#import "ZCHomeRecommendClassHeaderView.h"
#import "ZCRecommendGuideCell.h"
#import "ZCHomeTrainPlanGuideView.h"
#import "ZCHomeBindDeviceView.h"
#import "CFFChangeNickView.h"

@interface ZCHomeController ()<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *classArr;//推荐课程

@property (nonatomic,strong) ZCHomeTopHeaderView *topView;

@property (nonatomic,strong) ZCHomePlanFinishHeaderView *timeView;

@property (nonatomic,strong) NSArray *bannerArr;//banner

@property (nonatomic,strong) NSDictionary *trainDic;//训练数据

@property (nonatomic,strong) NSDictionary *planDic;//训练计划数据

@property (nonatomic,strong) NSArray *currentPlanArr;//当前训练课程

@property (nonatomic, copy) NSString *currentPlanTime;//当前训练时间

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,strong) ZCHomeBindDeviceView *bindDeviceView;

@end

@implementation ZCHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getAppVersionInfo];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(TAB_BAR_HEIGHT);
    }];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self getBluthNameInfo];
        
        [self getUserInfo];
        
        if ([ZCDataTool getHomeTrainPlanStatus]) {
            [self queryTrainPlanListInfo];
        }
    });
        
    [self queryHomeBannerListInfo];
    
    [self queryRecommendClassListInfo];
    
    ZCHomePlanFinishHeaderView *timeView = [[ZCHomePlanFinishHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 110)];
    self.timeView = timeView;
    
    kweakself(self);
    [RACObserve(kUserStore, refreshTrainClass) subscribeNext:^(id  _Nullable x) {
        [weakself queryTrainPlanListInfo];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        if ([ZCDataTool getHomeTrainPlanStatus]) {
            return self.currentPlanArr.count;
        } else {
            return 0;
        }
    } else {
        return self.classArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ZCHomePlanClassCell *cell = [ZCHomePlanClassCell homePlanClassCell:tableView idnexPath:indexPath];
        cell.dataDic = self.currentPlanArr[indexPath.row];
        return cell;
    } else if (indexPath.section == 2) {
        ZCHomeRecommendClassCell *cell = [ZCHomeRecommendClassCell homeRecommendClassCellWithTableView:tableView idnexPath:indexPath];
        cell.dataDic = self.classArr[indexPath.row];
        return cell;
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        ZCHomeTopHeaderView *topView = [[ZCHomeTopHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(240)+AUTO_MARGIN(40)+AUTO_MARGIN(96))];
        topView.bannerArr = self.bannerArr;
        if (self.trainDic != nil) {            
            topView.trainDic = self.trainDic;
        }
        return topView;
    } else if (section == 1) {
        if ([ZCDataTool getHomeTrainPlanStatus]) {
            if (self.currentPlanTime != nil) {
                self.timeView.selectTime = self.currentPlanTime;
            }
            self.timeView.dataArr = self.planDic.allKeys;
            return self.timeView;
        } else {
            ZCHomeTrainPlanGuideView *guideView = [[ZCHomeTrainPlanGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 286)];
            return guideView;
        }
        
    } else {
        ZCHomeRecommendClassHeaderView *headView = [[ZCHomeRecommendClassHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
        return headView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = @{};
    if (indexPath.section == 1) {
        dic = self.currentPlanArr[indexPath.row];
        NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [temDic setValue:checkSafeContent(temDic[@"planId"]) forKey:@"planId"];
        [HCRouter router:@"ClassDetail" params:temDic viewController:self animated:YES];
    } else if (indexPath.section == 2) {
        NSDictionary *dic = self.classArr[indexPath.row];
        [HCRouter router:@"ClassDetail" params:dic viewController:self animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return AUTO_MARGIN(240)+AUTO_MARGIN(40)+AUTO_MARGIN(96);
    } else if (section == 1) {
        if ([ZCDataTool getHomeTrainPlanStatus]) {
            return 110;
        } else {
            return 286;
        }
    } else {
        return 64;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:@"selectTime"]) {
        self.currentPlanArr = self.planDic[userInfo[@"time"]];
        self.currentPlanTime = userInfo[@"time"];
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } else if ([eventName isEqualToString:@"refreshRecommend"]) {
        [self queryRecommendClassListInfo];
    } else if ([eventName isEqualToString:@"planList"]) {
        [HCRouter router:@"TrainPlanDetail" params:@{@"data":self.planDic} viewController:self animated:YES];
    } else if ([eventName isEqualToString:@"ResetTrainPlanOp"]) {
        [ZCDataTool saveHomeTrainPlanStatus:NO];
        self.currentPlanArr = @[];
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)routerWithEventName:(NSString *)eventName {
    if ([eventName isEqualToString:@"refreshTrainPlan"]) {
        [self queryTrainPlanListInfo];
    } else if ([eventName isEqualToString:@"bindDeviceConnect"]) {
        [self queryBindDeviceListInfo];
    }
}

#pragma -- mark 获取推荐课程
- (void)queryRecommendClassListInfo {
    [ZCClassSportManage classRecommendListInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"class:%@", responseObj);
        self.classArr = responseObj[@"data"];
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

#pragma -- mark 获取训练计划
- (void)queryTrainPlanListInfo {
    [ZCTrainManage queryUserTrainPlanListInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"plan:%@", responseObj);
        NSDictionary *dataDic = responseObj[@"data"];
        self.planDic = dataDic;
        NSString *time = [NSString getCurrentDate];
        time = [time substringWithRange:NSMakeRange(0, 10)];
        NSString *key = [NSString stringWithFormat:@"%@ 00:00:00", time];
        self.currentPlanArr = self.planDic[key];
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

#pragma -- mark 查询绑定设备列表信息
- (void)queryBindDeviceListInfo {
    [ZCClassSportManage queryUserHomeBindDeviceListInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        //188 284
        NSArray *dataArr = responseObj[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showBindDeviceAlertView:dataArr];
        });
    }];
}

- (void)showBindDeviceAlertView:(NSArray *)dataArr {
    
    CGFloat height = 200;
    if (dataArr.count > 0) {
        height = 300;
    }
    [MAINWINDOW addSubview:self.maskBtn];
    self.maskBtn.hidden = NO;
    ZCHomeBindDeviceView *bindDeviceView = [[ZCHomeBindDeviceView alloc] initWithFrame:CGRectMake(0, SCREEN_H-height, SCREEN_W, height)];
    [MAINWINDOW addSubview:bindDeviceView];
    self.bindDeviceView = bindDeviceView;
    bindDeviceView.dataArr = dataArr;
    
    [bindDeviceView showContentView];
    
    kweakself(self);
    bindDeviceView.bindDeviceOperate = ^{
        weakself.maskBtn.hidden = YES;
        [HCRouter router:@"SelectSmartDeviceList" params:@{} viewController:weakself animated:YES];
    };
    
    bindDeviceView.hideDeviceOperate = ^{
        weakself.maskBtn.hidden = YES;
    };
    
    bindDeviceView.connectDeviceOperate = ^(NSDictionary * _Nonnull dic) {
        weakself.maskBtn.hidden = YES;
        [weakself jumpDeviceInterfaceWithCode:dic];
    };
}

- (void)jumpDeviceInterfaceWithCode:(NSDictionary *)dic {
    NSString *jumpCode = dic[@"code"];
    if ([jumpCode isEqualToString:@"ruler"]) {//腰围尺2.0
        [HCRouter router:@"SmartTypeRuler" params:dic viewController:self animated:YES];
    } else if ([jumpCode isEqualToString:@"ruler1"]) {//腰围尺1.0 使用SDK款
        [HCRouter router:@"SmartRuler" params:dic viewController:self animated:YES];
    } else if ([jumpCode isEqualToString:@"timer"]) {
        [HCRouter router:@"SmartTimer" params:dic viewController:self animated:YES];
    } else if ([jumpCode isEqualToString:@"suit"]) {
        NSDictionary *dic = kUserStore.userData;
        if ([checkSafeContent(dic[@"weight"]) doubleValue] > 0.0) {
            [HCRouter router:@"FamilySuit" params:dic viewController:self animated:YES];
        } else {
            CFFChangeNickView *change = [[CFFChangeNickView alloc] init];
            change.title = NSLocalizedString(@"体重", nil);
            change.placeholder = NSLocalizedString(@"请输入您的体重", nil);
            change.tf.keyboardType = UIKeyboardTypeDecimalPad;
            change.unitL.hidden = NO;
            change.descL.hidden = NO;
            [change showAlertView];
            kweakself(self);
            change.SaveNickOperate = ^(NSString * _Nonnull name) {
                NSString *weight = [NSString stringWithFormat:@"%.1f", [name doubleValue]];
                [weakself saveUserInfoWithData:@{@"weight":weight}];
            };
        }
    } else {
        //scale
        if ([ZCDataTool getSignHasInputUserInfo]) {
            [HCRouter router:@"SmartCloud" params:dic viewController:self animated:YES];
        } else {
            [HCRouter router:@"SmartCloudBase" params:@{} viewController:self animated:YES];
        }
    }
}
    
- (void)maskBtnClick {
    self.maskBtn.hidden = YES;
    [self.bindDeviceView hideContentView];
}
    
- (void)saveUserInfoWithData:(NSDictionary *)parm {
        
    [ZCProfileManage updateUserInfoOperate:parm completeHandler:^(id  _Nonnull responseObj) {
        [self getUserInfo];
    }];
}
#pragma -- mark banner
- (void)queryHomeBannerListInfo {
    [ZCTrainManage queryHomeBannerListInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        self.bannerArr = responseObj[@"data"];
        if ([ZCUserInfo shareInstance].token == nil) {
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self queryTodayTrainDataInfo];
    }];
}
#pragma -- mark 获取今日训练数据
- (void)queryTodayTrainDataInfo {
    [ZCClassSportManage queryTodayTrainDataInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"data:%@", responseObj);
        self.trainDic = responseObj[@"data"];
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

#pragma -- mark 获取蓝牙配置
- (void)getBluthNameInfo {
    [ZCLoginManage getUserBluetoothSettingInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        if ([responseObj[@"code"] integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ZCBluthDataTool saveTimerBluthNameContent:responseObj[@"data"]];
            });
        }
    }];
}

#pragma -- mark 获取版本信息
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
            } else { // 跳转到appstore
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ZCDataTool getVersionInfo]];
                if ([dic[@"version"] integerValue] == curVersions && ([dic[@"status"] integerValue] == 1)) {
                } else {
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
                        //id1601368783
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
            }
        }
    }];
}

- (void)getUserInfo {
    [ZCProfileManage getUserBaseInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"userInfo:%@", responseObj);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [ZCConfigColor whiteColor];
        [_tableView registerClass:[ZCHomeRecommendClassCell class] forCellReuseIdentifier:@"ZCHomeRecommendClassCell"];
        [_tableView registerClass:[ZCHomePlanClassCell class] forCellReuseIdentifier:@"ZCHomePlanClassCell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

@end

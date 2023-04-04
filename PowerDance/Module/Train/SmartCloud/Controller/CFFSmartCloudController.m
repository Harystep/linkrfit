//
//  CFFSmartCloudController.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/16.
//

#import "CFFSmartCloudController.h"
#import "CFFHomeDataDetailView.h"
#import "CFFSmartCloudTopView.h"
#import "BLEServer.h"
#import "ScaleAlgorithmTool.h"
#import "CFFDataTool.h"
#import "CFFSmartCloudBottomCell.h"
#import "CFFBluetoothStatusView.h"
#import "CFFAlertView.h"
#import "CFFPreferenceTool.h"

#define kColorBlue(alpha) RGBA_COLOR(174, 194, 228, alpha)  //蓝
#define kColorBrown(alpha) RGBA_COLOR(198, 138, 104, alpha) //棕
#define kColorGreen(alpha) RGBA_COLOR(30, 125, 102, alpha) //绿
//rgba(30, 125, 102, 1) RGBA_COLOR(69, 161, 138, alpha)

@interface CFFSmartCloudController ()<BLEServerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) CFFBluetoothStatusView *bluView;
@property (nonatomic,strong) CFFHomeDataDetailView *dataView;
@property (nonatomic,strong) UIView *navTopView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIButton *btnLeft;

@property (nonatomic,strong) CFFSmartCloudTopView *cloudView;

@property (strong,nonatomic)BLEServer * defaultBLEServer;

@property (nonatomic,assign) double oldValue;

@property (nonatomic,assign) double preValue;
@property (nonatomic,assign) NSInteger scrollOffsetFlag;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *modelArr;
@property (nonatomic,assign) SicBiaAlgOutInfStr outInfo;
@property (nonatomic,assign) SicBiaAlgOutInfStr dataBackInfo;
@property (nonatomic,assign) NSInteger impedance;
@property (nonatomic,assign) BOOL leaveFlag;

@end

@implementation CFFSmartCloudController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.defaultBLEServer = nil;
    self.leaveFlag = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [super viewDidDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self configBlueTool];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"智能云朵体脂秤", nil);
    [self setupSubviews];
    
    [self getUserProfileInfo];
    
    [self bind];
    
//    if (![CFFPreferenceTool getUserCloudGuideStatus]) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (!self.leaveFlag) {
//                if (self.bluView.type != 2) {
//                    [CFFPreferenceTool saveUserCloudGuideStatus:YES];
//                    [self.bluView showStatusView];
//                }
//            }
//        });
//    }
    [self.bluView showStatusView];
}

- (void)bind {
    @weakify(self);
    [RACObserve(kCFF_COMMON_STORE, weight) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self getUserProfileInfo];
    }];
}

- (void)configBlueTool {
    self.defaultBLEServer = [BLEServer defaultBLEServer];
    self.defaultBLEServer.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.defaultBLEServer startScan];
    });
    
    self.defaultBLEServer.ConnectBlockStatus = ^(NSInteger status) {
        NSLog(@"链接成功");
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cloudBackData:) name:@"KSmartCloudBackDataKey" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cloudErrorBackData:) name:@"kSmartCloudErrorKey" object:nil];
}

- (void)cloudErrorBackData:(NSNotification *)noti {
    NSInteger errorType = [noti.object integerValue];
    [CFFHud stopLoading];
    if (errorType == 0) {
        SicBiaAlgOutInfStr outInfo = [ScaleAlgorithmTool scaleAlgorithToolWithNum:self.preValue Impedance:self.impedance];
        [self setUserWeightDataBody:outInfo value:[NSString stringWithFormat:@"%.1f", self.preValue] impedance:self.impedance];
    } else {
        [[CFFAlertView sharedInstance] showTextMsg:[ScaleAlgorithmTool checkErrorTypeWithBackType:errorType]];
    }
}

- (void)cloudBackData:(NSNotification *)noti {
    NSArray *dataArr = noti.object;
    NSInteger backValue = [ScaleAlgorithmTool algorithToolNumWithPreNum:dataArr[14] endNum:dataArr[13]];
    NSInteger impedance = [ScaleAlgorithmTool algorithToolNumWithPreNum:dataArr[10] endNum:dataArr[9]];
    
    if (dataArr.count > 12) {
        dispatch_async(dispatch_get_main_queue(), ^{
            double dataValue = backValue / 100.0;
            if (self.preValue != dataValue) {
                NSLog(@"impedance-->%ld", impedance);
                self.impedance = impedance;
                NSLog(@"%@", dataArr);
                NSLog(@"value--->%tu ", backValue);
                NSLog(@"pre:%f   now:%f", self.preValue, dataValue);
                self.preValue = dataValue;
                UIColor *bgColor;
                if (self.oldValue > dataValue) {
                    bgColor = kColorBlue(1);
                    self.bgView.alpha = 0.4;
                    self.cloudView.contentL.textColor = kColorBlue(0.2);
                    [UIView animateWithDuration:2.0 animations:^{
                        self.bgView.alpha = 1;
                        self.cloudView.contentL.textColor = bgColor;
                        self.scView.backgroundColor = bgColor;
                    } completion:^(BOOL finished) {
                        NSLog(@"bgView---->");
                    }];
                } else if (self.oldValue < dataValue) {
                    bgColor = kColorBrown(1);
                    self.bgView.alpha = 0.35;
                    self.cloudView.contentL.textColor = kColorBrown(0.2);
                    [UIView animateWithDuration:2.0 animations:^{
                        self.bgView.alpha = 1;
                        self.cloudView.contentL.textColor = bgColor;
                        self.scView.backgroundColor = bgColor;
                    } completion:^(BOOL finished) {
                        NSLog(@"bgView---->");
                    }];
                } else {
                    bgColor = kColorGreen(1);
                    self.bgView.backgroundColor = bgColor;
                    self.bgView.alpha = 0.4;
                    self.cloudView.contentL.textColor = kColorGreen(0.2);
                    [UIView animateWithDuration:2.0 animations:^{
                        self.bgView.alpha = 1;
                        self.cloudView.contentL.textColor = bgColor;
                        self.scView.backgroundColor = bgColor;
                    } completion:^(BOOL finished) {
                        NSLog(@"bgView---->");
                    }];
                }
                self.cloudView.contentL.text = [NSString stringWithFormat:@"%.1fKg", dataValue];
                self.cloudView.transformL.text = [NSString stringWithFormat:@"%@%@/%@%@", [NSString stringWithFormat:@"%.1f", dataValue*2], NSLocalizedString(@"斤", nil), [CFFDataTool convertKgToLb:dataValue], NSLocalizedString(@"磅", nil)];
                
                [CFFHud showLoadingWithTitle:NSLocalizedString(@"检测中···", nil)];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ScaleAlgorithmTool scaleAlgorithToolWithNum:dataValue Impedance:impedance upload:YES];
                });
            }
        });
    }
}

- (void)setUserWeightDataBody:(SicBiaAlgOutInfStr)outInfo value:(NSString *)value impedance:(NSInteger)impedance {
    self.dataView.weightView.value = [value doubleValue];
    NSDictionary *parm = @{
        @"bfr":@(outInfo.BFR / 10000.0),
        @"bmc":@(outInfo.BMC / 100.0),
        @"bmi":@(outInfo.BMI / 100.0),
        @"bmr":@(outInfo.BMR),
        @"bpr":@(outInfo.BPR / 10000.0),
        @"bwr":@(outInfo.BWR / 10000.0),
        //        @"id":@"",
        @"phyAge":@(outInfo.PhyAge),
        @"sbw":@(outInfo.SBW / 100.0),
        @"score":@(outInfo.SCORE),
        @"slm":@(outInfo.SLM / 100.0),
        @"vfr":@(outInfo.VFR / 100.0),
        @"weight":value,
        @"weightB":[CFFDataTool convertKgToLb:[value doubleValue]],
        @"impedance":@(impedance)
    };
    NSLog(@"parm-->%@", parm);
    
    [kCFF_COMMON_STORE saveCloudWeightRecordOperate:parm Success:^(id  _Nullable responseObject) {
        [self changeUserWeight:value];
    } failed:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)changeUserWeight:(NSString *)value {
    [kCFF_PROFILE_STORE updateUserInfo:@{@"weight":value} success:^(id  _Nullable responseObject) {
        kCFF_COMMON_STORE.weight = [value doubleValue];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark -- bleserver delegate
-(void)didStopScan
{
    [self.defaultBLEServer startScan];
}

-(void)didFoundPeripheral
{
    NSLog(@"发现外设");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bluView.type = BluetoothConnectStatusOk;
        [self.bluView hideStatusView];
    });
}

-(void)didDisconnect
{
    NSLog(@"aaaaa--->外设断开");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bluView.type = BluetoothConnectStatusClosed;
    });
    [self.defaultBLEServer startScan];
}

- (void)setupSubviews {
    
    self.scView = [[UIScrollView alloc] init];
    self.scView.backgroundColor = rgba(43, 42, 51, 1);
    self.scView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.scView.showsVerticalScrollIndicator = YES;
    self.scView.delegate = self;
    [self.view addSubview:self.scView];
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.bgView = [[UIView alloc] init];
    [self.scView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scView);
        make.width.mas_equalTo(self.scView);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    self.contentView = contentView;
    [self.scView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scView);
        make.width.mas_equalTo(self.scView);
    }];
    
    self.cloudView = [[CFFSmartCloudTopView alloc] init];
    [contentView addSubview:self.cloudView];
    [self.cloudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(contentView);
        make.top.mas_equalTo(contentView.mas_top);
        make.height.mas_equalTo(AUTO_MARGIN(400));
    }];
    
    [self.view addSubview:self.navTopView];
    [self.navTopView addSubview:self.btnLeft];
    [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.view).offset(kCFF_STATUS_BAR_HEIGHT);
    }];

    UILabel *titleL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"智能云朵体脂秤", nil) font:17 bold:NO color:UIColor.whiteColor];
    self.titleL = titleL;
    [self.navTopView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.btnLeft.mas_centerY);
        make.centerX.mas_equalTo(self.navTopView.mas_centerX);
    }];
    
    self.dataView = [[CFFHomeDataDetailView alloc] init];
    self.dataView.type = 1;
    [contentView addSubview:self.dataView];
    [self.dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(contentView);
        make.top.mas_equalTo(self.cloudView.mas_bottom).offset(AUTO_MARGIN(-140));
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    [contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(contentView);
        make.height.mas_equalTo(630);
        make.top.mas_equalTo(self.dataView.mas_bottom);
        make.bottom.mas_equalTo(contentView.mas_bottom).inset(AUTO_MARGIN(42));
    }];
    [bottomView setViewCornerRadiu:15];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.alpha = 0.74;
    [bottomView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(bottomView).inset(AUTO_MARGIN(15));
        make.top.bottom.mas_equalTo(bottomView);
    }];
    [bgView setViewCornerRadiu:15];
    
    [bottomView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(bottomView).inset(AUTO_MARGIN(15));
        make.top.bottom.mas_equalTo(bottomView);
    }];
    [self.tableView setViewCornerRadiu:15];
    
    [contentView addSubview:self.bluView];
    [self.bluView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(15));
        make.top.mas_equalTo(contentView.mas_top).offset(kCFF_TOP_CONTENT_HEIGHT+AUTO_MARGIN(20));
    }];
    kweakself(self);
    self.bluView.BluetoothConnectOperate = ^{
        [weakself.defaultBLEServer startScan];
    };
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CFFSmartCloudBottomCell *cell = [CFFSmartCloudBottomCell homeDataAnalysisWithTableView:tableView idnexPath:indexPath];
    cell.dict = self.dataArr[indexPath.row];
    if (indexPath.row == self.dataArr.count - 1) {
        cell.sepView.hidden = YES;
    } else {
        cell.sepView.hidden = NO;
    }
    if (self.modelArr.count == self.dataArr.count) {
        cell.precentL.text = self.modelArr[indexPath.row];
    }
    return cell;
}
#pragma -- mark 获取用户信息
- (void)getUserProfileInfo {
    [ZCProfileManage getUserBaseInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        if ([responseObj[@"code"] integerValue] == CFFApiErrorCode_Success) {
            self.oldValue = [checkSafeContent(kUserStore.userData[@"targetWeight"]) doubleValue];
            self.dataView.dataWeight = [checkSafeContent(kUserStore.userData[@"weight"]) doubleValue];
            [self getCouldRecordList];
        }
    }];
}
#pragma -- mark 获取体重记录
- (void)getCouldRecordList {
    [kCFF_COMMON_STORE requestCloudRecordList:@{} Success:^(id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *dataArr = responseObject[@"data"];
        if (dataArr.count > 0) {
            NSDictionary *dic = dataArr[0];
            [self.dataView refreshStandViewData:dataArr];
            [self configModelData:dic];
        }
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
    
- (void)configModelData:(NSDictionary *)dict {
    [self.modelArr removeAllObjects];
    NSString *impedance = [CFFDataTool reviseString:checkSafeContent(dict[@"impedance"])];
    SicBiaAlgOutInfStr outInfo = [ScaleAlgorithmTool scaleAlgorithToolWithNum:[dict[@"weight"] doubleValue] Impedance:[impedance integerValue]];
    self.outInfo = outInfo;
    if (outInfo.BFR > 0.0) {
        [self.modelArr addObject:[NSString stringWithFormat:@"%.2f%@", outInfo.BWR / 100.0, @"%"]];
        [self.modelArr addObject:[NSString stringWithFormat:@"%.2f%@", outInfo.BPR / 100.0, @"%"]];
        [self.modelArr addObject:[NSString stringWithFormat:@"%@Kcal", @(outInfo.BMR)]];
        [self.modelArr addObject:[ScaleAlgorithmTool fatSystemTypeWithBackType:outInfo.vfr_l]];
        [self.modelArr addObject:[NSString stringWithFormat:@"%.2fKg", outInfo.BMC / 100.0]];
        [self.modelArr addObject:[NSString stringWithFormat:@"%d", outInfo.PhyAge]];
        [self.modelArr addObject:[ScaleAlgorithmTool bodyTypeWithBackType:outInfo.BodyType]];
        [self.modelArr addObject:[NSString stringWithFormat:@"%.2fKg", outInfo.SBW / 100.0]];
        [self.modelArr addObject:[NSString stringWithFormat:@"%d", outInfo.SCORE]];
    } else {
        for (int i = 0; i < 9; i ++) {
            [self.modelArr addObject:@"--"];
        }
    }
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollY = scrollView.contentOffset.y;
    if (scrollY > 0.0 && scrollY <= 30.0) {
        self.navTopView.backgroundColor = RGBA_COLOR(255, 255, 255, scrollY/30.0);
        if (scrollY > 15.0) {
            self.titleL.textColor = RGBA_COLOR(0, 0, 0, scrollY/30.0);
            [self.btnLeft setImage:kIMAGE(@"back_btn_black") forState:UIControlStateNormal];
            self.btnLeft.alpha = 0.5 + scrollY/30.0;
        } else {
            self.titleL.textColor = RGBA_COLOR(255, 255, 255, 1.0 - scrollY/30.0);;
            [self.btnLeft setImage:kIMAGE(@"back_btn_white") forState:UIControlStateNormal];
            self.btnLeft.alpha = 1.0 - scrollY/30.0;
        }
        self.scrollOffsetFlag = NO;
    } else if (scrollY > 30) {
        if (!self.scrollOffsetFlag) {
            self.navTopView.backgroundColor = UIColor.whiteColor;
            [self.btnLeft setImage:kIMAGE(@"back_btn_black") forState:UIControlStateNormal];
            self.titleL.textColor = UIColor.blackColor;
            self.scrollOffsetFlag = YES;
        }
        
    } else {
        self.navTopView.backgroundColor = UIColor.clearColor;
        self.titleL.textColor = UIColor.whiteColor;
        [self.btnLeft setImage:kIMAGE(@"back_btn_white") forState:UIControlStateNormal];
        NSLog(@"%f", scrollY);
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[CFFSmartCloudBottomCell class] forCellReuseIdentifier:@"CFFSmartCloudBottomCell"];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithObjects:
                    @{@"title":NSLocalizedString(@"水分", nil),
                      @"icon":kIMAGE(@"home_dataDetail_water")},
                    @{@"title":NSLocalizedString(@"蛋白质1", nil),
                      @"icon":kIMAGE(@"home_dataDetail_protain")},
                    @{@"title":NSLocalizedString(@"基础代谢", nil),
                      @"icon":kIMAGE(@"home_dataDetail_base")},
                    @{@"title":NSLocalizedString(@"内脏脂肪", nil),
                      @"icon":kIMAGE(@"home_dataDetail_fat")},
                    @{@"title":NSLocalizedString(@"骨盐量", nil),
                      @"icon":kIMAGE(@"home_dataDetail_bone")},
                    @{@"title":NSLocalizedString(@"身体年龄", nil),
                      @"icon":kIMAGE(@"home_dataDetail_age")},
                    @{@"title":NSLocalizedString(@"身体类型", nil),
                      @"icon":kIMAGE(@"home_dataDetail_type")},
                    @{@"title":NSLocalizedString(@"标准体重", nil),
                      @"icon":kIMAGE(@"home_dataDetail_weight")},
                    @{@"title":NSLocalizedString(@"身体得分", nil),
                      @"icon":kIMAGE(@"home_dataDetail_score")}, nil];
    }
    return _dataArr;
}

- (NSMutableArray *)modelArr {
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

- (UIButton *)btnLeft{
    if (!_btnLeft) {
        _btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnLeft setImage:[UIImage imageNamed:@"back_btn_white"] forState:UIControlStateNormal];
        kweakself(self);
        [[_btnLeft rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if ([weakself.params[@"back"] integerValue] == 1) {
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [weakself.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    return _btnLeft;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KSmartCloudBackDataKey" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kSmartCloudErrorKey" object:nil];
}


- (CFFBluetoothStatusView *)bluView {
    if (!_bluView) {
        _bluView = [[CFFBluetoothStatusView alloc] init];        
        _bluView.deviceType = SmartDeviceTypeCloud;
    }
    return _bluView;
}

- (UIView *)navTopView {
    if (!_navTopView) {
        _navTopView = [[UIView alloc] init];
        _navTopView.frame = CGRectMake(0, 0, kCFF_SCREEN_WIDTH, kCFF_TOP_CONTENT_HEIGHT);
        
    }
    return _navTopView;
}


@end

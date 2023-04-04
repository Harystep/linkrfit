//
//  ZCTrainDetailController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/29.
//

#import "ZCTrainDetailController.h"
#import "ZCTrainDetailTimeView.h"
#import "ZCSportDetailView.h"
#import "ZCTrainDetailActionCell.h"
#import "ZCTrainDetailGroupHeaderView.h"
#import "BLETimerServer.h"

@interface ZCTrainDetailController ()<UITableViewDelegate, UITableViewDataSource, BLEServerDelegate>

@property (nonatomic,strong) UIScrollView *scView;
@property (nonatomic,strong) ZCTrainDetailTimeView *timeView;
@property (nonatomic,strong) UILabel *descL;
@property (nonatomic,strong) ZCSportDetailView *sportView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) NSArray *apparatusList;
@property (nonatomic,strong) NSArray *groupList;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) UIButton *trainBtn;
@property (nonatomic,strong) UIButton *equipBtn;
@property (nonatomic,strong) NSMutableArray *fsDataArr;
@property (nonatomic,strong) BLETimerServer *defaultBLEServer;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) NSInteger signFSModeFlag;
@property (nonatomic,assign) NSInteger signConnectTimerFlag;
@property (nonatomic,strong) UIButton *sendBtn;
@property (nonatomic,strong) UIButton *startBtn;
@property (nonatomic,strong) UIView *startView;
@property (nonatomic,strong) UIView *addView;
@property (nonatomic,assign) NSInteger signIndex;//有效数据组标记
@property (nonatomic,assign) NSInteger signErrorIndex;//标记错误

@end

@implementation ZCTrainDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.type = [self.params[@"type"] integerValue];
    [self configureBaseInfo];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(10));
        make.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(100));
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [ZCConfigColor txtColor];
    self.contentView = contentView;
    self.tableView.tableHeaderView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.mas_equalTo(self.tableView);
        make.leading.trailing.mas_equalTo(self.tableView);
    }];
    self.descL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"适合初学者的全身燃脂训练课程，通过短暂高强度的运动和休息交替重复进行，是一个在短时间内就可以达到非常高能量消耗的运动模式。建议每周进行2-3次训练，坚持2周时间，配合低油低盐的健康饮食，你终将获得理想的完美身材，加油！", nil) font:12 bold:NO color:[ZCConfigColor whiteColor]];
    [contentView addSubview:self.descL];
    [self.descL setContentLineFeedStyle];
    [self.descL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView.mas_top).offset(AUTO_MARGIN(30));
        make.leading.trailing.mas_equalTo(contentView).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(80));
    }];
    self.descL.preferredMaxLayoutWidth = self.descL.frame.size.width;
    
    UIView *timeView = [[UIView alloc] init];
    [contentView addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.descL.mas_bottom).offset(AUTO_MARGIN(20));
        make.leading.trailing.mas_equalTo(contentView).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(144));
//        make.bottom.mas_equalTo(contentView.mas_bottom).inset(AUTO_MARGIN(30));
    }];
    [timeView setViewCornerRadiu:10];
    [timeView setViewColorAlpha:0.1 color:[ZCConfigColor whiteColor]];
    
    self.timeView = [[ZCTrainDetailTimeView alloc] init];
    [timeView addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(timeView);
        make.top.mas_equalTo(timeView.mas_top).offset(AUTO_MARGIN(20));
    }];
    
    UIView *equipment = [[UIView alloc] init];
    [timeView addSubview:equipment];
    [equipment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(timeView);
        make.bottom.mas_equalTo(timeView);
        make.top.mas_equalTo(self.timeView.mas_bottom).offset(AUTO_MARGIN(8));
    }];
    [self createSubviewsOnEquipmentView:equipment];
        
    UIView *groupTitleView = [[UIView alloc] init];
    groupTitleView.backgroundColor = UIColor.whiteColor;
    [contentView addSubview:groupTitleView];
    [groupTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(contentView);
        make.top.mas_equalTo(timeView.mas_bottom).offset(AUTO_MARGIN(30));
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.bottom.mas_equalTo(contentView.mas_bottom);
    }];

    UILabel *groupTL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"动作表:", nil) font:20 bold:YES color:[ZCConfigColor txtColor]];
    [groupTitleView addSubview:groupTL];
    [groupTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(groupTitleView);
        make.leading.mas_equalTo(groupTitleView.mas_leading).offset(AUTO_MARGIN(20));
    }];
        
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(AUTO_MARGIN(98));
    }];
    [self createSubviewOnBottomView:bottomView];
    
    [self getTrainDetailInfo];
    
    self.defaultBLEServer = [BLETimerServer defaultBLEServer];
    self.defaultBLEServer.delegate = self;
   
}

- (void)setupFSModeData {
    NSMutableArray *fsModeArr = [NSMutableArray array];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSDictionary *dataDic in self.groupList) {
        NSArray *itemList = dataDic[@"itemList"];
        for (NSDictionary *dic in itemList) {
            [dataArr addObject:[NSString stringWithFormat:@"%@", dic[@"duration"]]];
        }
    }
    
    NSInteger row = dataArr.count / 10;
    if (dataArr.count % 10) {
        self.signIndex = row + 1;
    } else {
        self.signIndex = row;
    }
    NSArray *temArr = [self convertArrayData:dataArr];
    NSInteger col = temArr.count % 10;
    NSString *content = @"LS:1";
    for (int i = 0; i < temArr.count; i ++) {
        content = [content stringByAppendingString:[NSString stringWithFormat:@",F%d:%@,C%d:%@", i+1, temArr[i], i+1, @"0"]];
        if ((i+1) % 10 == 0) {
            [fsModeArr addObject:content];
            content = @"LS:1";
        }
         if (col > 0 && i == temArr.count-1) {
             [fsModeArr addObject:content];
        }
    }
    self.fsDataArr = fsModeArr;
}

- (NSArray *)convertArrayData:(NSArray *)temArr {
    NSMutableArray *array = [NSMutableArray arrayWithArray:temArr];
    for (NSInteger i = temArr.count; i < 50; i ++) {
        [array addObject:@"0"];
    }
    return array;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dataDic = self.groupList[section];
    NSArray *dataArr = dataDic[@"itemList"];
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCTrainDetailActionCell *cell = [ZCTrainDetailActionCell trainDetailActionCellWithTableView:tableView idnexPath:indexPath];
    NSDictionary *dataDic = self.groupList[indexPath.section];
    NSArray *dataArr = dataDic[@"itemList"];
    cell.dataDic = dataArr[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 10)];
    view.backgroundColor = UIColor.whiteColor;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZCTrainDetailGroupHeaderView *view = [[ZCTrainDetailGroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(40))];
    NSDictionary *dataDic = self.groupList[section];
    view.dataDic = dataDic;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTO_MARGIN(40);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)getTrainDetailInfo {
    [ZCTrainManage queryTrainDetailInfo:@{@"trainId":checkSafeContent(self.params[@"id"])} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dataDic = responseObj[@"data"];
            NSString *content = checkSafeContent(dataDic[@"briefDesc"]);
            [self compareContentSize:content withFont:14 widthLimited:self.contentView.width];
            self.titleStr = checkSafeContent(dataDic[@"name"]);
            self.timeView.dataArr = dataDic[@"groupList"];
            [self configureSportColor:dataDic[@"groupList"]];
            self.apparatusList = [ZCDataTool convertEffectiveData:dataDic[@"apparatusList"]];
            [self setApparatusListStatus];
            [self setupFSModeData];
            
            [self.tableView reloadData];
        });
    }];
}

- (void)compareContentSize:(NSString *)title withFont:(CGFloat)font widthLimited:(CGFloat)limitWidth {
    UIFont *fnt = [UIFont systemFontOfSize:font];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //关键代码
    [paragraphStyle setLineSpacing:8];//设置距离
    NSDictionary *parms = @{NSFontAttributeName:fnt,
                            NSParagraphStyleAttributeName:paragraphStyle
    };
    CGSize postJobSize = [title boundingRectWithSize:CGSizeMake(limitWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:parms context:nil].size;
    [self.descL setAttributeStringContent:title space:5 font:FONT_SYSTEM(14) alignment:NSTextAlignmentLeft];
    [self.descL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(postJobSize.height);
    }];
    CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = self.contentView.frame;
    frame.size.height = height;
    self.contentView.frame = frame;    
    [self.tableView beginUpdates];
    self.tableView.tableHeaderView = self.contentView;
    [self.tableView endUpdates];
}

- (void)setApparatusListStatus {
    if (self.apparatusList.count > 0) {
        [self.equipBtn setImage:kIMAGE(@"train_arrow") forState:UIControlStateNormal];
    } else {
        [self.equipBtn setTitle:NSLocalizedString(@"无", nil) forState:UIControlStateNormal];
    }
}

- (void)configureSportColor:(NSArray *)dataArr {
    NSMutableArray *temArr = [NSMutableArray array];
    for (NSDictionary *dic in dataArr) {
        NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSArray *itemList = dic[@"itemList"];
        NSMutableArray *itemArr = [NSMutableArray array];
        for (NSDictionary *item in itemList) {
            NSString *color = [ZCDataTool randomColor];
            NSMutableDictionary *itemDic = [NSMutableDictionary dictionaryWithDictionary:item];
            if ([item[@"rest"] integerValue] == 1) {
                [itemDic setValue:[ZCConfigColor blueColor] forKey:@"color"];
            } else {
                [itemDic setValue:color forKey:@"color"];
            }
            [itemArr addObject:itemDic];
        }
        [temDic setValue:itemArr forKey:@"itemList"];
        
        [temArr addObject:temDic];
    }
    self.groupList = temArr;
}

#pragma -- mark 停止扫描
- (void)didStopScan {
    dispatch_async(dispatch_get_main_queue(), ^{
        [CFFHud stopLoading];
        [self.view makeToast:NSLocalizedString(@"请确定计时器已开启", nil) duration:2.0 position:CSToastPositionCenter];
    });
}

- (void)didFoundPeripheral {
    NSLog(@"come here");
}

- (void)didDisconnect {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.signConnectTimerFlag = NO;
        [CFFHud stopLoading];
        self.currentIndex = 0;
        [self.view makeToast:NSLocalizedString(@"计时器已断开连接", nil) duration:2.0 position:CSToastPositionCenter];
    });
}

- (void)didConnect {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupTimerBaseData];
    });
}

- (void)trainOperate:(UIButton *)sender {
    if (sender.tag) {//TrainSport TrainFinish
        if (self.groupList.count > 0) {
            if (self.signConnectTimerFlag) {                
                [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool timerStart] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
                self.signConnectTimerFlag = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [HCRouter router:@"TrainSport" params:@{@"data":self.groupList, @"trainId":checkSafeContent(self.params[@"id"]), @"timer":@"1"} viewController:self animated:YES];
                });
               
            } else {
                [HCRouter router:@"TrainSport" params:@{@"data":self.groupList, @"trainId":checkSafeContent(self.params[@"id"])} viewController:self animated:YES];
            }
        } else {
            [self.view makeToast:NSLocalizedString(@"暂无运动详情", nil) duration:2.0 position:CSToastPositionCenter];
        }
    } else {
        [CFFHud showLoadingWithTitle:@""];
        if (kUserInfo.status == NO) {
            [[BLETimerServer defaultBLEServer] startScan];
        } else {
            [self setupTimerBaseData];
        }
//        if ([self judgeCurrentStatusTimer]) {
//        } else {
//            [self collectTrainPlanOperate];
//        }
    }
}

- (void)fsModeDataBack {
    if (self.signFSModeFlag) {
        if (self.currentIndex == self.fsDataArr.count - 1) {
            self.signFSModeFlag = NO;
            
            [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool timerDelayOpen] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.signConnectTimerFlag = YES;
                [CFFHud stopLoading];
                self.addView.hidden = YES;
                [self.view makeToast:NSLocalizedString(@"数据发送成功", nil) duration:2.0 position:CSToastPositionCenter];
                [self.startView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(self.view.mas_leading).offset(AUTO_MARGIN(20));
                }];
            });
        } else {
            self.currentIndex ++;
            [self sendFSModeData];
        }
    }
}

- (void)sendFSModeData {
    NSLog(@"currentIndex-->FS:%@", self.fsDataArr[self.currentIndex]);
    self.signErrorIndex = -1;
    self.signFSModeFlag = YES;
    [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool sendFSData:self.fsDataArr[self.currentIndex]] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)timerBackDataError {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.signFSModeFlag) {
            if (self.signErrorIndex == self.currentIndex) {
                self.signConnectTimerFlag = NO;
                [CFFHud stopLoading];
                self.currentIndex = 0;
                [self.view makeToast:NSLocalizedString(@"连接故障，请重新发送", nil) duration:2.0 position:CSToastPositionCenter];
            } else {
                self.signErrorIndex = self.currentIndex;
                NSLog(@"error-->FS:%@", self.fsDataArr[self.currentIndex]);
                [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool sendFSData:self.fsDataArr[self.currentIndex]] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
            }
        }
    });
}

- (void)timerBackDataAgain {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.signFSModeFlag) {
            if (self.signErrorIndex == self.currentIndex) {
                self.signConnectTimerFlag = NO;
                [CFFHud stopLoading];
                self.currentIndex = 0;
                [self.view makeToast:NSLocalizedString(@"请重新发送", nil) duration:2.0 position:CSToastPositionCenter];
            } else {
                self.signErrorIndex = self.currentIndex;
                [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool sendFSData:self.fsDataArr[self.currentIndex]] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
            }
        }
    });
}

- (void)setupTimerBaseData {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fsModeDataBack) name:@"kFSModeBackKey" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerBackDataError) name:@"kFSModeBackErrorKey" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerBackDataAgain) name:@"kFSModeBackAgainKey" object:nil];    
    
    self.signFSModeFlag = YES;
    [self sendFSModeData];
    
}

- (void)createSubviewOnBottomView:(UIView *)bottomView {
    
    UIView *addView = [[UIView alloc] init];
    self.addView = addView;
    [bottomView addSubview:addView];
    [addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(bottomView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(bottomView.mas_top).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(40));
        make.width.mas_equalTo(AUTO_MARGIN(158));
    }];
    [addView setViewCornerRadiu:AUTO_MARGIN(20)];
    
    UIButton *add = [bottomView createSimpleButtonWithTitle:NSLocalizedString(@"添加到我的训练", nil) font:14 color:[ZCConfigColor whiteColor]];
    add.tag = 0;
    //train_add_nor train_add
    [addView addSubview:add];
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(addView);
    }];
    self.trainBtn = add;
    [add addTarget:self action:@selector(trainOperate:) forControlEvents:UIControlEventTouchUpInside];
    NSString *title = NSLocalizedString(@"发送到计时器", nil);
    NSString *imageStr = @"sport_data_send";
//    if ([self judgeCurrentStatusTimer]) {
//        title = NSLocalizedString(@"发送到计时器", nil);
//        imageStr = @"sport_data_send";
//    } else {
//        title = NSLocalizedString(@"添加到我的训练", nil);
//        imageStr = @"train_add_nor";
//    }
    [self.trainBtn setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    [self.trainBtn setImage:kIMAGE(imageStr) forState:UIControlStateNormal];
    
     
    UIView *startView = [[UIView alloc] init];
    startView.backgroundColor = UIColor.whiteColor;
    [bottomView addSubview:startView];
    [startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(bottomView.mas_trailing).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(bottomView.mas_top).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(40));
        make.width.mas_equalTo(AUTO_MARGIN(158));
    }];
    self.startView = startView;
    
    UIButton *start = [bottomView createSimpleButtonWithTitle:NSLocalizedString(@"马上开始训练", nil) font:14 color:[ZCConfigColor txtColor]];
    start.tag = 1;
    self.startBtn = start;
    [startView addSubview:start];
    [start addTarget:self action:@selector(trainOperate:) forControlEvents:UIControlEventTouchUpInside];
    [start mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(startView);
    }];
    [startView setViewCornerRadiu:AUTO_MARGIN(20)];
}

- (void)createSubviewsOnEquipmentView:(UIView *)equipment {
    UILabel *titleL = [equipment createSimpleLabelWithTitle:NSLocalizedString(@"使用的器械：", nil) font:14 bold:NO color:[ZCConfigColor whiteColor]];
    [equipment addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(equipment);
        make.leading.mas_equalTo(equipment.mas_leading).offset(AUTO_MARGIN(20));
    }];
    
    UIButton *equipBtn = [equipment createSimpleButtonWithTitle:@"" font:14 color:[ZCConfigColor whiteColor]];
    self.equipBtn = equipBtn;
    [equipment addSubview:equipBtn];
    [equipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleL);
        make.trailing.mas_equalTo(equipment.mas_trailing);
        make.height.width.mas_equalTo(AUTO_MARGINY(60));
    }];
    [equipBtn addTarget:self action:@selector(equipBtnOperate) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma -- mark 跳转设备
- (void)equipBtnOperate {
    if (self.apparatusList.count > 0) {
        [HCRouter router:@"ShowEquipment" params:@{@"data":self.apparatusList} viewController:self animated:YES];
    }
}

- (void)configureBaseInfo {
    self.view.backgroundColor = [ZCConfigColor txtColor];
    self.showNavStatus = YES;
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleWhite;
    self.currentIndex = 0;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 100.f;
        [_tableView registerClass:[ZCTrainDetailActionCell class] forCellReuseIdentifier:@"ZCTrainDetailActionCell"];
        
    }
    return _tableView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

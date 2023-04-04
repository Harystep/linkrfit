//
//  ZCSuitTrainController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/7/29.
//

#import "ZCSuitTrainController.h"
#import "ZCBodyHeartView.h"
#import "ZCSuitTrainBaseView.h"
#import "ZCSuitNextTrainView.h"
#import "ZCClassTrainOverView.h"
#import "ZCSuitTrainCompleteView.h"
#import "BLESuitServer.h"

@interface ZCSuitTrainController ()

@property (nonatomic,strong) ZCBodyHeartView *heartView;

@property (nonatomic,strong) ZCSuitTrainBaseView *baseView;

@property (nonatomic,strong) NSArray *imageArr;

@property (nonatomic,strong) UILabel *timeL;//运动时间显示

@property (nonatomic,strong) UILabel *targetL;//当前训练名称

@property (nonatomic,strong) ZCSuitNextTrainView *nextView;

@property (nonatomic,strong) NSArray *dataArr;//数据源

@property (nonatomic,strong) ZCSuitTrainCompleteView *completeView;

@property (nonatomic,strong) NSArray *baseArr;//数据

@property (nonatomic, assign) NSInteger index;//索引

@property (nonatomic,strong) NSTimer *timer;//倒计时

@property (nonatomic, assign) NSInteger mouse;//计数

@property (nonatomic, copy) NSString *trainCount;//记录训练个数

@property (nonatomic, copy) NSString *currentRate;//当前心率

@property (nonatomic, assign) BOOL sportState;//标记运动状态

@property (nonatomic,strong) NSMutableArray *countTrainArr;//记录训练个数

@property (nonatomic,strong) NSTimer *trainTimer;//训练定时器

@property (nonatomic, assign) NSInteger trainMouse;//训练计时

@property (nonatomic,strong) NSMutableArray *countTrainTimeArr;//记录训练时间

@property (nonatomic,strong) NSMutableArray *rateArr;

@end

@implementation ZCSuitTrainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeL = [self.view createSimpleLabelWithTitle:@"00:00:00" font:40 bold:YES color:[ZCConfigColor txtColor]];
    [self.view addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(NAV_BAR_HEIGHT+AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(40));
    }];
    
    self.targetL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@" ", nil) font:20 bold:NO color:[ZCConfigColor txtColor]];
    [self.view addSubview:self.targetL];
    [self.targetL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.timeL.mas_bottom).offset(AUTO_MARGIN(10));
        make.height.mas_equalTo(AUTO_MARGIN(20));
    }];
    
    self.heartView = [[ZCBodyHeartView alloc] init];
    [self.view addSubview:self.heartView];
    [self.heartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.targetL.mas_bottom).offset(AUTO_MARGIN(30));
    }];
    
    self.baseView = [[ZCSuitTrainBaseView alloc] init];
    [self.view addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.heartView.mas_bottom).offset(AUTO_MARGIN(10));
    }];
    
    self.completeView = [[ZCSuitTrainCompleteView alloc] init];
    [self.view addSubview:self.completeView];
    [self.completeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.baseView.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    self.completeView.hidden = YES;
    
    [self configureBaseInfo];

    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [ZCConfigColor bgColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(AUTO_MARGIN(100)+TAB_SAFE_BOTTOM);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [bottomView layoutIfNeeded];
    [self.view setupViewRound:bottomView corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    UIView *bottom = [[UIView alloc] init];
    [bottomView addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(bottomView).inset(AUTO_MARGIN(35));
        make.height.mas_equalTo(AUTO_MARGIN(100));
    }];
    [self createBottomOperateView:bottom];
    
    self.baseArr = self.params[@"data"];
    self.index = 0;
    self.sportState = YES;
    [self setupBluDataWithIndex:self.index];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextSportMode) name:@"kSuitSportModeFinishKey" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(heartRateCount:) name:@"kSuitSportModeHeartRateKey" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sportNumCount:) name:@"kSuitSportModeNumberKey" object:nil];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    self.trainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(trainTimerCount) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.trainTimer forMode:NSRunLoopCommonModes];
    
}
#pragma -- mark 训练计时器
- (void)trainTimerCount {
    self.trainMouse ++;
}

#pragma -- mark 计时
- (void)timerStart {
    self.mouse ++;
    NSDictionary *dic = self.baseArr[self.index];
    NSInteger minute = [checkSafeContent(dic[@"time"]) integerValue];
    if (self.mouse > minute*60) {
        [self pauseTimer];
    } else {
        self.timeL.text = [ZCDataTool convertMouseToTimeString:minute*60-self.mouse];
        [self.rateArr addObject:checkSafeContent(self.currentRate)];
    }
}
#pragma -- mark 心率返回
- (void)heartRateCount:(NSNotification *)noti {
    NSString *count = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.heartView.count = count;
        self.currentRate = count;
    });
}
#pragma -- mark 个数返回
- (void)sportNumCount:(NSNotification *)noti {
    NSString *num = noti.object;
    self.trainCount = num;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.baseView.num = num;
    });
}
#pragma -- mark 下一组设置
- (void)nextSportMode {
    
    //暂停计时器
    [self pauseTimer];
    [self pauseTrainTimer];
    
    NSDictionary *dic = self.baseArr[self.index];
    [self.countTrainArr replaceObjectAtIndex:self.index withObject:checkSafeContent(dic[@"num"])];
    [self.countTrainTimeArr replaceObjectAtIndex:self.index withObject:[NSString stringWithFormat:@"%tu", self.trainMouse]];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = kUserStore.userData;
        CGFloat weight = [checkSafeContent(dic[@"weight"]) doubleValue];
        self.baseView.calorie = 7.3*weight*self.mouse/60.0/1000.0;
    });
    if (self.index + 1 < self.baseArr.count) {//    设置下一组
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.nextView.hidden = NO;
            self.completeView.hidden = NO;
            self.nextView.dataDic = self.baseArr[self.index+1];
        });
    } else {//训练完成
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *temArr = [NSMutableArray array];
            for (int i = 0; i < self.baseArr.count; i ++) {
                NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:self.baseArr[i]];
                [temDic setValue:checkSafeContent(self.countTrainArr[i]) forKey:@"trainCount"];
                [temDic setValue:checkSafeContent(self.countTrainTimeArr[i]) forKey:@"trainTime"];
                [temArr addObject:temDic];
            }
            [self stopConnect];
            [HCRouter router:@"SuitTrainFinish" params:@{@"data":temArr, @"rate":self.rateArr} viewController:self animated:YES];
        });
    }
}

- (void)stopConnect {
    [[BLESuitServer defaultBLEServer] stopScan];
    [[BLESuitServer defaultBLEServer] disConnect];
//    [BLESuitServer defaultBLEServer].selectPeripheral = nil;
}

#pragma -- mark 设置运动模式数据
- (void)setupBluDataWithIndex:(NSInteger)index {
    NSDictionary *dic = self.baseArr[index];
    self.targetL.text = [ZCBluthDataTool convertSuitNameWithMode:checkSafeContent(dic[@"mode"])];
    self.mouse = 0;
    self.trainCount = 0;
    self.trainMouse = 0;
    
    [[BLESuitServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool setSuitSportMode:checkSafeContent(dic[@"mode"])] forCharacteristic:[BLESuitServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    [[BLESuitServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool setSuitNumMode:checkSafeContent(dic[@"num"])] forCharacteristic:[BLESuitServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[BLESuitServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool setSuitSportState:@"1"] forCharacteristic:[BLESuitServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    });
}

#pragma -- mark 操作类型
- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:@"next"]) {
        self.nextView.hidden = YES;
        self.completeView.hidden = YES;
        self.baseView.num = @"0";
        //设置下一组模式
        self.index ++;
        [self setupBluDataWithIndex:self.index];
        
        //开启计时器
        [self continueTimer];
        [self continueTrainTimer];
    }
}

#pragma -- mark 暂停
//暂停定时器(只是暂停,并没有销毁timer)
-(void)pauseTimer {
    [self.timer setFireDate:[NSDate distantFuture]];
}
#pragma -- mark 继续
-(void)continueTimer {
    [self.timer setFireDate:[NSDate distantPast]];
}

//暂停定时器(只是暂停,并没有销毁timer)
-(void)pauseTrainTimer {
    [self.trainTimer setFireDate:[NSDate distantFuture]];
}
#pragma -- mark 继续
-(void)continueTrainTimer {
    [self.trainTimer setFireDate:[NSDate distantPast]];
}

#pragma -- mark 结束
- (void)endSportTrainOperate {
    
    ZCClassTrainOverView *overView = [[ZCClassTrainOverView alloc] init];
    [self.view addSubview:overView];
    [overView showAlertView];
    kweakself(self);
    overView.handleTrainOperate = ^(NSInteger type) {
        if (type == 1) {
            [weakself continueTimer];
        } else {
            [weakself pauseTimer];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        }
    };
    
}
#pragma -- mark 点击操作按钮
#pragma -- mark 运动相关操作
- (void)playOperate:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:
            [self endSportTrainOperate];
            break;
        case 1://前一个动作
        {
            if (self.index == 0) return;
            self.index --;
            [self setupBluDataWithIndex:self.index];
        }
            break;
        case 2://播放/暂停
            if (self.sportState) {
                self.sportState = NO;
                [self pauseTimer];
            } else {
                self.sportState = YES;
                [self continueTimer];
            }
            break;
        case 3://后一个动作
        {
            if (self.index == self.baseArr.count - 1) return;
            [self.countTrainArr replaceObjectAtIndex:self.index withObject:checkSafeContent(self.trainCount)];
            [self.countTrainTimeArr replaceObjectAtIndex:self.index withObject:[NSString stringWithFormat:@"%tu", self.trainMouse]];
            self.index ++;
            [self setupBluDataWithIndex:self.index];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)createBottomOperateView:(UIView *)bottomView {
    CGFloat width = 40;
    CGFloat margin = (SCREEN_W - AUTO_MARGIN(70) - 40*4)/3.0;
    for (int i = 0; i < 4; i ++) {
        UIButton *stopBtn = [[UIButton alloc] init];
        stopBtn.tag = i;
        [bottomView addSubview:stopBtn];
        [stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(width);
            make.centerY.mas_equalTo(bottomView.mas_centerY);
            make.leading.mas_equalTo(bottomView.mas_leading).offset((width + margin)*i);
        }];
        if (i == 2) {
            [stopBtn setImage:kIMAGE(@"train_play_stop") forState:UIControlStateNormal];
            [stopBtn setImage:kIMAGE(@"train_play_stop_sel") forState:UIControlStateSelected];
        } else {
            [stopBtn setImage:kIMAGE(self.imageArr[i]) forState:UIControlStateNormal];
        }
        [stopBtn addTarget:self action:@selector(playOperate:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = @"";
    self.backStyle = UINavBackButtonColorStyleBack;
}

- (NSArray *)imageArr {
    if (!_imageArr) {
        _imageArr = @[@"train_add", @"train_pre", @"train_play_stop", @"train_next"];
    }
    return _imageArr;
}

- (ZCSuitNextTrainView *)nextView {
    if (!_nextView) {
        _nextView = [[ZCSuitNextTrainView alloc] init];
        _nextView.hidden = YES;
        [self.view addSubview:_nextView];
        [_nextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.mas_equalTo(self.view);
        }];
    }
    return _nextView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)countTrainArr {
    if (_countTrainArr == nil) {
        for (int i = 0; i < self.baseArr.count; i ++) {
            _countTrainArr = [NSMutableArray arrayWithObject:@"0"];
        }
    }
    return _countTrainArr;
}

- (NSMutableArray *)countTrainTimeArr {
    if (_countTrainTimeArr == nil) {
        for (int i = 0; i < self.baseArr.count; i ++) {
            _countTrainTimeArr = [NSMutableArray arrayWithObject:@"0"];
        }
    }
    return _countTrainTimeArr;
}

- (NSMutableArray *)rateArr {
    if (_rateArr == nil) {
        _rateArr = [NSMutableArray array];
    }
    return _rateArr;
}

@end

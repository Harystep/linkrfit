//
//  ZCAutoWRCSportTrainController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/21.
//

#import "ZCAutoWRCSportTrainController.h"
#import "ZCCircleDialView.h"
#import "ZCSimpleTimeView.h"
#import "ZCAutoTimerProgressView.h"
#import "ZCAutoTimerOperateView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZCTrainSportDownView.h"
#import "ZCAutoWRCTrainController.h"

@interface ZCAutoWRCSportTrainController ()<AVSpeechSynthesizerDelegate>

@property (nonatomic, strong) AVSpeechSynthesizer *speech;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) ZCCircleDialView *dialView;

@property (nonatomic,strong) UIScrollView *scView;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *contentL;

@property (nonatomic,strong) UILabel *timeL;

@property (nonatomic,strong) ZCAutoTimerProgressView *progessView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,assign) CGFloat totalMouse;//总共时长

@property (nonatomic,assign) NSInteger indexMouse;//当前运动时间

@property (nonatomic,assign) NSInteger currentIndex;//当前所在训练索引

@property (nonatomic,assign) NSInteger currentIndexMouse;//当前训练时间

@property (nonatomic,assign) BOOL signStopFlag;//是否暂停

@property (nonatomic,assign) NSInteger mode;//当前模式

@property (nonatomic,assign) BOOL signChangeStatus;//编辑切换状态

@property (nonatomic,strong) ZCAutoTimerOperateView *operateView;

@property (nonatomic,strong) ZCTrainSportDownView *downView;

@end

@implementation ZCAutoWRCSportTrainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
    
    self.scView = [[UIScrollView alloc] init];
    self.scView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scView];
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom);
    }];
    
    self.contentView = [[UIView alloc] init];
    [self.scView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scView);
        make.width.mas_equalTo(self.scView);
    }];
    
    self.dialView = [[ZCCircleDialView alloc] init];
    [self.contentView addSubview:self.dialView];
    [self.dialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(15));
        make.width.height.mas_equalTo(307);
    }];
    
    
    UILabel *timeL = [self.view createSimpleLabelWithTitle:@"00:00" font:36 bold:YES color:[ZCConfigColor txtColor]];
    self.timeL = timeL;
    [self.contentView addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.dialView.mas_bottom).offset(AUTO_MARGIN(20));
    }];
   
    self.contentL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"训练", nil) font:29 bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(timeL.mas_centerX);
        make.top.mas_equalTo(timeL.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    
    self.progessView = [[ZCAutoTimerProgressView alloc] init];
    [self.contentView addSubview:self.progessView];
    [self.progessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.top.mas_equalTo(self.contentL.mas_bottom).offset(AUTO_MARGIN(40));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(105));
    }];
    
    ZCAutoTimerOperateView *operateView = [[ZCAutoTimerOperateView alloc] init];
    [self.view addSubview:operateView];
    [operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(10));
        make.height.mas_equalTo(AUTO_MARGIN(80));
    }];
    self.operateView = operateView;
 
    [self configureBaseData];
    
    [self.view addSubview:self.downView];
    kweakself(self);
    self.downView.downFunctionFinish = ^{
        [[NSRunLoop currentRunLoop] addTimer:weakself.timer forMode:NSRunLoopCommonModes];
        [weakself playContentVoice:NSLocalizedString(@"训练开始", nil) rate:0.5];
    };
      
    [self addBackgroundNotification];
}

- (void)configureBaseData {
    self.currentIndex = 0;
    [self configureBaseTimeData];
    NSString *content = [ZCDataTool convertMouseToMSTimeString:self.totalMouse];
    self.progessView.timeL.text = content;
    NSDictionary *dic = self.dataArr[0];
    self.timeL.text = [ZCDataTool convertMouseToMSTimeString:[dic[@"time"] integerValue]];
    self.currentIndexMouse = [dic[@"time"] integerValue]*10;
    self.dialView.targetMouse = [dic[@"time"] integerValue]*10;
    self.dialView.circleL.text = [NSString stringWithFormat:@"%d", 1];
    self.operateView.item.selected = YES;
    self.signChangeStatus = NO;
        
}

- (void)appEnterBackground {
    NSLog(@"up - leave");
    self.goBackgroundDate = [NSDate date];
    [self pauseTimer];
}

- (void)appBecomeActive {
    NSLog(@"down - come");
    if (self.signChangeStatus) {
    } else {
        NSTimeInterval  timeGone = [[NSDate date] timeIntervalSinceDate:self.goBackgroundDate];
        NSInteger count = timeGone;
        if (self.currentIndexMouse > count * 10) {
            self.currentIndexMouse = self.currentIndexMouse - count * 10;
            self.indexMouse += count*10;
        } else {
            self.currentIndexMouse = 0;
        }
        self.progessView.progress = self.indexMouse / (self.totalMouse*10);
        [self calculateProgressTime:self.indexMouse];
        self.timeL.text = [ZCDataTool convertMouseToMSTimeString:self.currentIndexMouse/10];
        self.dialView.goBackCount = count*10;
        [self.dialView tick];
        [self continueTimer];
    }
}

//一轮完成
- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if (self.currentIndex == self.dataArr.count - 1) {//运动完成
        [self destroyTimer];
        [self playContentVoice:NSLocalizedString(@"训练已完成", nil) rate:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[ZCAutoWRCTrainController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        });
    } else {
        self.currentIndex ++;
        self.currentIndexMouse = [[self convertDataToString:self.currentIndex] integerValue]*10;
        if (self.mode == 5) {
            self.dialView.circleL.text = [NSString stringWithFormat:@"%tu", self.currentIndex + 1];
        } else {
            NSInteger circle = self.currentIndex / 2;
            self.dialView.circleL.text = [NSString stringWithFormat:@"%tu", circle + 1];
            NSDictionary *dic = self.dataArr[self.currentIndex];
            if ([dic[@"restFlag"] integerValue] == 1) {
                self.contentL.text = NSLocalizedString(@"休息", nil);
                self.dialView.bgColor = rgba(84, 215, 97, 1);
                [self playContentVoice:NSLocalizedString(@"休息", nil) rate:0.5];
            } else {
                self.contentL.text = NSLocalizedString(@"训练", nil);
                self.dialView.bgColor = rgba(255, 138, 59, 1);
                [self playContentVoice:NSLocalizedString(@"训练", nil) rate:0.5];
            }
        }
    }
}

- (NSString *)convertDataToString:(NSInteger)index {
    NSDictionary *dic = self.dataArr[index];
    return dic[@"time"];
}

- (void)routerWithEventName:(NSString *)eventName {
    if ([eventName integerValue] == 1) {//stop
        [self pauseTimer];
        [self resetViewData];
    } else if ([eventName integerValue] == 2) {//start
        if (self.signChangeStatus) {//开始
            self.signChangeStatus = NO;
            self.operateView.item.selected = YES;
            [self continueTimer];
        } else {//暂停
            self.signChangeStatus = YES;
            [self pauseTimer];
            self.operateView.item.selected = NO;
        }
    } else {//exit
        [self destroyTimer];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)resetViewData {
    [self.dialView resetCircleView];
    self.indexMouse = 0;
    self.currentIndex = 0;
    [self configureBaseTimeData];
    NSString *content = [ZCDataTool convertMouseToMSTimeString:self.totalMouse];
    self.progessView.timeL.text = content;
    self.progessView.progress = 0.0;
    NSDictionary *dic = self.dataArr[0];
    self.timeL.text = [ZCDataTool convertMouseToMSTimeString:[dic[@"time"] integerValue]];
    self.currentIndexMouse = [dic[@"time"] integerValue]*10;
    self.dialView.targetMouse = [dic[@"time"] integerValue]*10;
    self.dialView.circleL.text = [NSString stringWithFormat:@"%d", 1];
    self.operateView.item.selected = NO;
    self.signChangeStatus = YES;
    self.contentL.text = NSLocalizedString(@"训练", nil);
    self.dialView.bgColor = rgba(255, 138, 59, 1);
}

- (void)configureBaseTimeData {
    self.totalMouse = 0;
    NSMutableArray *totalArr = [NSMutableArray array];
    NSArray *dataArr = self.params[@"data"];
    for (int i = 0; i < dataArr.count; i ++) {
        NSDictionary *dic = dataArr[i];
        [totalArr addObject:@{@"time":[ZCDataTool convertStringTimeToMouse:dic[@"time"]],
                              @"restFlag":@"0"
        }];
        self.totalMouse += ([[ZCDataTool convertStringTimeToMouse:dic[@"time"]] integerValue] * [self.params[@"circle"] integerValue]);
        if ([[ZCDataTool convertStringTimeToMouse:dic[@"rest"]] integerValue] > 0) {
            [totalArr addObject:@{@"time":[ZCDataTool convertStringTimeToMouse:dic[@"rest"]],
                                  @"restFlag":@"1"
            }];
            self.totalMouse += ([[ZCDataTool convertStringTimeToMouse:dic[@"rest"]] integerValue] * [self.params[@"circle"] integerValue]);
        }
    }
    NSMutableArray *temArr = [NSMutableArray array];
    for (int i = 0; i < [self.params[@"circle"] integerValue]; i ++) {
        [temArr addObjectsFromArray:totalArr];
    }
    self.dataArr = temArr;
}

- (void)startAnimalOperate {
    self.indexMouse ++;
    self.dialView.targetMouse = [[self convertDataToString:self.currentIndex] integerValue]*10;
    [self.dialView startAnimal];
    self.progessView.progress = self.indexMouse / (self.totalMouse*10);
    self.timeL.text = [ZCDataTool convertMouseToMSTimeString:self.currentIndexMouse/10];
    [self calculateProgressTime:self.indexMouse];
    self.currentIndexMouse --;
    if (self.currentIndexMouse == 30 || self.currentIndexMouse == 20 || self.currentIndexMouse == 10) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playContentVoice:[NSString stringWithFormat:@"%tu", self.currentIndexMouse/10] rate:0.6];
        });
    }
}

- (void)calculateProgressTime:(NSInteger)time {
    NSString *content = [ZCDataTool convertMouseToMSTimeString:self.totalMouse-time/10];
    self.progessView.timeL.text = content;
}

- (void)destroyTimer {
    [self.timer invalidate];
    self.timer = nil;
}

//暂停定时器(只是暂停,并没有销毁timer)
-(void)pauseTimer {
    self.signStopFlag = YES;
    [self.timer setFireDate:[NSDate distantFuture]];
}
//继续计时
-(void)continueTimer {
    if (self.signStopFlag) {
        self.signStopFlag = NO;
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = [NSString stringWithFormat:@"%@/WRC", NSLocalizedString(@"在线计时器", nil)];
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.speech = [[AVSpeechSynthesizer alloc] init];
    self.speech.delegate = self;
//    [self playContentVoice:NSLocalizedString(@"运动开始", nil) rate:0.5];
}

#pragma -- mark 播放声音
- (void)playContentVoice:(NSString *)content rate:(CGFloat)rate {
    // 停止播放
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.speech stopSpeakingAtBoundary:AVSpeechBoundaryWord];
        [[AVAudioSession sharedInstance] setActive:YES
                                      withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                            error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 播报内容
            NSString *playStr = content;
            //设置发音，这是中文普通话
            AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
            //需要转换的文字
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:playStr];
            // 设置语速，范围0-1，注意0最慢，1最快；
            utterance.rate  = rate;
            utterance.voice = voice;
            //开始
            [self.speech speakUtterance:utterance];
        });
    });
}
#pragma -- mark 播报完成回调
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self destroyTimer];
    [self removeBackgroundNotification];
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(startAnimalOperate) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


- (ZCTrainSportDownView *)downView {
    if (!_downView) {
        _downView = [[ZCTrainSportDownView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        _downView.backgroundColor = [ZCConfigColor whiteColor];
    }
    return _downView;
}

@end

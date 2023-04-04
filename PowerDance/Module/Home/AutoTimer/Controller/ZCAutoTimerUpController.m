//
//  ZCAutoTimerUpController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/21.
//

#import "ZCAutoTimerUpController.h"
#import "ZCAutoTimerUpTopView.h"
#import "ZCAutoTimerUpStatusView.h"
#import "ZCAutoTimerOperateView.h"
#import "ZCAutoTimerDownSetView.h"
#import <AVFoundation/AVFoundation.h>

@interface ZCAutoTimerUpController ()<AVSpeechSynthesizerDelegate>

@property (nonatomic,strong) UIScrollView *scView;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) ZCAutoTimerUpTopView *topView;

@property (nonatomic,strong) ZCAutoTimerUpStatusView *statusView;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSTimer *mouseTimer;

@property (nonatomic,assign) NSInteger signStopFlag;

@property (nonatomic,assign) NSInteger signUpFlag;

@property (nonatomic,assign) NSInteger mouseIndex;

@property (nonatomic,strong) ZCAutoTimerDownSetView *setView;

@property (nonatomic,assign) NSInteger setTimeMouse;//设置目标时间

@property (nonatomic,assign) NSInteger timeMouse;//剩余时间

@property (nonatomic, strong) AVSpeechSynthesizer *speech;

@property (nonatomic,assign) BOOL signChangeStatus;

@property (nonatomic,strong) ZCAutoTimerOperateView *operateView;

@end

@implementation ZCAutoTimerUpController

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
    
    self.topView = [[ZCAutoTimerUpTopView alloc] init];
    [self.contentView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(20));
    }];
    
    self.statusView = [[ZCAutoTimerUpStatusView alloc] init];
    [self.contentView addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.width.mas_equalTo(AUTO_MARGIN(200));
        make.height.mas_equalTo(AUTO_MARGIN(55));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(100));
    }];
    
    ZCAutoTimerOperateView *operateView = [[ZCAutoTimerOperateView alloc] init];
    [self.view addSubview:operateView];
    [operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(10));
        make.height.mas_equalTo(AUTO_MARGIN(80));
    }];
    self.operateView = operateView;
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:@"status"]) {
        [self destroyTimer];
        [self clearSaveData];
        [self.topView.dialView resetCircleView];
        self.topView.timeL.text = @"00:00";
        self.signChangeStatus = YES;
        self.operateView.item.selected = NO;
        if ([userInfo[@"index"] integerValue] == 1) {
            self.signUpFlag = NO;
            [self.view addSubview:self.maskBtn];
            [self.view addSubview:self.setView];
            self.maskBtn.hidden = NO;
            self.topView.dialView.clockFlag = NO;
            self.titleStr = [NSString stringWithFormat:@"%@/%@", NSLocalizedString(@"在线计时器", nil), NSLocalizedString(@"倒计时", nil)];
            kweakself(self);
            self.setView.saveBownTimeOperate = ^(NSString * _Nonnull time) {
                weakself.topView.timeL.text = time;
                weakself.setTimeMouse = [[ZCDataTool convertStringTimeToMouse:time] integerValue];
                weakself.timeMouse = [[ZCDataTool convertStringTimeToMouse:time] integerValue];
                [weakself maskSaveData];
                
            };
        } else {
            self.titleStr = [NSString stringWithFormat:@"%@/%@", NSLocalizedString(@"在线计时器", nil), NSLocalizedString(@"计时", nil)];
            self.signUpFlag = YES;
            self.topView.dialView.clockFlag = YES;
        }
    } else {
        [self destroyTimer];
        [self playContentVoice:NSLocalizedString(@"计时已结束", nil) rate:0.5];
        self.topView.timeL.text = @"00:00";
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        });
    }
}

- (void)maskSaveData {
    self.setView.hidden = YES;
    [self.setView removeFromSuperview];
    self.setView = nil;
    self.maskBtn.hidden = YES;
}

- (void)maskBtnClick {
    [self clearSaveData];
    [self maskSaveData];
}

- (void)clearSaveData {
    self.mouseIndex = 0;
    self.setTimeMouse = 0;
    self.timeMouse = 0;
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
    [self.topView.dialView resetCircleView];
    self.mouseIndex = 0;
    self.timeMouse = self.setTimeMouse;
    if (self.signUpFlag) {
        self.topView.timeL.text = [ZCDataTool convertMouseToMSTimeString:self.mouseIndex];
    } else {
        self.topView.timeL.text = [ZCDataTool convertMouseToMSTimeString:self.timeMouse];
        self.timeMouse --;
        self.topView.dialView.targetMouse = self.setTimeMouse;
    }
    self.signChangeStatus = YES;
    self.operateView.item.selected = NO;
}

- (void)startAnimalOperate {
    self.mouseIndex ++;
    if (self.signUpFlag) {
        self.topView.dialView.targetMouse = 60;
        [self.topView.dialView startAnimal];
        self.topView.timeL.text = [ZCDataTool convertMouseToMSTimeString:self.mouseIndex];
    } else {
        self.topView.timeL.text = [ZCDataTool convertMouseToMSTimeString:self.timeMouse];
        self.timeMouse --;
        self.topView.dialView.targetMouse = self.setTimeMouse;
        [self.topView.dialView startAnimal];
    }
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = [NSString stringWithFormat:@"%@/%@", NSLocalizedString(@"在线计时器", nil), NSLocalizedString(@"计时", nil)];
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.signUpFlag = YES;
    self.speech = [[AVSpeechSynthesizer alloc] init];
    self.speech.delegate = self;
    self.signChangeStatus = YES;
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
    if (self.signUpFlag) {
        NSLog(@"start");
        if (self.signStopFlag) {
            self.signStopFlag = NO;
            [self.timer setFireDate:[NSDate distantPast]];
        } else {
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//            [self startAnimalOperate];
        }
    } else {
        if (self.setTimeMouse > 0) {
            if (self.signStopFlag) {
                self.signStopFlag = NO;
                [self.timer setFireDate:[NSDate distantPast]];
            } else {
                [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
                [self startAnimalOperate];
            }
        }
    }
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
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startAnimalOperate) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (ZCAutoTimerDownSetView *)setView {
    if (!_setView) {
        _setView = [[ZCAutoTimerDownSetView alloc] init];
        _setView.frame = CGRectMake((SCREEN_W - AUTO_MARGIN(291))/2.0, AUTO_MARGIN(230), AUTO_MARGIN(291), AUTO_MARGIN(240));
    }
    return _setView;
}

@end

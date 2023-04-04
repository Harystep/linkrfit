//
//  ZCAutoTimerDownController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/24.
//

#import "ZCAutoTimerDownController.h"
#import "ZCAutoTimerUpTopView.h"
#import "ZCAutoTimerUpStatusView.h"
#import "ZCAutoTimerOperateView.h"
#import "ZCAutoTimerDownSetView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZCAutoTimerOperateTimeView.h"
#import "ZCAutoTimerSetTimeView.h"
#import "ZCAlertTimePickView.h"

@interface ZCAutoTimerDownController ()<AVSpeechSynthesizerDelegate>

@property (nonatomic,strong) UIScrollView *scView;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) ZCAutoTimerUpTopView *topView;

@property (nonatomic,strong) ZCAutoTimerUpStatusView *statusView;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSTimer *mouseTimer;

@property (nonatomic,assign) NSInteger signStopFlag;

@property (nonatomic,assign) NSInteger signUpFlag;

@property (nonatomic,strong) ZCAutoTimerDownSetView *setView;

@property (nonatomic,assign) NSInteger setTimeMouse;//设置目标时间

@property (nonatomic,assign) NSInteger timeMouse;//剩余时间

@property (nonatomic, strong) AVSpeechSynthesizer *speech;

@property (nonatomic,assign) BOOL signChangeStatus;

@property (nonatomic,strong) ZCAutoTimerOperateTimeView *operateView;

@property (nonatomic,strong) ZCAutoTimerSetTimeView *setTimeView;

/// 标记计时开始
@property (nonatomic,assign) NSInteger signTimeFlag;

@end

@implementation ZCAutoTimerDownController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addBackgroundNotification];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self destroyTimer];
}

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
    self.topView.dialView.clockFlag = NO;
    
    self.operateView = [[ZCAutoTimerOperateTimeView alloc] init];
    [self.contentView addSubview:self.operateView];
    [self.operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(80));
        make.top.mas_equalTo(self.topView.mas_bottom);
    }];

    self.setTimeView = [[ZCAutoTimerSetTimeView alloc] init];
    [self.contentView addSubview:self.setTimeView];
    [self.setTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.operateView.mas_bottom).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(90));
        make.width.mas_equalTo(AUTO_MARGIN(255));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(TAB_BAR_HEIGHT));
    }];
    [self.setTimeView setViewCornerRadiu:AUTO_MARGIN(10)];
    
}

- (void)appEnterBackground {
    NSLog(@"down - leave");
    self.goBackgroundDate = [NSDate date];
    NSLog(@"leaveTime:%@", self.goBackgroundDate);
    [self pauseTimer];
}

- (void)appBecomeActive {
    NSLog(@"down - come");
    if (self.signEndFlag) {
        
    } else {
        NSTimeInterval  timeGone = [[NSDate date] timeIntervalSinceDate:self.goBackgroundDate];
        NSInteger count = timeGone;
        if (self.timeMouse > count * 10) {
            self.timeMouse = self.timeMouse - count * 10;
        } else {
            self.timeMouse = 0;
        }
        self.setTimeView.timeL.text = [ZCDataTool convertMouseToTimeString:self.timeMouse/10];
        self.topView.dialView.goBackCount = count*10.0;
        [self.topView.dialView tick];
        [self continueTimer];
    }
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo block:(void (^)(id _Nonnull))block {
    self.signTimeFlag = YES;
    if ([eventName isEqualToString:@"start"]) {
        if (self.setTimeMouse == 0) {
            self.signTimeFlag = NO;
            [self.view makeToast:NSLocalizedString(@"请设置倒计时时间", nil) duration:2.0 position:CSToastPositionCenter];
            block(@"");
            return;
        }
        if ([userInfo[@"status"] boolValue]) {
            [self continueTimer];
        } else {
            self.signEndFlag = YES;
            [self pauseTimer];
        }
    } else if ([eventName isEqualToString:@"cancel"]) {
        if (self.signTimeFlag) {            
            self.signTimeFlag = NO;
            [self pauseTimer];
            self.signEndFlag = YES;
            [self resetViewData];
        }
    }
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:@"time"]) {
        if (self.signTimeFlag) {
        } else {
            [self timeViewOperate];
        }
    } else {
        [self destroyTimer];
        [self playContentVoice:NSLocalizedString(@"计时已结束", nil) rate:0.5];
        self.setTimeView.timeL.text = [ZCDataTool convertMouseToTimeString:self.setTimeMouse/10];
        self.signTimeFlag = NO;
    }
}

#pragma -- mark 点击时间
- (void)timeViewOperate {
    ZCAlertTimePickView *pick = [[ZCAlertTimePickView alloc] init];
    [self.view addSubview:pick];
    [pick showAlertView];
    pick.titleL.text = NSLocalizedString(@"设置倒计时时间", nil);
    kweakself(self);
    pick.sureRepeatOperate = ^(NSString * _Nonnull content) {
        [weakself destroyTimer];
        [weakself clearSaveData];
        [weakself.topView.dialView resetCircleView];
        weakself.setTimeView.timeL.text = content;
        weakself.setTimeMouse = [[ZCDataTool convertStringTimeToMouse:content] integerValue]*10;
        weakself.timeMouse = [[ZCDataTool convertStringTimeToMouse:content] integerValue]*10;
        weakself.topView.dialView.targetMouse = self.setTimeMouse;
        [weakself maskSaveData];
    };
}

- (void)maskSaveData {
    self.setView.hidden = YES;
    [self.setView removeFromSuperview];
    self.setView = nil;
    self.maskBtn.hidden = YES;
}

- (void)maskBtnClick {
    [self maskSaveData];
}

- (void)clearSaveData {
    self.setTimeMouse = 0;
    self.timeMouse = 0;
}

- (void)resetViewData {
    [self.topView.dialView resetCircleView];
    self.setTimeMouse = 0;
    self.timeMouse = self.setTimeMouse;
    self.setTimeView.timeL.text = @"00:00:00";
    self.signChangeStatus = YES;
}

- (void)startAnimalOperate {
    self.setTimeView.timeL.text = [ZCDataTool convertMouseToTimeString:self.timeMouse/10];
    self.timeMouse --;
    [self.topView.dialView startAnimal];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.signEndFlag = YES;
    self.titleStr = [NSString stringWithFormat:@"%@/%@", NSLocalizedString(@"在线计时器", nil), NSLocalizedString(@"倒计时", nil)];
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.signUpFlag = NO;
    self.speech = [[AVSpeechSynthesizer alloc] init];
    self.speech.delegate = self;
    self.signChangeStatus = YES;
}

- (void)destroyTimer {
//    [self removeBackgroundNotification];
    [self.operateView resetSubviews];
    [self.timer invalidate];
    self.timer = nil;
    self.signEndFlag = YES;
}

//暂停定时器(只是暂停,并没有销毁timer)
-(void)pauseTimer {
    self.signStopFlag = YES;
    [self.timer setFireDate:[NSDate distantFuture]];
}
//继续计时
-(void)continueTimer {
    self.signEndFlag = NO;
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

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(startAnimalOperate) userInfo:nil repeats:YES];
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

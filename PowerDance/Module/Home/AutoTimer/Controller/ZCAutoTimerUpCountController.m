//
//  ZCAutoTimerUpCountController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/24.
//

#import "ZCAutoTimerUpCountController.h"
#import "ZCAutoTimerUpTopView.h"
#import "ZCAutoTimerUpStatusView.h"
#import "ZCAutoTimerOperateView.h"
#import "ZCAutoTimerDownSetView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZCAutoTimerOperateTimeView.h"
#import "ZCAutoTimerSetTimeView.h"
#import "ZCAlertTimePickView.h"

@interface ZCAutoTimerUpCountController ()<AVSpeechSynthesizerDelegate>

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

@property (nonatomic, strong) AVSpeechSynthesizer *speech;

@property (nonatomic,strong) ZCAutoTimerOperateTimeView *operateView;

@property (nonatomic,strong) ZCAutoTimerSetTimeView *setTimeView;

/// 标记计时开始
@property (nonatomic,assign) NSInteger signTimeFlag;

@end

@implementation ZCAutoTimerUpCountController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self destroyTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addBackgroundNotification];
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
    NSLog(@"up - leave");
    self.goBackgroundDate = [NSDate date];
    [self pauseTimer];
}

- (void)appBecomeActive {
    NSLog(@"up - come");
    if (self.signEndFlag) {
        
    } else {
        NSTimeInterval  timeGone = [[NSDate date] timeIntervalSinceDate:self.goBackgroundDate];
        double count = timeGone;
        self.mouseIndex = self.mouseIndex + count * 10;
        if (self.setTimeMouse > 0) {
            if (self.mouseIndex + count * 10 >= self.setTimeMouse) {
                [self cancelTimerOperate];
            } else {                
                NSLog(@"%tu", self.mouseIndex);
                self.setTimeView.timeL.text = [ZCDataTool convertMouseToTimeString:self.mouseIndex/10];
                self.topView.dialView.goBackCount = count*10.0;
                [self.topView.dialView tick];
                
                [self continueTimer];
            }
        } else {
            self.setTimeView.timeL.text = [ZCDataTool convertMouseToTimeString:self.mouseIndex/10];
            self.topView.dialView.backMouseIndex = count*10.0;
            [self continueTimer];
        }
    }
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo block:(void (^)(id _Nonnull))block {
    self.signTimeFlag = YES;
    if ([eventName isEqualToString:@"start"]) {
        if ([userInfo[@"status"] boolValue]) {
            [self continueTimer];
        } else {
            [self pauseTimer];
            self.signEndFlag = YES;
        }
    } else if ([eventName isEqualToString:@"cancel"]) {
        if (self.signTimeFlag) {
            [self cancelTimerOperate];
        }
    }
}
#pragma -- mark 计时完成/取消计时
- (void)cancelTimerOperate {
    [self.topView.dialView resetCircleView];
    self.signTimeFlag = NO;
    [self destroyTimer];
    self.signEndFlag = YES;
    self.setTimeView.timeL.text = [ZCDataTool convertMouseToTimeString:self.setTimeMouse/10];
    self.mouseIndex = 0;
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:@"time"]) {
        if (self.signTimeFlag) {
        } else {
            [self timeViewOperate];
        }
    } else {
        self.signTimeFlag = NO;
        [self destroyTimer];
        self.signEndFlag = YES;
        self.mouseIndex = 0;
        [self playContentVoice:NSLocalizedString(@"计时已结束", nil) rate:0.5];        
    }
}

#pragma -- mark 点击时间
- (void)timeViewOperate {
    ZCAlertTimePickView *pick = [[ZCAlertTimePickView alloc] init];
    [self.view addSubview:pick];
    [pick showAlertView];
    pick.titleL.text = NSLocalizedString(@"设置正计时时间", nil);
    kweakself(self);
    pick.sureRepeatOperate = ^(NSString * _Nonnull content) {
        [weakself destroyTimer];
        [weakself clearSaveData];
        [weakself.topView.dialView resetCircleView];
        weakself.setTimeView.timeL.text = content;
        weakself.setTimeMouse = [[ZCDataTool convertStringTimeToMouse:content] integerValue]*10;
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
    self.mouseIndex = 0;
    self.setTimeMouse = 0;
    
}

- (void)resetViewData {
    [self.topView.dialView resetCircleView];
    self.mouseIndex = 0;
    self.setTimeMouse = 0;
    self.setTimeView.timeL.text = @"00:00:00";
    
}

- (void)startAnimalOperate {
    self.mouseIndex ++;
    if (self.setTimeMouse > 0) {
        self.topView.dialView.targetMouse = self.setTimeMouse;
        [self.topView.dialView startAnimal];
    } else {
        [self.topView.dialView tick];
    }
    self.setTimeView.timeL.text = [ZCDataTool convertMouseToTimeString:self.mouseIndex/10];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = [NSString stringWithFormat:@"%@/%@", NSLocalizedString(@"在线计时器", nil), NSLocalizedString(@"计时", nil)];
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.signUpFlag = YES;
    self.speech = [[AVSpeechSynthesizer alloc] init];
    self.speech.delegate = self;
    self.signEndFlag = YES;
}

- (void)destroyTimer {
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
    if (self.signStopFlag) {
        self.signStopFlag = NO;
        [self.timer setFireDate:[NSDate distantPast]];
    } else {
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
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

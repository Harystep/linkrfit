//
//  ZCClassPlayController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/25.
//

#import "ZCClassPlayController.h"
#import "ZCClassPlayBottomView.h"
#import "ZCBasePlayVideoView.h"
#import "ZCPhotoManage.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ZCClassPlayPauseView.h"
#import "ZCClassPlayNextView.h"
#import "ZCClassTrainOverView.h"
#import "ZCCurrentActionInfoView.h"
#import "ZCClassPlayRestView.h"

#define kRestColor @"#4CD995"

@interface ZCClassPlayController ()<AVSpeechSynthesizerDelegate>

@property (nonatomic,strong) UIScrollView *scView;
@property (nonatomic,strong) UIView       *contentView;
@property (nonatomic, strong) AVSpeechSynthesizer *speech;
@property (nonatomic,strong) UILabel *mouseL;
@property (nonatomic,strong) UILabel *targetTitleL;
@property (nonatomic,strong) ZCBasePlayVideoView *playView;
@property (nonatomic,strong) ZCClassPlayBottomView *bottomView;
@property (nonatomic,strong) NSArray *urlArr;
@property (nonatomic,assign) NSInteger index;//下载索引
@property (nonatomic,assign) NSInteger playIndex;//播放索引
@property (nonatomic,strong) NSMutableArray *videoUrlArr;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger mouse;//当次运动剩余时间
@property (nonatomic,assign) NSInteger targetMouse;//当前目标时间
@property (nonatomic,assign) NSInteger targetIndex;//当前已经运动时间
@property (nonatomic,strong) ZCClassPlayPauseView *pauseView;
@property (nonatomic,strong) UILabel *textL;
@property (nonatomic,assign) NSInteger signFirstFlag;//标记第一次播报
@property (nonatomic,strong) ZCClassPlayNextView *nextView;
@property (nonatomic,strong) ZCCurrentActionInfoView *infoView;
@property (nonatomic,strong) ZCClassPlayRestView *restView;
@property (nonatomic,assign) NSInteger totalTime;//训练所需时间
@property (nonatomic,assign) NSInteger signCurrentVoiceFlag;//标记当前正在语音
@property (nonatomic,assign) NSInteger mouseIndex;//运动时间
@property (nonatomic,strong) ZCClassTrainOverView *overView;
@property (nonatomic,assign) NSInteger signFinishFlag;//标记训练已结束
@property (nonatomic,strong) NSArray *actionArr;
@property (nonatomic,assign) NSInteger currentTargetIndex;//当前动作索引
@property (nonatomic,strong) UILabel *nextCurrentL;
@property (nonatomic,strong) UIView *coverView;

@end

@implementation ZCClassPlayController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //禁用右滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
    
    [self setupSubviews];
    
    [self configureBaseData];
}

- (void)configureBaseData {
    NSDictionary *dic = self.videoUrlArr[0];
    self.currentTargetIndex = 1;
    self.signFirstFlag = YES;
    self.targetMouse = [dic[@"time"] integerValue];
    [self playContentVoice:dic[@"name"]];
    [self showNextView:dic firstSign:YES];
    NSMutableArray *temArr = [NSMutableArray array];
    for (NSDictionary *dic in self.videoUrlArr) {
        self.totalTime += [dic[@"time"] integerValue];
        if ([dic[@"rest"] integerValue] == 0) {
            [temArr addObject:dic];
        }
    }
    self.playView.mp4_url = dic[@"url"];
    self.actionArr = temArr;
    self.targetTitleL.text = [NSString stringWithFormat:@"%tu/%tu %@", self.currentTargetIndex, self.actionArr.count, dic[@"name"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showNextViewHide];
    });        
    
}

- (void)configureBaseInfo {
    self.index = 0;
    self.playIndex = 0;
    self.speech = [[AVSpeechSynthesizer alloc] init];
    self.speech.delegate = self;
    [self addBackgroundNotification];
}

- (void)appBecomeActive {
    if (self.pauseView.hidden == YES) {
        [self.playView play];
        [self continueTimer];
    }
}
    
 - (void)appEnterBackground {
     [self.playView pause];
     [self pauseTimer];
 }
    
    
- (void)setupSubviews {
    self.view.backgroundColor = [ZCConfigColor whiteColor];
    self.scView = [[UIScrollView alloc] init];
    if (@available(iOS 11.0, *)) {
        self.scView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets      = NO;
    }
    self.scView.showsVerticalScrollIndicator = NO;
    self.scView.bounces = NO;
    [self.view addSubview:self.scView];
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.contentView = [[UIView alloc] init];
    [self.scView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scView);
        make.width.mas_equalTo(self.scView);
    }];
    
    UIView *topView = [self createTopView];
    UIView *playView = [[ZCBasePlayVideoView alloc] init];
    playView.backgroundColor = [ZCConfigColor whiteColor];
    [self.contentView addSubview:playView];
    
    [playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom);
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(490));
    }];
    self.videoUrlArr = self.params[@"data"];
    self.playView = [[ZCBasePlayVideoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(490))];
    self.playView.player.smallControlView.hidden = YES;
    [playView addSubview:self.playView];
                
    [self.playView addSubview:self.textL];
    [self.textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.playView.mas_centerX);
        make.centerY.mas_equalTo(self.playView.mas_centerY);
    }];
    
    self.coverView = [[UIView alloc] init];
    self.coverView.backgroundColor = [ZCConfigColor whiteColor];
    [self.playView addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.playView);
    }];
    self.coverView.backgroundColor = rgba(255, 255, 255, 0);
    
    [self.coverView addSubview:self.nextView];
    [self.nextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.coverView);
    }];
       
    [self.coverView addSubview:self.restView];
    [self.restView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.coverView);
    }];
    
    [self createBottomView];
    
    [self.contentView addSubview:self.nextCurrentL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repeatPlay) name:kPlayVideoFinishKey object:nil];
}

- (void)setupCoverViewStatus:(CGFloat)alpha {
    self.coverView.backgroundColor = rgba(255, 255, 255, alpha);
//    if (alpha == 1) {
//        self.restView.hidden = NO;
//        self.nextView.hidden = NO;
//    } else {
//        self.nextView.hidden = NO;
//    }
}

- (void)repeatPlay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.playView play];
    });
}

- (void)playFinishOperate {
    self.playIndex ++;
    if (self.playIndex >= self.videoUrlArr.count) {
        //视频播放完成
        [self.playView pause];
        [self pauseTimer];
        self.signFinishFlag = YES;
        self.view.userInteractionEnabled = NO;
        [self playContentVoice:NSLocalizedString(@"训练已完成", nil)];
    } else {
        NSLog(@"111111111111");
        [self showNextViewHide];
        NSDictionary *dic = self.videoUrlArr[self.playIndex];
        NSString *pathStr = dic[@"url"];
        self.textL.hidden = YES;
        if ([dic[@"rest"] integerValue] == 1) {
            [self setCircleProgressColorWithRestStatus:YES];
            [self resetSmallCircleView];
            [self configureNextPlayView];
            self.targetTitleL.text = [NSString stringWithFormat:@"%tu/%tu %@", self.currentTargetIndex, self.actionArr.count, dic[@"name"]];
            [self setupMouseContent:[dic[@"time"] integerValue]];
            [self.playView pause];
            [self showRestAlertView];
            [self setupCoverViewStatus:1];
        } else {
            [self setupCoverViewStatus:0];
            self.restView.hidden = YES;
            [self setCircleProgressColorWithRestStatus:NO];
            [self resetSmallCircleView];
            [self configureNextPlayView];
            if ([dic[@"rest"] integerValue] == 0) {
                self.playView.mp4_url = pathStr;
                self.currentTargetIndex ++;
            }
            self.targetTitleL.text = [NSString stringWithFormat:@"%tu/%tu %@", self.currentTargetIndex, self.actionArr.count, dic[@"name"]];
            [self setupMouseContent:[dic[@"time"] integerValue]];
            [self.playView pause];
            [self pauseTimer];
        }

        [self continueTimer];
    }
}
#pragma -- mark 显示休息视图
- (void)showRestAlertView {
    self.restView.hidden = NO;
    if (self.playIndex+1 < self.videoUrlArr.count) {
        NSDictionary *nextDic = self.videoUrlArr[self.playIndex+1];
        [self showNextView:nextDic firstSign:NO];
    }
}

- (void)setCircleProgressColorWithRestStatus:(BOOL)status {
    if (status) {
        self.bottomView.bigView.progressColor = kColorHex(kRestColor);
        self.bottomView.smallView.progressColor = kColorHex(kRestColor);
    } else {
        self.bottomView.bigView.progressColor = rgba(250, 106, 2, 1);
        self.bottomView.smallView.progressColor = rgba(250, 106, 2, 1);
    }
}

- (void)playSourceVideo {
    if (self.playIndex >= self.videoUrlArr.count)return;
    NSDictionary *dic = self.videoUrlArr[self.playIndex];
    NSString *pathStr = dic[@"url"];
    BOOL flag = YES;
    if ([dic[@"rest"] integerValue] == 1) {
        flag = YES;
        [self setCircleProgressColorWithRestStatus:YES];
    } else {
        flag = NO;
        [self setCircleProgressColorWithRestStatus:NO];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.textL.hidden = YES;
        [self resetSmallCircleView];
        [self configureNextPlayView];
        if (flag == NO) {
            self.playView.mp4_url = pathStr;
            [self.playView play];
        }
        [self setupMouseContent:[dic[@"time"] integerValue]];
        [self continueTimer];
    });
}

- (void)setupMouseContent:(NSInteger)mouse {
    self.mouse = mouse;
    self.targetIndex = 0;
    self.targetMouse = mouse;
    self.mouseL.text = [ZCDataTool convertMouseToMSTimeString:mouse];
    NSDictionary *tem = self.videoUrlArr[self.playIndex];
    if ([tem[@"rest"] integerValue] == 1) {
        self.restView.timeL.text = [ZCDataTool convertMouseToMSTimeString:self.mouse];
    }
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:@"play"]) {
        if ([userInfo[@"status"] integerValue] == 1) {//暂停
            [self.playView pause];
            [self pauseTimer];
            [self.view addSubview:self.pauseView];
            self.pauseView.hidden = NO;
            NSDictionary *dic = self.videoUrlArr[self.playIndex];
            if ([dic[@"rest"] integerValue] == 0) {
                [self.view addSubview:self.infoView];
                self.infoView.nameL.text = checkSafeContent(dic[@"name"]);
                self.infoView.hidden = NO;
            }
        }
    } else if ([eventName isEqualToString:@"order"]) {
        if ([userInfo[@"status"] integerValue] == 1) {//下一个
            if (self.playIndex >= self.videoUrlArr.count - 1) {
                return;
            }
            [self pauseTimer];
            self.playIndex ++;
            [self playSourceVideo];
            [self playNextVideo];
        } else {//上一个
            if (self.playIndex <= 0) {
                return;
            }
            [self pauseTimer];
            self.playIndex --;
            [self playSourceVideo];
            [self playPreVideo];
        }
    } else if([eventName isEqualToString:@"pause"]) {
        if ([userInfo[@"index"] integerValue] == 1) {//播放
            [self.playView play];
            [self continueTimer];
            self.pauseView.hidden = YES;
            self.infoView.hidden = YES;
        } else {//结束播放
            if (self.signCurrentVoiceFlag) {
                //如果当前正在语音播报，禁止退出
            } else {
                ZCClassTrainOverView *overView = [[ZCClassTrainOverView alloc] init];
                [self.view addSubview:overView];
                [overView showAlertView];
                kweakself(self);
                overView.handleTrainOperate = ^(NSInteger type) {
                    if (type == 1) {
                        [weakself.playView play];
                        [weakself continueTimer];
                        weakself.pauseView.hidden = YES;
                        weakself.infoView.hidden = YES;
                    } else {
                        if (weakself.signCurrentVoiceFlag) {
                            //如果当前正在语音播报，禁止退出
                        } else {
                            [weakself destoryTimer];
                            [weakself.playView pause];
                            [self recordCourseInfo];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [weakself.navigationController popViewControllerAnimated:YES];
                            });
                            
                        }
                    }
                };
            }
        }
    } else if ([eventName isEqualToString:@"actionDetail"]) {
        NSDictionary *dic = self.videoUrlArr[self.playIndex];
        [HCRouter router:@"ActionDetail" params:dic viewController:self animated:YES];
    } else if ([eventName isEqualToString:@"restPass"]) {//下一个
        if (self.playIndex >= self.videoUrlArr.count - 1) {
            self.signFinishFlag = NO;
            [self.playView pause];
            [self destoryTimer];
            [self recordCourseInfo];
            [HCRouter router:@"ClassPlayFinish" params:@{@"data":self.params[@"title"]} viewController:self animated:YES];
        } else {
            self.restView.hidden = YES;
            [self showNextViewHide];
            [self pauseTimer];
            self.playIndex ++;
            [self playSourceVideo];
            [self playNextVideo];
        }
    }
}
- (void)createBottomView {
    self.bottomView = [[ZCClassPlayBottomView alloc] init];
    [self.contentView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AUTO_MARGIN(212));
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.playView.mas_bottom);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

- (UIView *)createTopView {
    UIView *topView = [[UIView alloc] init];
    [self.contentView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(STATUS_BAR_HEIGHT);
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(66));
    }];
    
    self.mouseL = [self.view createSimpleLabelWithTitle:@"" font:20 bold:YES color:[ZCConfigColor txtColor]];
    [topView addSubview:self.mouseL];
    [self.mouseL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topView.mas_centerY);
        make.leading.mas_equalTo(topView.mas_leading).offset(AUTO_MARGIN(20));
    }];
    NSDictionary *dataDic = self.params[@"title"];
    NSString *title = dataDic[@"title"];
    self.targetTitleL = [self.view createSimpleLabelWithTitle:title font:20 bold:YES color:[ZCConfigColor txtColor]];
    [topView addSubview:self.targetTitleL];
    [self.targetTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topView.mas_centerY);
        make.trailing.mas_equalTo(topView.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    
    return topView;
}

- (void)playPreVideo {
    self.textL.hidden = YES;
    self.targetIndex = 0;
    [self resetSmallCircleView];
    [self.bottomView.bigView resetLayoutSubviews];
    self.restView.hidden = YES;
    [self showNextViewHide];
    if (!self.bottomView.trainNextBtn.enabled) {
        self.bottomView.trainNextBtn.enabled = YES;
    }
    if (self.playIndex == 0) {
        self.bottomView.trainPreBtn.enabled = NO;
    }
    [self setBigCircleColor:self.playIndex];
    NSDictionary *dic = self.videoUrlArr[self.playIndex];
    if ([dic[@"rest"] integerValue] == 0) {
        [self setupCoverViewStatus:0];
        if (self.currentTargetIndex > 1) {
            self.currentTargetIndex --;
        }
        [self setCircleProgressColorWithRestStatus:NO];
    } else {
        [self setCircleProgressColorWithRestStatus:YES];
        [self setupCoverViewStatus:1];
        self.restView.hidden = NO;
        [self showRestAlertView];
    }
    self.targetTitleL.text = [NSString stringWithFormat:@"%tu/%tu %@", self.currentTargetIndex, self.actionArr.count, dic[@"name"]];
    [self playContentVoice:dic[@"name"]];
}

- (void)playNextVideo {
    self.textL.hidden = YES;
    self.targetIndex = 0;
    [self resetSmallCircleView];
    [self.bottomView.bigView resetLayoutSubviews];
    [self setBigCircleColor:self.playIndex];
    self.restView.hidden = YES;
    [self showNextViewHide];
    NSDictionary *dic = self.videoUrlArr[self.playIndex];
    if ([dic[@"rest"] integerValue] == 0) {
        [self setCircleProgressColorWithRestStatus:NO];
        [self setupCoverViewStatus:0];
        self.currentTargetIndex ++;
    } else {
        [self setCircleProgressColorWithRestStatus:YES];
        [self setupCoverViewStatus:1];
        self.restView.hidden = NO;
        [self showRestAlertView];
    }
    self.targetTitleL.text = [NSString stringWithFormat:@"%tu/%tu %@", self.currentTargetIndex, self.actionArr.count, dic[@"name"]];
    [self configureNextPlayView];
    
    [self playContentVoice:dic[@"name"]];
}

- (void)configureNextPlayView {
    if (self.playIndex > 0) {
        self.bottomView.trainPreBtn.enabled = YES;
    }
    if (self.playIndex >= self.videoUrlArr.count - 1) {
        self.bottomView.trainNextBtn.enabled = NO;
    }
}

- (void)resetSmallCircleView {
    [self.bottomView.smallView resetLayoutSubviews];
}

//暂停定时器(只是暂停,并没有销毁timer)
-(void)pauseTimer {
    [self.timer setFireDate:[NSDate distantFuture]];
}
//继续计时
-(void)continueTimer {
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)mouseStartCount {
    if (self.mouse > 0) {
        self.mouse --;
        self.mouseL.text = [ZCDataTool convertMouseToMSTimeString:self.mouse];
        
        NSDictionary *tem = self.videoUrlArr[self.playIndex];
        if ([tem[@"rest"] integerValue] == 1) {
            self.restView.timeL.text = [ZCDataTool convertMouseToMSTimeString:self.mouse];
        } else {
            if (self.mouse == 3 || self.mouse == 2 || self.mouse == 1) {
                self.textL.hidden = NO;
                self.textL.text = [NSString stringWithFormat:@"%tu", self.mouse];
//                [self playContentVoice:[NSString stringWithFormat:@"%tu", self.mouse]];
            } else if (self.mouse == 0) {
                self.textL.hidden = YES;
//                if (self.playIndex+1 < self.videoUrlArr.count) {
//                    NSDictionary *nextDic = self.videoUrlArr[self.playIndex+1];
//                    NSString *name = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"下一个动作：", nil), nextDic[@"name"]];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self playContentVoice:name];
//                    });
//                }
            }
        }
        if (self.mouse == 3) {
            if (self.playIndex+1 < self.videoUrlArr.count) {
                NSDictionary *nextDic = self.videoUrlArr[self.playIndex+1];
                NSString *name = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"下一个动作：", nil), nextDic[@"name"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self playContentVoice:name];
                });
                [self showNextView:nextDic firstSign:NO];
            }
        }
        if (self.mouse == 1) {
            if (self.playIndex < self.videoUrlArr.count-1) {
                if ([tem[@"rest"] integerValue] == 0) {
                    NSDictionary *dic = self.videoUrlArr[self.playIndex + 1];
                    [self showNextView:dic firstSign:NO];
                }
            }
        }
    }
    
    [self.bottomView.smallView setProgress:1.0/self.targetMouse animated:YES startAngle:-M_PI_2 + M_PI*2*(1.0/self.targetMouse*(self.targetIndex)) clockwise:YES];
    [self.bottomView.bigView setProgress:1.0/self.totalTime animated:YES startAngle:-M_PI_2 + M_PI*2*(1.0/self.totalTime*(self.mouseIndex)) clockwise:YES];
    self.mouseIndex ++;
    self.targetIndex ++;
    if (self.targetIndex == self.targetMouse) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self playFinishOperate];
        });
    }
}

#pragma -- mark 绘制大圆环
- (void)setBigCircleColor:(NSInteger)index {
    double mouseTime = 0.0;
    for (int i = 0; i < index; i ++) {
        NSDictionary *dic = self.videoUrlArr[i];
        double time = [dic[@"time"] doubleValue];
        if ([dic[@"rest"] integerValue] == 1) {
            [self setCircleProgressColorWithRestStatus:YES];
        } else {
            [self setCircleProgressColorWithRestStatus:NO];
        }
        [self.bottomView.bigView setProgress:time/self.totalTime animated:NO startAngle:-M_PI_2 + M_PI*2*(1.0/self.totalTime*mouseTime) clockwise:YES];
        mouseTime += time;
    }
    self.mouseIndex = mouseTime;
}

#pragma -- mark 播放声音
- (void)playContentVoice:(NSString *)content {
    self.signCurrentVoiceFlag = YES;
    // 停止播放
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.speech stopSpeakingAtBoundary:AVSpeechBoundaryWord];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        // 播报内容
        NSString *playStr = content;
        //设置发音，这是中文普通话
        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        //需要转换的文字
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:playStr];
        // 设置语速，范围0-1，注意0最慢，1最快；
        utterance.rate  = 0.5;
        utterance.voice = voice;
        //开始
        [self.speech speakUtterance:utterance];
    });

}
#pragma -- mark 播报完成回调
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    });
        
    if (self.signFinishFlag) {
        self.signFinishFlag = NO;
        [self.playView pause];
        [self destoryTimer];
        [HCRouter router:@"ClassPlayFinish" params:@{@"data":self.params[@"title"]} viewController:self animated:YES];
        [self recordCourseInfo];
    } else {
        self.signCurrentVoiceFlag = NO;
        if (self.signFirstFlag) {
            self.signFirstFlag = NO;
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            [self playSourceVideo];
        } else {
            NSDictionary *dic = self.videoUrlArr[self.playIndex];
            if ([dic[@"rest"] integerValue] == 0) {
                [self.playView play];
            }
            [self continueTimer];
        }
    }
}

- (void)changAVAudioSessionWithOptionsCanBackPlayTheMusic {
    
    NSLog(@"-category2--%@",AVAudioSession.sharedInstance.category);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        //
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionModeMoviePlayback error:&error];
        if ( error ) NSLog(@"%@", error.userInfo);
        [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionModeMoviePlayback error:&error];
        if ( error ) NSLog(@"%@", error.userInfo);
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    });
    
}

- (void)recordCourseInfo {
    NSInteger duration = 0;
    NSInteger restDuration = 0;
    NSInteger index = self.playIndex - 1;
    if (index > 0) {
        for (int i = 0; i < index; i ++) {
            NSDictionary *dic = self.videoUrlArr[i];
            if ([dic[@"rest"] integerValue] == 0) {
                duration += [dic[@"time"] integerValue];
            } else {
                restDuration += [dic[@"time"] integerValue];
            }
        }
        NSDictionary *dataDic = self.params[@"title"];
        NSString *courseId = checkSafeContent(dataDic[@"customCourseId"]);
        if(courseId.length == 0) {
            courseId = checkSafeContent(dataDic[@"courseId"]);
        }
        NSDictionary *dic = @{@"duration":@(duration),
                              @"restDuration":@(restDuration),
                              @"courseId":courseId
        };
        NSLog(@"dic-->%@", dic);
        if (checkSafeContent(dataDic[@"customCourseId"]).length > 0) {
            [ZCClassSportManage recordCustomCourseTrainInfoURL:dic completeHandler:^(id  _Nonnull responseObj) {
                
            }];
        } else {
            [ZCClassSportManage recordCourseTrainInfo:dic completeHandler:^(id  _Nonnull responseObj) {
                
            }];
        }
    }
}

- (void)showNextView:(NSDictionary *)dic firstSign:(BOOL)status{
    self.nextView.hidden = NO;
    self.nextView.signFirstFlag = status;
    self.nextView.dataDic = dic;
}

- (void)showNextViewHide {
    self.nextView.hidden = YES;
}

- (void)dealloc {
    [self removeBackgroundNotification];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)destoryTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (NSMutableArray *)videoUrlArr {
    if (!_videoUrlArr) {
        _videoUrlArr = [NSMutableArray array];
    }
    return _videoUrlArr;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(mouseStartCount) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (ZCClassPlayPauseView *)pauseView {
    if (!_pauseView) {
        _pauseView = [[ZCClassPlayPauseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        _pauseView.hidden = YES;
    }
    return _pauseView;
}

- (ZCCurrentActionInfoView *)infoView {
    if (!_infoView) {
        _infoView = [[ZCCurrentActionInfoView alloc] initWithFrame:CGRectMake(0, SCREEN_H - AUTO_MARGIN(212) - AUTO_MARGIN(58) - AUTO_MARGIN(20), SCREEN_W, AUTO_MARGIN(58))];
    }
    return _infoView;
}

- (UILabel *)nextCurrentL {
    if (!_nextCurrentL) {
        _nextCurrentL = [self.view createSimpleLabelWithTitle:@"" font:16 bold:NO color:[ZCConfigColor txtColor]];
        _nextCurrentL.hidden = YES;
        _nextCurrentL.textAlignment = NSTextAlignmentCenter;
        _nextCurrentL.frame = CGRectMake(0, SCREEN_H - AUTO_MARGIN(212) - AUTO_MARGIN(30) - AUTO_MARGIN(20), SCREEN_W, AUTO_MARGIN(30));
    }
    return _nextCurrentL;
}

- (UILabel *)textL {
    if (!_textL) {
        _textL = [self.view createSimpleLabelWithTitle:@"" font:200 bold:YES color:rgba(250, 100, 0, 1)];
        _textL.hidden = YES;
    }
    return _textL;
}

- (ZCClassPlayNextView *)nextView {
    if (!_nextView) {
        _nextView = [[ZCClassPlayNextView alloc] init];
        _nextView.hidden = YES;
    }
    return _nextView;
}

- (ZCClassPlayRestView *)restView {
    if (!_restView) {
        _restView = [[ZCClassPlayRestView alloc] init];
        _restView.hidden = YES;
    }
    return _restView;
}

    
    
@end

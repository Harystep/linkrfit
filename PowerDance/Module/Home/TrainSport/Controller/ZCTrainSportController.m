//
//  ZCTrainSportController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/2.
//

#import "ZCTrainSportController.h"
#import "ZCTrainSportTopView.h"
#import "PGCircleProgressView.h"
#import "ZCBaseCircleView.h"
#import "ZCTrainSportDownView.h"
#import "BLETimerServer.h"
#import "ZCBasePlayVideoView.h"

@interface ZCTrainSportController ()<AVSpeechSynthesizerDelegate>
@property (nonatomic,strong) UIScrollView *scView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) ZCTrainSportTopView *topView;
@property (nonatomic,strong) ZCBaseCircleView *bigView;
@property (nonatomic,strong) ZCBaseCircleView *smallView;
@property (nonatomic,strong) NSMutableArray *dataArr;//播报数据源
@property (nonatomic,strong) NSMutableArray *numAlertArr;//暂时未用
@property (nonatomic, strong) AVSpeechSynthesizer *speech;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger totalTime;//训练所需时间
@property (nonatomic,assign) double totalEnergy;//训练所需消耗能量
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) NSInteger mouseIndex;//训练总秒数
@property (nonatomic,assign) NSInteger targetIndex;//所在训练目标秒数
@property (nonatomic,strong) ZCTrainSportDownView *downView;
@property (nonatomic, copy) NSString *firstContent;//保存第一个动作内容
@property (nonatomic,strong) NSTimer *autoTimer;
@property (nonatomic,assign) NSInteger useTimeCount;//所用时间
@property (nonatomic,strong) UILabel *currentSportTimeL;//当前动作所需时间
@property (nonatomic,strong) UILabel *currentSportNameL;//当前动作名称
@property (nonatomic,strong) UILabel *nextSportNameL;//下一个动作名称
@property (nonatomic,strong) NSArray *imageArr;//图标
@property (nonatomic,strong) UIImageView *gifIv;
@property (nonatomic,strong) UILabel *totalTimeL;//运动总时长
@property (nonatomic,strong) UILabel *precentL;
@property (nonatomic,strong) UIImageView *bgIcon;
@property (nonatomic,strong) ZCBasePlayVideoView *videoView;
@property (nonatomic, copy) NSString *pathStr;
@property (nonatomic,assign) NSInteger currentSportTime;//当前动作所需时间

@end

@implementation ZCTrainSportController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self destroyTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [ZCConfigColor whiteColor];

    self.scView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scView];
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.scView.bounces = NO;
    self.scView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.scView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets      = NO;
    }
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = rgba(246, 246, 246, 1);
    [self.scView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scView);
        make.width.mas_equalTo(self.scView);
    }];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [ZCConfigColor whiteColor];
    [self.contentView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(537));
    }];
    
    [self.view layoutIfNeeded];
    
    [self createBottomCornerWithButton:topView];
    
    self.useTimeCount = 1;
    
    self.totalTimeL = [self.view createSimpleLabelWithTitle:@"" font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    [topView addSubview:self.totalTimeL];
    [self.totalTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(topView.mas_centerX);
        make.top.mas_equalTo(topView.mas_top).offset(AUTO_MARGIN(77));
    }];
    
//    UIImageView *gifIv = [[UIImageView alloc] init];
//    self.gifIv = gifIv;
//    [topView addSubview:gifIv];
    
    ZCBasePlayVideoView *videoView = [[ZCBasePlayVideoView alloc] initWithFrame:CGRectMake((SCREEN_W - AUTO_MARGIN(160))/2.0, AUTO_MARGIN(216), AUTO_MARGIN(160), AUTO_MARGIN(160))];
    self.videoView = videoView;
    [topView addSubview:videoView];
    self.pathStr = [[NSBundle mainBundle] pathForResource:@"train_sport" ofType:@"mp4"];
    
    self.bigView = [[ZCBaseCircleView alloc] initWithFrame:CGRectMake((SCREEN_W - AUTO_MARGIN(210))/2.0, AUTO_MARGIN(191), AUTO_MARGIN(210), AUTO_MARGIN(210)) trackWidth:AUTO_MARGIN(10)];
    [topView addSubview:self.bigView];
    self.bigView.progressBgColor = UIColor.groupTableViewBackgroundColor;
        
    self.smallView = [[ZCBaseCircleView alloc] initWithFrame:CGRectMake((SCREEN_W - AUTO_MARGIN(190))/2.0, AUTO_MARGIN(201), AUTO_MARGIN(190), AUTO_MARGIN(190)) trackWidth:AUTO_MARGIN(10)];
    [topView addSubview:self.smallView];
    self.smallView.progressBgColor = rgba(213, 213, 213, 1);
        
//    [gifIv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(AUTO_MARGIN(120));
//        make.centerY.mas_equalTo(self.bigView.mas_centerY);
//        make.centerX.mas_equalTo(self.bigView.mas_centerX);
//    }];
    
    self.precentL = [self.view createSimpleLabelWithTitle:@"" font:40 bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.precentL];
    [self.precentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(topView.mas_bottom).inset(AUTO_MARGIN(28));
        make.leading.mas_equalTo(self.view.mas_leading).offset(AUTO_MARGIN(20));
    }];
    
    self.precentL.text = [NSString stringWithFormat:@"%d/%tu", 1, self.dataArr.count];
    
    self.currentSportTimeL = [self.view createSimpleLabelWithTitle:@"" font:40 bold:YES color:[ZCConfigColor txtColor]];
    self.currentSportTimeL.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.currentSportTimeL];
    [self.currentSportTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.precentL.mas_top);
        make.trailing.mas_equalTo(self.view.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    
    UIView *txtView = [[UIView alloc] init];
    [self.contentView addSubview:txtView];
    [txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(topView.mas_bottom);
        make.height.mas_equalTo(AUTO_MARGIN(144));
    }];
    
    self.currentSportNameL = [self.view createSimpleLabelWithTitle:@"" font:20 bold:NO color:[ZCConfigColor txtColor]];
    self.currentSportNameL.textAlignment = NSTextAlignmentCenter;
    [txtView addSubview:self.currentSportNameL];
    [self.currentSportNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(txtView.mas_top).offset(AUTO_MARGIN(50));
        make.leading.trailing.mas_equalTo(txtView).inset(AUTO_MARGIN(10));
    }];
    
    self.nextSportNameL = [self.view createSimpleLabelWithTitle:@"" font:14 bold:NO color:rgba(43, 42, 51, 0.5)];
    self.nextSportNameL.textAlignment = NSTextAlignmentCenter;
    [txtView addSubview:self.nextSportNameL];
    [self.nextSportNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.currentSportNameL.mas_bottom).offset(AUTO_MARGIN(10));
        make.leading.trailing.mas_equalTo(txtView).inset(AUTO_MARGIN(10));
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [ZCConfigColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(txtView.mas_bottom);
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(100)+TAB_SAFE_BOTTOM);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    [self.view layoutIfNeeded];
    [self createTopCornerWithButton:bottomView];
    
    UIView *bottom = [[UIView alloc] init];
    [bottomView addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(bottomView).inset(AUTO_MARGIN(35));
        make.height.mas_equalTo(AUTO_MARGIN(100));
    }];
    
    if ([self.params[@"timer"] integerValue] == 1) {
        [self createTimerBottomView:bottom];
    } else {
        [self createBottomOperateView:bottom];
    }
    
    [self.view addSubview:self.downView];
    kweakself(self);
    self.downView.downFunctionFinish = ^{
        if (weakself.dataArr.count > 0) {
            [weakself playContentVoice:weakself.firstContent];
            [[NSRunLoop mainRunLoop] addTimer:weakself.timer forMode:NSRunLoopCommonModes];
            [[NSRunLoop mainRunLoop] addTimer:weakself.autoTimer forMode:NSRunLoopCommonModes];
            [weakself setSportAttributeTime:weakself.dataArr[weakself.currentIndex] index:weakself.currentIndex];
            [weakself playSportGifAnimal:@"train_sport"];
            weakself.videoView.mp4_url = weakself.pathStr;
        }
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continuePlay) name:kPlayVideoFinishKey object:nil];
    
    [self addBackgroundNotification];
}

- (void)appBecomeActive {
    [self continueTimer];
}

- (void)appEnterBackground {
    [self pauseTimer];
}

- (void)continuePlay {
    NSLog(@"go----");
    self.videoView.mp4_url = self.pathStr;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.videoView play];
    });
}

- (void)createTopCornerWithButton:(UIView *)button {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds   byRoundingCorners:UIRectCornerTopLeft |    UIRectCornerTopRight    cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = button.bounds;
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}

- (void)createBottomCornerWithButton:(UIView *)button {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds   byRoundingCorners:UIRectCornerBottomLeft |    UIRectCornerBottomRight    cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = button.bounds;
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}

- (void)playSportGifAnimal:(NSString *)name {
    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]]pathForResource:name ofType:@"mp4"];
    self.pathStr = filePath;
    [self continuePlay];
}

- (void)createTimerBottomView:(UIView *)bottomView {
    CGFloat width = (SCREEN_W - AUTO_MARGIN(70))/ 2.0;
    for (int i = 0; i < 2; i ++) {
        UIButton *stopBtn = [[UIButton alloc] init];
        stopBtn.tag = i;
        [bottomView addSubview:stopBtn];
        [stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(AUTO_MARGIN(30));
            make.centerY.mas_equalTo(bottomView.mas_centerY);
            make.leading.mas_equalTo(bottomView.mas_leading).offset(width*i);
        }];
        if (i == 1) {
            [stopBtn setImage:kIMAGE(@"train_play_stop") forState:UIControlStateNormal];
            [stopBtn setImage:kIMAGE(@"train_play_stop_sel") forState:UIControlStateSelected];
        } else {
            [stopBtn setImage:kIMAGE(@"train_add") forState:UIControlStateNormal];
        }
        [stopBtn addTarget:self action:@selector(timerPlayOperate:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)timerPlayOperate:(UIButton *)sender {
    if (sender.tag) {
        sender.selected = !sender.selected;
        if (sender.selected) {
            [self pauseTimer];
            [self operateTimerData:[ZCBluthDataTool timerStop]];
        } else {
            [self continueTimer];
            [self operateTimerData:[ZCBluthDataTool timerStart]];
        }
    } else {
        [[BLETimerServer defaultBLEServer] stopScan];
        [[BLETimerServer defaultBLEServer] disConnect];
        [self endSportTrainOperate];
    }
}

- (void)operateTimerData:(NSData *)data {
    if ([BLETimerServer defaultBLEServer].selectPeripheral != nil || [BLETimerServer defaultBLEServer].selectCharacteristic != nil) {
        [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    } else {
        [self.view makeToast:NSLocalizedString(@"计时器已断开连接", nil) duration:2.0 position:CSToastPositionCenter];
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

#pragma -- mark 获取已运动总时长
- (void)totalTimeOperate {
    self.useTimeCount ++;
    self.totalTimeL.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"已进行时长", nil), [ZCDataTool convertMouseToMSTimeString:self.useTimeCount]];
}
#pragma -- mark 运动相关操作
- (void)playOperate:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [self endSportTrainOperate];
            break;
        case 1:
        {
            if (self.currentIndex == 0) return;
            [self playPreSport:self.currentIndex - 1];
        }
            break;
        case 2:
            [self playSport:sender];
            break;
        case 3:
        {
            if (self.currentIndex == self.dataArr.count - 1) return;
            [self playNextSport:self.currentIndex + 1];
        }
            break;
            
        default:
            break;
    }
    
}
#pragma -- mark 结束训练
- (void)endSportTrainOperate {
    CGFloat energy = 0.0;
    for (int i = 0; i < self.currentIndex; i ++) {
        NSDictionary *dic = self.dataArr[i];
        energy += [dic[@"energy"] integerValue] * [dic[@"time"] integerValue]/60.0;
    }
    [self destroyTimer];
    [self recordCourseInfo];
    [HCRouter router:@"TrainFinish" params:@{@"time":@(self.useTimeCount), @"num":@(self.dataArr.count), @"energy":@(energy)} viewController:self animated:YES];
}

- (void)recordCourseInfo {
    NSInteger duration = 0;
    NSInteger restDuration = 0;
    NSInteger index = self.currentIndex - 1;
    if (index > 0) {
        for (int i = 0; i < index; i ++) {
            NSDictionary *dic = self.dataArr[i];
            if ([dic[@"rest"] integerValue] == 0) {
                duration += [dic[@"time"] integerValue];
            } else {
                restDuration += [dic[@"time"] integerValue];
            }
        }
        NSDictionary *dic = @{@"duration":@(duration),
                              @"restDuration":@(restDuration),
                              @"trainId":checkSafeContent(self.params[@"trainId"])
        };
        
        [ZCTrainManage recordTrainRecordInfo:dic completeHandler:^(id  _Nonnull responseObj) {
            NSLog(@"---->%@", responseObj);
        }];
    }
}

#pragma -- mark 暂停/开始播放
- (void)playSport:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self pauseTimer];
    } else {
        [self continueTimer];
    }
}

//暂停定时器(只是暂停,并没有销毁timer)
-(void)pauseTimer {
    [self.videoView pause];
    [self.timer setFireDate:[NSDate distantFuture]];
}
//继续计时
-(void)continueTimer {
    [self.videoView play];
    [self.timer setFireDate:[NSDate distantPast]];
}
 
#pragma -- mark 播放声音
- (void)playContentVoice:(NSString *)content {
    self.speech = [[AVSpeechSynthesizer alloc] init];
    self.speech.delegate = self;
    // 停止播放
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.speech stopSpeakingAtBoundary:AVSpeechBoundaryWord];
        [[AVAudioSession sharedInstance] setActive:NO
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
            utterance.rate  = 0.5;
            utterance.voice = voice;
            //开始
            [self.speech speakUtterance:utterance];
        });
    });
}
#pragma -- mark 播报完成回调
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    
}

#pragma -- mark 提示运动组
- (void)setSportAttributeTime:(NSDictionary *)dic index:(NSInteger)index {
    float time = [dic[@"time"] floatValue];
    
    self.currentSportTimeL.text = [ZCDataTool convertMouseToMSTimeString:time];
    self.currentSportNameL.text = [self convertVoiceContent:dic];
    if (index == self.dataArr.count-1) {
        self.nextSportNameL.text = NSLocalizedString(@"运动即将结束", nil);
    } else {
        NSDictionary *timeDic = self.dataArr[index+1];
        self.nextSportNameL.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"下一个动作", nil), timeDic[@"content"]];
    }

}

#pragma -- mark 开始训练动画
- (void)startAnimalOperate {
    self.mouseIndex ++;
    NSDictionary *timeDic = self.dataArr[self.currentIndex];
    float time = [timeDic[@"time"] floatValue];
    self.bigView.progressColor = timeDic[@"color"];
    self.smallView.progressColor = timeDic[@"color"];
    if (self.mouseIndex <= self.totalTime) {
        NSLog(@"mouseIndex-->%tu", self.mouseIndex);
        [self.bigView setProgress:1.0/self.totalTime animated:YES startAngle:-M_PI_2 + M_PI*2*(1.0/self.totalTime*(self.mouseIndex-1)) clockwise:YES];
    }
    if (self.targetIndex == time - 4) {
        if (self.currentIndex < self.dataArr.count-1) {
            NSDictionary *dic = self.dataArr[self.currentIndex + 1];
            NSString *content = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"下一个动作", nil), [self convertVoiceContent:dic]];
            [self playContentVoice:content];
        }
    }
    if (self.targetIndex == time - 1) {
        [self.smallView setProgress:1.0/time animated:YES startAngle:-M_PI_2 + M_PI*2*(1.0/time*(self.targetIndex)) clockwise:YES];
        if (self.currentIndex == self.dataArr.count - 1) {
            self.currentSportTimeL.text = @"00:00";
            [self destroyTimer];
            [self recordCourseInfo];
            [self playContentVoice:NSLocalizedString(@"运动已完成", nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HCRouter router:@"TrainFinish" params:@{@"time":@(self.useTimeCount), @"num":@(self.dataArr.count), @"energy":@(self.totalEnergy)} viewController:self animated:YES];
            });
        } else {
            self.currentIndex ++;
            self.targetIndex = 0;
            [self setSportAttributeTime:self.dataArr[self.currentIndex] index:self.currentIndex];
            NSDictionary *dic = self.dataArr[self.currentIndex];
            if ([dic[@"rest"] integerValue] == 1) {
                [self playSportGifAnimal:@"train_rest"];
            } else {
                [self playSportGifAnimal:@"train_sport"];
            }
        }
    } else {
        if (self.targetIndex == 0 && self.currentIndex > 0) {
            NSLog(@"下一个--%tu", self.currentIndex);
            [self.smallView resetLayoutSubviews];
            self.precentL.text = [NSString stringWithFormat:@"%tu/%tu", self.currentIndex+1, self.dataArr.count];
        }
        NSLog(@"time-->%f", self.targetIndex/time);
        [self.smallView setProgress:1.0/time animated:YES startAngle:-M_PI_2 + M_PI*2*(1.0/time*(self.targetIndex)) clockwise:YES];
        self.targetIndex ++;
    }
    self.currentSportTime = time - self.targetIndex;
    self.currentSportTimeL.text = [ZCDataTool convertMouseToMSTimeString:time - self.targetIndex];
}
#pragma -- mark 下一个动作
- (void)playNextSport:(NSInteger)index {
    [self.bigView resetLayoutSubviews];
    [self.smallView resetLayoutSubviews];
    self.targetIndex = 0;
    self.currentIndex ++;
    [self setBigCircleColor:index];
    NSInteger mouse = 0;
    for (int i = 0; i < index; i ++) {
        NSDictionary *dic = self.dataArr[i];
        mouse += [dic[@"time"] integerValue];
    }
    self.mouseIndex = mouse;
    self.precentL.text = [NSString stringWithFormat:@"%tu/%tu", index+1, self.dataArr.count];
    [self setSportAttributeTime:self.dataArr[self.currentIndex] index:self.currentIndex];
    [self playContentVoice:[self convertVoiceContent:self.dataArr[self.currentIndex]]];
    NSDictionary *dic = self.dataArr[self.currentIndex];
    if ([dic[@"rest"] integerValue] == 1) {
        [self playSportGifAnimal:@"train_rest"];
    } else {
        [self playSportGifAnimal:@"train_sport"];
    }
}
#pragma -- mark 上一个动作
- (void)playPreSport:(NSInteger)index {
    [self.bigView resetLayoutSubviews];
    [self.smallView resetLayoutSubviews];
    self.targetIndex = 0;
    self.currentIndex --;
    if (index == 0) {
        self.mouseIndex = 0;
    } else {
        [self setBigCircleColor:index];
        NSInteger mouse = 0;
        for (int i = 0; i < index; i ++) {
            NSDictionary *dic = self.dataArr[i];
            mouse += [dic[@"time"] integerValue];
        }
        self.mouseIndex = mouse;
    }
    self.precentL.text = [NSString stringWithFormat:@"%tu/%tu", index+1, self.dataArr.count];
    NSDictionary *temDic = self.dataArr[self.currentIndex];
//    self.currentSportTimeL.text = [ZCDataTool convertMouseToMSTimeString:[temDic[@"time"] integerValue]];
    [self setSportAttributeTime:self.dataArr[self.currentIndex] index:self.currentIndex];
    [self playContentVoice:[self convertVoiceContent:temDic]];
    NSDictionary *dic = self.dataArr[self.currentIndex];
    if ([dic[@"rest"] integerValue] == 1) {
        [self playSportGifAnimal:@"train_rest"];
    } else {
        [self playSportGifAnimal:@"train_sport"];
    }
}
#pragma -- mark 绘制大圆环
- (void)setBigCircleColor:(NSInteger)index {
    double mouseTime = 0.0;
    for (int i = 0; i < index; i ++) {
        NSDictionary *dic = self.dataArr[i];
        double time = [dic[@"time"] doubleValue];
        self.bigView.progressColor = dic[@"color"];
        [self.bigView setProgress:time/self.totalTime animated:NO startAngle:-M_PI_2 + M_PI*2*(1.0/self.totalTime*mouseTime) clockwise:YES];
        mouseTime += time;
    }
}
#pragma -- mark 保存记录
- (void)saveTrainRecordOperate {
    [ZCTrainManage saveTrainRecordOpereateInfo:@{@"trainId":self.params[@"trainId"]} completeHandler:^(id  _Nonnull responseObj) {
        
    }];
}
#pragma -- mark 销毁相关定时器
- (void)destroyTimer {
    [self.videoView pause];
    [self.timer invalidate];
    self.timer = nil;
    [self.autoTimer invalidate];
    self.autoTimer = nil;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        NSArray *data = self.params[@"data"];
        _dataArr = [NSMutableArray array];
        _totalTime = 0;
        _totalEnergy = 0.0;
        for (NSDictionary *dic in data) {
            NSArray *itemList = dic[@"itemList"];
            NSMutableArray *temArr = [NSMutableArray array];
            double itemEnergy = 0.0;
            NSInteger itemTime = 0;
            for (NSDictionary *item in itemList) {
                NSMutableDictionary *itemDic = [NSMutableDictionary dictionary];
                [itemDic setValue:item[@"duration"] forKey:@"time"];
                [itemDic setValue:kColorHex(item[@"color"]) forKey:@"color"];
                [itemDic setValue:item[@"name"] forKey:@"content"];
                [itemDic setValue:checkSafeContent(item[@"energy"]) forKey:@"energy"];
                [itemDic setValue:checkSafeContent(item[@"count"]) forKey:@"count"];
                [itemDic setValue:checkSafeContent(item[@"rest"]) forKey:@"rest"];
                [temArr addObject:itemDic];
                itemEnergy += [itemDic[@"energy"] doubleValue] * [itemDic[@"time"] integerValue]/60.0;
                itemTime += [itemDic[@"time"] integerValue];
            }
            _totalTime += itemTime * [dic[@"loop"] integerValue];
            _totalEnergy += itemEnergy * [dic[@"loop"] integerValue];
            NSInteger loop = [dic[@"loop"] integerValue];
            for (int i = 0; i < loop; i ++) {
                [_dataArr addObjectsFromArray:temArr];
            }
        }
        NSDictionary *dic = _dataArr.firstObject;
        self.firstContent = [self convertVoiceContent:dic];
    }
    return _dataArr;
}

- (NSString *)convertVoiceContent:(NSDictionary *)dic {
    NSString *content;
    if ([dic[@"count"] integerValue] == 0) {
        content = [NSString stringWithFormat:@"%@", dic[@"content"]];
    } else {
        content = [NSString stringWithFormat:@"%@%@%@", dic[@"content"], dic[@"count"], NSLocalizedString(@"次", nil)];
    }
    return content;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startAnimalOperate) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (NSMutableArray *)numAlertArr {
    if (!_numAlertArr) {
        _numAlertArr = [NSMutableArray arrayWithArray:@[
            NSLocalizedString(@"3", nil),
            NSLocalizedString(@"2", nil),
            NSLocalizedString(@"1", nil),
        ]];
    }
    return _numAlertArr;
}

- (ZCTrainSportDownView *)downView {
    if (!_downView) {
        _downView = [[ZCTrainSportDownView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        _downView.backgroundColor = [ZCConfigColor whiteColor];
    }
    return _downView;
}

- (NSTimer *)autoTimer {
    if (!_autoTimer) {
        _autoTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(totalTimeOperate) userInfo:nil repeats:YES];
    }
    return _autoTimer;
}

- (NSArray *)imageArr {
    if (!_imageArr) {
        _imageArr = @[@"train_add", @"train_pre", @"train_play_stop", @"train_next"];
    }
    return _imageArr;
}

- (void)dealloc {
    [[BLETimerServer defaultBLEServer] stopScan];
    [[BLETimerServer defaultBLEServer] disConnect];
}

@end

//
//  ZCTrainSportDownView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/12/1.
//

#import "ZCTrainSportDownView.h"

@interface ZCTrainSportDownView ()

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) UILabel *timeL;

@property (nonatomic,assign) NSInteger mouse;

@property (nonatomic, strong) AVSpeechSynthesizer *speech;

@end

@implementation ZCTrainSportDownView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UILabel *lb = [self createSimpleLabelWithTitle:@"9" font:120 bold:YES color:[ZCConfigColor txtColor]];
    self.mouse = 9;
    self.timeL = lb;
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
    }];
//    [self playContentVoice:@"5"];
    kweakself(self);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakself timerOperate];
    }];
}

- (void)timerOperate {
    if (self.mouse == 1) {       
        if (self.downFunctionFinish) {
            self.downFunctionFinish();
        }
        [self.timer invalidate];
        self.timer = nil;
        [self removeFromSuperview];
    } else {
        self.mouse --;
        self.timeL.text = [NSString stringWithFormat:@"%tu", self.mouse];
//        [self playContentVoice:self.timeL.text];
    }
    
}

- (void)playContentVoice:(NSString *)content {
    self.speech = [[AVSpeechSynthesizer alloc] init];
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

@end

//
//  ZCPowerStationVoiceView.m
//  PowerDance
//
//  Created by oneStep on 2023/4/25.
//

#import "ZCPowerStationVoiceView.h"

@interface ZCPowerStationVoiceView ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UIButton *deleteBtn;

@property (nonatomic,strong) UISlider *sliderView;

@property (nonatomic, copy) NSString *voice;

@end

@implementation ZCPowerStationVoiceView

- (UIButton *)maskBtn {
    if (!_maskBtn) {
        _maskBtn = [[UIButton alloc] init];
        _maskBtn.backgroundColor = rgba(0, 0, 0, 0.4);
        _maskBtn.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    }
    return _maskBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    [self addSubview:self.maskBtn];
    
    UIView *contentView = [[UIView alloc] init];
    self.contentView = contentView;
    [self addSubview:contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(165);
        make.width.mas_equalTo(195);
        make.height.mas_equalTo(380);
    }];
    
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:kIMAGE(@"power_station_alert_bg")];
    [contentView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentView);
    }];
    
    self.titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"设置", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(25);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    [self createSliderView];
    
    UIImageView *openIv = [[UIImageView alloc] initWithImage:kIMAGE(@"power_station_voice_open")];
    [self.contentView addSubview:openIv];
    [openIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.titleL.mas_centerX);
        make.bottom.mas_equalTo(self.titleL.mas_bottom).offset(40);
    }];
    
    UIImageView *closeIv = [[UIImageView alloc] initWithImage:kIMAGE(@"power_station_voice_close")];
    [self.contentView addSubview:closeIv];
    [closeIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.titleL.mas_centerX);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(56);
    }];
    
    UIButton *sure = [self createSimpleButtonWithTitle:NSLocalizedString(@"保存", nil) font:14 color:[ZCConfigColor whiteColor]];
    [self.contentView  addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(32);
    }];
    [sure addTarget:self action:@selector(sureOperate) forControlEvents:UIControlEventTouchUpInside];
    [sure layoutIfNeeded];
    
    [sure configureLeftToRightViewColorGradient:sure width:80 height:32 one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:16];
    
    self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setImage:kIMAGE(@"power_station_delete") forState:UIControlStateNormal];
    [self addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(contentView.mas_bottom);
    }];
    [self.deleteBtn addTarget:self action:@selector(hideAlertView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createSliderView {
    //定义uislider
    self.sliderView = [[UISlider alloc] initWithFrame:CGRectMake(-10, 180, 214, 30)];
    //设置未滑动位置背景图片
//    [self.sliderView setMinimumTrackImage:[UIImage imageNamed:@"main_slider_bg_1.png"] forState:UIControlStateNormal];
    self.sliderView.minimumTrackTintColor = rgba(247, 135, 0, 1);
    //设置已滑动位置背景图
//    [self.sliderView setMaximumTrackImage:[UIImage imageNamed:@"main_slider_bg_1.png"] forState:UIControlStateNormal];
    self.sliderView.maximumTrackTintColor = UIColor.whiteColor;
    //设置滑块图标图片
    [self.sliderView setThumbImage:[UIImage imageNamed:@"power_staion_slider_icon"] forState:UIControlStateNormal];
    //设置点击滑块状态图标
//    [self.sliderView setThumbImage:[UIImage imageNamed:@"main_slider_btn.png"] forState:UIControlStateHighlighted];
    //设置旋转90度
    self.sliderView.transform = CGAffineTransformMakeRotation(-1.57079633);

    //设置起始位置
    self.sliderView.value = 0;
    //设置最小数
    self.sliderView.minimumValue = 1;
    //设置最大数
    self.sliderView.maximumValue = 100;
    //设置背景颜色
    self.sliderView.backgroundColor = UIColor.clearColor;
    //设置委托事件
    [self.sliderView addTarget:self action:@selector(sliderOperate) forControlEvents:UIControlEventValueChanged];
    //添加到VIEW
    [self.contentView addSubview:self.sliderView];
}

- (void)sliderOperate {
    NSString *numStr = [NSString stringWithFormat:@"%.f", self.sliderView.value];
//    NSString *hexStr = [NSString stringWithFormat:@"%@", [[NSString alloc] initWithFormat:@"%02lx", (long)[numStr integerValue]]];
    NSString *hexStr = [ZCBluthDataTool ToHex:[numStr integerValue]];
    NSLog(@"%@", hexStr);
    self.voice = hexStr;
}

//将NSString转换成十六进制的字符串则可使用如下方式:
- (NSString *)convertStringToHexStr:(NSString *)str {
    if (!str || [str length] == 0) {
        return @"";
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];

    return string;
}

- (void)showAlertView {
    self.frame = UIScreen.mainScreen.bounds;
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.maskBtn.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideAlertView {
    self.maskBtn.hidden = YES;
    self.contentView.hidden = YES;
    [self removeFromSuperview];
}

- (void)sureOperate {
    [self hideAlertView];
    if (self.setDeviceVoiceBlock) {        
        self.setDeviceVoiceBlock(self.voice);
    }
    
}

@end

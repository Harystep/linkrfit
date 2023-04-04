//
//  ZCClassPlayMiddleView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/31.
//

#import "ZCClassPlayMiddleView.h"
#import "MCSliderView.h"

@interface ZCClassPlayMiddleView ()<MCSliderViewDelegate>

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) UIImageView *iconIv;

@property (strong, nonatomic) MCSliderView *sliderView;

@end

@implementation ZCClassPlayMiddleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    NSLog(@"come here");
    self.backgroundColor = [ZCConfigColor whiteColor];
    // blur
    
    UIButton *exitBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"退出训练", nil) font:AUTO_MARGIN(17) color:[ZCConfigColor txtColor]];
    [self addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.mas_top).offset(STATUS_BAR_HEIGHT);
        make.height.mas_equalTo(AUTO_MARGIN(66));
    }];
    [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(212));
    }];
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"训练正在加载···", nil) font:20 bold:YES color:rgba(43, 42, 51, 0.5)];
    [bottomView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.centerX.mas_equalTo(bottomView.mas_centerX);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(STATUS_BAR_HEIGHT+AUTO_MARGIN(66));
        make.bottom.mas_equalTo(bottomView.mas_top);
    }];
    
    self.iconIv = [[UIImageView alloc] init];
    [contentView addSubview:self.iconIv];
    [self.iconIv setViewContentMode:UIViewContentModeScaleAspectFill];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentView);
    }];
    [contentView setViewColorAlpha:0.7 color:[ZCConfigColor whiteColor]];
    
    self.nameL = [self createSimpleLabelWithTitle:NSLocalizedString(@"KK燃脂训练", nil) font:20 bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(contentView.mas_bottom).inset(AUTO_MARGIN(25));
    }];
    
    UILabel *startL = [self createSimpleLabelWithTitle:NSLocalizedString(@"开始训练", nil) font:20 bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:startL];
    [startL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.nameL.mas_top).inset(AUTO_MARGIN(8));
    }];
    
    self.sliderView = [[MCSliderView alloc] init];
    [self addSubview:self.sliderView];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(contentView).inset(-AUTO_MARGIN(5));
        make.height.mas_equalTo(AUTO_MARGIN(10));
        make.bottom.mas_equalTo(contentView.mas_bottom).offset(AUTO_MARGIN(5));
    }];
    self.sliderView.middleTrackTintColor = rgba(250, 106, 2, 1);
    self.sliderView.minimumTrackTintColor = rgba(250, 106, 2, 1);
    self.sliderView.maximumTrackTintColor = [ZCConfigColor bgColor];
    self.sliderView.delegate = self;

    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)updataProgess {
    if (self.sliderView.value >= 1) {
        self.sliderView.middleValue = 0;
        self.sliderView.value = 0;
    }
    self.sliderView.value += 0.01;
    self.sliderView.middleValue = (self.sliderView.value + 0.1)/self.sliderView.maxValue;
}

- (void)exitBtnClick {
    [self routerWithEventName:@"middle" userInfo:@{}];
}

- (void)setIconStr:(NSString *)iconStr {
    _iconStr = iconStr;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:nil];
}

- (void)sliderTouchBegan:(MCSlider * )slider
{
    NSLog(@"sliderTouchBegan");
    
}
- (void)sliderTouchDone:(MCSlider * )slider
{
    NSLog(@"sliderTouchDone");
}

- (void)fireCustomTimer {
    NSLog(@"fire timer");
    [self.timer invalidate];
    self.timer = nil;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updataProgess) userInfo:nil repeats:YES];
    }
    return _timer;
}

@end

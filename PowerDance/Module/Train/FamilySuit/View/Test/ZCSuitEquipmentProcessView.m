//
//  ZCSuitEquipmentProcessView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/8/1.
//
#import "ZCSuitEquipmentProcessView.h"

@interface ZCSuitEquipmentProcessView ()

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) UILabel *timeL;

@end

@implementation ZCSuitEquipmentProcessView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.top.bottom.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(40));
    }];
    contentView.backgroundColor = [ZCConfigColor whiteColor];
    [contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = rgba(250, 100, 0, 0.3);
    [contentView addSubview:self.bgView];
    self.bgView.frame = CGRectMake(0, 0, 0, AUTO_MARGIN(40));
    [self.bgView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    UILabel *textL = [self createSimpleLabelWithTitle:NSLocalizedString(@"测试中：", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:textL];
    [textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(15));
    }];
    
    self.timeL = [self createSimpleLabelWithTitle:NSLocalizedString(@"测试中：", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.leading.mas_equalTo(textL.mas_trailing);
    }];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(animalOperate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)animalOperate {
    self.currentIndex ++;
    self.timeL.text = [NSString stringWithFormat:@"%tus", self.currentIndex];
    [UIView animateWithDuration:1.0 animations:^{
        self.bgView.frame = CGRectMake(0, 0, AUTO_MARGIN(10)*self.currentIndex, AUTO_MARGIN(40));
    }];
}

@end

//
//  ZCAutoTimerProgressView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/18.
//

#import "ZCAutoTimerProgressView.h"
#import "ZCAutoProgressView.h"

@interface ZCAutoTimerProgressView ()

@property (nonatomic,strong) ZCAutoProgressView *progressView;

@end

@implementation ZCAutoTimerProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"总进度", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.mas_top);
    }];
    
    UILabel *timeL = [self createSimpleLabelWithTitle:NSLocalizedString(@"33:30", nil) font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor txtColor]];
    [self addSubview:timeL];
    self.timeL = timeL;
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(lb.mas_centerY);
    }];
    self.progressView = [[ZCAutoProgressView alloc] initWithFrame:CGRectMake(AUTO_MARGIN(20), AUTO_MARGIN(30), SCREEN_W - AUTO_MARGIN(40), AUTO_MARGIN(10))];
    self.progressView.progerssColor = rgba(255, 138, 59, 1);
    self.progressView.progerssBackgroundColor = rgba(243, 243, 243, 1);
    [self addSubview:self.progressView];
    [self.progressView setViewCornerRadiu:AUTO_MARGIN(5)];
//    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
//        make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(20));
//        make.height.mas_equalTo(AUTO_MARGIN(10));
//    }];
    
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.progressView.progress = progress;
}

@end

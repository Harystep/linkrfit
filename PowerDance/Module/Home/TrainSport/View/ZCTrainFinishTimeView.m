//
//  ZCTrainFinishTimeView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/2.
//

#import "ZCTrainFinishTimeView.h"

@interface ZCTrainFinishTimeView ()

@end

@implementation ZCTrainFinishTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = rgba(0, 0, 0, 0.14);
    [self addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.width.mas_equalTo(1);
        make.leading.equalTo(self.mas_trailing).dividedBy(3);
        make.top.mas_equalTo(self.mas_top);
        make.centerY.mas_equalTo(self);
    }];
    
    UIView *sep1View = [[UIView alloc] init];
    sep1View.backgroundColor = rgba(0, 0, 0, 0.14);
    [self addSubview:sep1View];
    [sep1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.width.mas_equalTo(1);
        make.leading.equalTo(self.mas_trailing).dividedBy(1.5);
        make.centerY.mas_equalTo(self);
    }];
    
    [self createSubViewsLeadView:self trailView:sepView type:0 title:NSLocalizedString(@"能量消耗", nil)];
    [self createSubViewsLeadView:sepView trailView:sep1View type:1 title:NSLocalizedString(@"训练时长", nil)];
    [self createSubViewsLeadView:sep1View trailView:self type:2 title:NSLocalizedString(@"动作", nil)];

}

- (void)createSubViewsLeadView:(UIView *)leadView trailView:(UIView *)trailView type:(NSInteger)type title:(NSString *)title{
    UILabel *enTitleL = [self createSimpleLabelWithTitle:title font:14 bold:NO color:rgba(0, 0, 0, 0.25)];
    enTitleL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:enTitleL];
    if (type == 2) {
        [enTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(leadView.mas_leading);
            make.trailing.mas_equalTo(self.mas_trailing);
            make.top.mas_equalTo(self);
            make.height.mas_equalTo(AUTO_MARGIN(18));
        }];
    } else {
        [enTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(leadView.mas_leading);
            make.trailing.mas_equalTo(trailView.mas_leading);
            make.top.mas_equalTo(self);
            make.height.mas_equalTo(AUTO_MARGIN(18));
        }];
    }
    
    UILabel *energeL = [self createSimpleLabelWithTitle:@"-" font:20 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:energeL];
    [energeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(enTitleL);
        make.top.mas_equalTo(enTitleL.mas_bottom).offset(AUTO_MARGIN(15));
        make.height.mas_equalTo(AUTO_MARGIN(20));
    }];
    if (type == 0) {
        self.energeL = energeL;
    } else if (type == 1) {
        energeL.text = @"00:00:00";
        self.timeL = energeL;
    } else {
        energeL.text = @"0";
        self.groupL = energeL;
    }
}


@end

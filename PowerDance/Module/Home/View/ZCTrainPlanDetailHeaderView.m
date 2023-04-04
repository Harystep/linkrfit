//
//  ZCTrainPlanDetailHeaderView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/29.
//

#import "ZCTrainPlanDetailHeaderView.h"

@interface ZCTrainPlanDetailHeaderView ()

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UILabel *dayL;

@end

@implementation ZCTrainPlanDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    lineView.backgroundColor = [ZCConfigColor bgColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self);
        make.height.mas_equalTo(5);
    }];
    
    UIView *assignView = [[UIView alloc] init];
    [self addSubview:assignView];
    assignView.backgroundColor = rgba(138, 205, 215, 1);
    [assignView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(14);
        make.top.mas_equalTo(self.mas_top).offset(25);
        make.leading.mas_equalTo(self.mas_leading).offset(20);
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    [assignView setViewCornerRadiu:1.5];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@" ", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    self.titleL = titleL;
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(assignView.mas_centerY);
        make.leading.mas_equalTo(assignView.mas_trailing).offset(AUTO_MARGIN(5));
    }];
    
    self.dayL = [self createSimpleLabelWithTitle:@" " font:12 bold:NO color:[ZCConfigColor point6TxtColor]];
    [self addSubview:self.dayL];
    [self.dayL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleL.mas_centerY);
        make.leading.mas_equalTo(titleL.mas_trailing).offset(5);
    }];
    
}

- (void)setDayStr:(NSString *)dayStr {
    _dayStr = dayStr;
    NSString *content = [NSString acquireWeekDayFromString:dayStr];
    if (dayStr.length > 10) {
        NSString *time = [dayStr substringWithRange:NSMakeRange(5, 5)];
        if ([ZCDevice currentDevice].isUsingChinese) {
            time = [time stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
            self.titleL.text = [NSString stringWithFormat:@"%@%@", time, @"号"];
        } else {
            self.titleL.text = [NSString stringWithFormat:@"%@", time];
        }
    }
    if ([ZCDevice currentDevice].isUsingChinese) {
        self.dayL.text = [NSString stringWithFormat:@"周%@", content];
    } else {
        self.dayL.text = [NSString stringWithFormat:@"%@", [self convertWeekWithNumString:content]];
    }
}

- (NSString *)convertWeekWithNumString:(NSString *)content {
    NSString *week;
    if ([content isEqualToString:@"日"]) {
        week = @"Sunday";
    } else if ([content isEqualToString:@"一"]) {
        week = @"Monday";
    } else if ([content isEqualToString:@"二"]) {
        week = @"Tuesday";
    } else if ([content isEqualToString:@"三"]) {
        week = @"Wednesday";
    } else if ([content isEqualToString:@"四"]) {
        week = @"Thursday";
    } else if ([content isEqualToString:@"五"]) {
        week = @"Friday";
    } else {
        week = @"Saturday";
    }
    return week;
}

@end

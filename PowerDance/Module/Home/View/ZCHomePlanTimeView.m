//
//  ZCHomePlanTimeView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/28.
//

#import "ZCHomePlanTimeView.h"

@interface ZCHomePlanTimeView ()

@property (nonatomic,strong) NSMutableArray *viewArr;

@property (nonatomic,strong) UIScrollView *scView;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIView *selectView;

@end

@implementation ZCHomePlanTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.scView = [[UIScrollView alloc] init];
    [self addSubview:self.scView];
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    self.scView.showsHorizontalScrollIndicator = NO;
    
    self.contentView = [[UIView alloc] init];
    [self.scView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scView);
        make.height.mas_equalTo(self.scView.mas_height);
    }];
    
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;    
    if (self.viewArr.count == 0) {
        self.viewArr = [NSMutableArray array];
        if (dataArr.count > 0) {
            CGFloat marginX = 30;
            CGFloat width = 20;
            for (int i = 0; i < dataArr.count; i ++) {
                UIView *itemView = [[UIView alloc] init];
                [self.contentView addSubview:itemView];
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(self.contentView.mas_leading).offset((marginX+width)*i);
                    make.top.bottom.mas_equalTo(self.contentView);
                    make.width.mas_equalTo(width);
                }];
                if (i == dataArr.count-1) {
                    [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.trailing.mas_equalTo(self.contentView.mas_trailing);
                    }];
                }
                itemView.tag = i;
                [self setupTimeViewSubviews:itemView data:dataArr[i]];
                [self.viewArr addObject:itemView];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeViewClick:)];
                [itemView addGestureRecognizer:tap];
            }
        }
    }
}

- (void)setSelectTime:(NSString *)selectTime {
    _selectTime = selectTime;
}

#pragma -- mark 点击时间点
- (void)timeViewClick:(UITapGestureRecognizer *)tap {
    UIView *itemView = self.viewArr[tap.view.tag];
    if (itemView == self.selectView) return;
    [self setupItemViewStatus:NO view:self.selectView];
    [self setupItemViewStatus:YES view:itemView];
    self.selectView = itemView;
    NSString *time = self.dataArr[tap.view.tag];
    [self routerWithEventName:@"selectTime" userInfo:@{@"time":checkSafeContent(time)}];
}
#pragma -- mark 创建时间点
- (void)setupTimeViewSubviews:(UIView *)itemView data:(NSString *)time {
    NSString *day = [time substringWithRange:NSMakeRange(8, 2)];
    UILabel *titleL = [self createSimpleLabelWithTitle:@"" font:8 bold:NO color:[ZCConfigColor subTxtColor]];
    [itemView addSubview:titleL];
    titleL.tag = 1;
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(itemView.mas_centerX);
        make.top.mas_equalTo(itemView.mas_top);
    }];
    
    UILabel *dayL = [self createSimpleLabelWithTitle:day font:13 bold:NO color:[ZCConfigColor subTxtColor]];
    [itemView addSubview:dayL];
    dayL.tag = 2;
    [dayL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(itemView.mas_centerX);
        make.bottom.mas_equalTo(itemView.mas_bottom).inset(8);
    }];
    
    UIView *statusView = [[UIView alloc] init];
    [itemView addSubview:statusView];
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(6);
        make.bottom.mas_equalTo(itemView.mas_bottom);
        make.centerX.mas_equalTo(itemView.mas_centerX);
    }];
    [statusView setViewCornerRadiu:3];
    statusView.backgroundColor = rgba(138, 205, 215, 1);
    NSString *currentTime = [NSString getCurrentDate];
    if (currentTime.length > 10) {
        currentTime = [currentTime substringWithRange:NSMakeRange(0, 10)];
    }
    if (self.selectTime != nil) {
        if ([time isEqualToString:self.selectTime]) {
            NSString *content = [self convertWeekWithNumString:[NSString acquireWeekDayFromString:time]];
            [self setupItemViewStatus:YES view:itemView];
            self.selectView = itemView;
            if ([[self.selectTime substringWithRange:NSMakeRange(0, 10)] isEqualToString:currentTime]) {
                content = NSLocalizedString(@"今日", nil);
            }
            titleL.text = content;
        } else {
            if ([currentTime isEqualToString:[time substringWithRange:NSMakeRange(0, 10)]]) {
                titleL.text = NSLocalizedString(@"今日", nil);
                [self setupItemViewStatus:NO view:itemView];
            } else {
                titleL.text = [self convertWeekWithNumString:[NSString acquireWeekDayFromString:time]];
                [self setupItemViewStatus:NO view:itemView];
            }
        }
    } else {
        if ([currentTime isEqualToString:[time substringWithRange:NSMakeRange(0, 10)]]) {
            titleL.text = NSLocalizedString(@"今日", nil);
            [self setupItemViewStatus:YES view:itemView];
            self.selectView = itemView;
        } else {
            titleL.text = [self convertWeekWithNumString:[NSString acquireWeekDayFromString:time]];
            
            [self setupItemViewStatus:NO view:itemView];
        }
        if ([titleL.text isEqualToString:NSLocalizedString(@"今日", nil)]) {
            if (itemView.tag > 6) {
                [self.scView setContentOffset:CGPointMake(AUTO_MARGIN(50)*(itemView.tag-6), 0)];
            }
        }
    }
}

#pragma -- mark 配置itemView状态
- (void)setupItemViewStatus:(BOOL)status view:(UIView *)itemView {
    
    if (status) {
        for (UIView *view in itemView.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *lb = (UILabel *)view;
                lb.textColor = [ZCConfigColor txtColor];
                if (lb.tag == 1) {
                    lb.font = FONT_BOLD(11);
                } else {
                    lb.font = FONT_BOLD(16);
                }
            } else {
                view.hidden = NO;
            }
        }
    } else {
        for (UIView *view in itemView.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *lb = (UILabel *)view;
                lb.textColor = [ZCConfigColor subTxtColor];
                if (lb.tag == 1) {
                    lb.font = FONT_SYSTEM(10);
                } else {
                    lb.font = FONT_SYSTEM(13);
                }
            } else {
                view.hidden = YES;
            }
        }
    }
}

- (NSString *)convertWeekWithNumString:(NSString *)content {
    NSString *week;
    if ([content isEqualToString:@"日"]) {
        week = @"Sun.";
    } else if ([content isEqualToString:@"一"]) {
        week = @"Mon.";
    } else if ([content isEqualToString:@"二"]) {
        week = @"Tue.";
    } else if ([content isEqualToString:@"三"]) {
        week = @"Wed.";
    } else if ([content isEqualToString:@"四"]) {
        week = @"Thu.";
    } else if ([content isEqualToString:@"五"]) {
        week = @"Fri.";
    } else {
        week = @"Sat.";
    }
    return week;
}

@end

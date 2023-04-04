//
//  ZCAutoActionTrainTimeView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/27.
//

#import "ZCAutoActionTrainTimeView.h"

@interface ZCAutoActionTrainTimeView ()

@property (nonatomic,strong) UILabel *timeL;

@property (nonatomic,strong) UILabel *numL;

@end

@implementation ZCAutoActionTrainTimeView

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
        make.edges.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(100));
    }];
    
    CGFloat width = (SCREEN_W - AUTO_MARGIN(55))/2.0;
    
    UIView *timeView = [[UIView alloc] init];
    [contentView addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(contentView);
        make.width.mas_equalTo(width);
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(20));
    }];
    timeView.backgroundColor = [ZCConfigColor whiteColor];
    [timeView setViewCornerRadiu:10];
    
    UIView *numView = [[UIView alloc] init];
    [contentView addSubview:numView];
    [numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(contentView);
        make.width.mas_equalTo(width);
        make.leading.mas_equalTo(timeView.mas_trailing).offset(AUTO_MARGIN(15));
    }];
    numView.backgroundColor = [ZCConfigColor whiteColor];
    [numView setViewCornerRadiu:10];
    
    [self setupTargetViewSubviews:timeView type:0];
    [self setupTargetViewSubviews:numView type:1];
}

- (void)setupTargetViewSubviews:(UIView *)targetView type:(NSInteger)type {
    NSString *titleStr = @"";
    NSString *contentStr = @"";
    UILabel *contentL = [self createSimpleLabelWithTitle:@"" font:20 bold:YES color:[ZCConfigColor txtColor]];
    if (type == 1) {
        titleStr = NSLocalizedString(@"动作", nil);
        contentStr = @"0";
        self.numL = contentL;
    } else {
        titleStr = NSLocalizedString(@"时长", nil);
        contentStr = @"00:00:00";
        self.timeL = contentL;
    }
    contentL.text = contentStr;
    
    UILabel *lb = [self createSimpleLabelWithTitle:titleStr font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor txtColor]];
    [targetView addSubview:lb];
    [targetView addSubview:contentL];
    
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(targetView.mas_centerX);
        make.top.mas_equalTo(targetView.mas_top).offset(AUTO_MARGIN(25));
    }];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lb.mas_centerX);
        make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(12));
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSMutableArray *temArr = [NSMutableArray array];
    NSArray *actionList = dataDic[@"actionList"];
    NSInteger mouse = 0;
    for (NSDictionary *dic in actionList) {
        if ([dic[@"rest"] integerValue] == 1) {
            mouse += [dic[@"duration"] integerValue];
        } else {
            mouse += [dic[@"duration"] integerValue];
            [temArr addObject:dic];
        }
    }
    self.numL.text = [NSString stringWithFormat:@"%tu", temArr.count];
    self.timeL.text = [ZCDataTool convertMouseToTimeString:mouse];
    
}

@end

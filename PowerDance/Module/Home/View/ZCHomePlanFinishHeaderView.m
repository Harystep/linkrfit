//
//  ZCHomePlanFinishHeaderView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/28.
//

#import "ZCHomePlanFinishHeaderView.h"
#import "ZCHomePlanTimeView.h"

@interface ZCHomePlanFinishHeaderView ()

@property (nonatomic,strong) ZCHomePlanTimeView *timeView;

@end

@implementation ZCHomePlanFinishHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *assignView = [[UIView alloc] init];
    [self addSubview:assignView];
    assignView.backgroundColor = rgba(138, 205, 215, 1);
    [assignView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(14);
        make.top.mas_equalTo(self.mas_top).offset(20);
        make.leading.mas_equalTo(self.mas_leading).offset(20);
    }];
    [assignView setViewCornerRadiu:1.5];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"你的专属家庭训练计划", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(assignView.mas_centerY);
        make.leading.mas_equalTo(assignView.mas_trailing).offset(AUTO_MARGIN(5));
    }];
    
    UIButton *setBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"重新设定", nil) font:AUTO_MARGIN(10) color:rgba(138, 205, 215, 1)];
    [self addSubview:setBtn];
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(assignView.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(AUTO_MARGIN(60));
    }];
    [setBtn setViewCornerRadiu:12];
    [setBtn setViewBorderWithColor:1 color:rgba(138, 205, 215, 1)];
    [setBtn addTarget:self action:@selector(resetPlanOperate) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *timeView = [[UIView alloc] init];
    [self addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(titleL.mas_bottom).offset(20);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(self.mas_bottom).inset(10);
    }];
    
    UIButton *listBtn = [[UIButton alloc] init];
    [timeView addSubview:listBtn];
    [listBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(timeView.mas_centerY);
        make.trailing.mas_equalTo(timeView.mas_trailing).inset(AUTO_MARGIN(20));
        make.height.width.mas_equalTo(AUTO_MARGIN(15));
    }];
    [listBtn setImage:kIMAGE(@"home_plan_time_list") forState:UIControlStateNormal];
    [listBtn addTarget:self action:@selector(checkPlanList) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *sepIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_plan_time_sep")];
    [timeView addSubview:sepIv];
    [sepIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(listBtn.mas_centerY);
        make.trailing.mas_equalTo(listBtn.mas_leading).inset(AUTO_MARGIN(13));
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(33);
    }];
    
    self.timeView = [[ZCHomePlanTimeView alloc] init];
    [timeView addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(timeView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.bottom.mas_equalTo(timeView);
        make.trailing.mas_equalTo(sepIv.mas_leading).inset(AUTO_MARGIN(15));
    }];
    
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    self.timeView.selectTime = self.selectTime;
    self.timeView.dataArr = [self sortByDate:dataArr];
}

- (void)setSelectTime:(NSString *)selectTime {
    _selectTime = selectTime;
}

- (NSArray*)sortByDate:(NSArray*)objects
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSArray *sortedArray = [objects sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        NSDate *d1 = [df dateFromString: obj1];
        NSDate *d2 = [df dateFromString: obj2];
        return [d1 compare: d2];
    }];

    return sortedArray;
}

#pragma -- mark 查看训练计划列表
- (void)checkPlanList {
            
    [self routerWithEventName:@"planList" userInfo:@{}];
}

#pragma -- mark 重置训练计划信息
- (void)resetPlanOperate {
    [self routerWithEventName:@"ResetTrainPlanOp" userInfo:@{}];
}

@end

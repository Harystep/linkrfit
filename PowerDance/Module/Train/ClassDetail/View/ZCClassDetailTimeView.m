//
//  ZCClassDetailTimeView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/14.
//

#import "ZCClassDetailTimeView.h"

@interface ZCClassDetailTimeView ()

@property (nonatomic,strong) UILabel *energeL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *groupL;

@end

@implementation ZCClassDetailTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = rgba(43, 42, 51, 0.1);
    [self addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.width.mas_equalTo(1);
        make.leading.equalTo(self.mas_trailing).dividedBy(3);
        make.bottom.top.mas_equalTo(self);
    }];
    
    UIView *sep1View = [[UIView alloc] init];
    sep1View.backgroundColor = rgba(43, 42, 51, 0.1);
    [self addSubview:sep1View];
    [sep1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.width.mas_equalTo(1);
        make.leading.equalTo(self.mas_trailing).dividedBy(1.5);
        make.centerY.mas_equalTo(self);
    }];
    
    [self createSubViewsLeadView:self trailView:sepView type:0 title:NSLocalizedString(@"能量消耗", nil)];
    [self createSubViewsLeadView:sepView trailView:sep1View type:1 title:NSLocalizedString(@"时长", nil)];
    [self createSubViewsLeadView:sep1View trailView:self type:2 title:NSLocalizedString(@"动作组", nil)];

}

- (void)createSubViewsLeadView:(UIView *)leadView trailView:(UIView *)trailView type:(NSInteger)type title:(NSString *)title{
    UILabel *enTitleL = [self createSimpleLabelWithTitle:title font:14 bold:NO color:[ZCConfigColor txtColor]];
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
    
    UILabel *energeL = [self createSimpleLabelWithTitle:@"-" font:14 bold:YES color:[ZCConfigColor txtColor]];
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

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    double energy = 0.0;
    NSInteger time = 0;
    for (NSDictionary *dic in dataArr) {
        double itemEnergy = 0.0;
        NSInteger itemTime = 0.0;
        for (NSDictionary *itemDic in dic[@"itemList"]) {
            itemEnergy += [checkSafeContent(itemDic[@"energy"]) doubleValue] * [itemDic[@"duration"] integerValue]/60.0;
            itemTime += [itemDic[@"duration"] integerValue];
        }
        energy += itemEnergy * [dic[@"loop"] integerValue];
        time += itemTime * [dic[@"loop"] integerValue];
    }
    self.groupL.text = [NSString stringWithFormat:@"%tu", dataArr.count];
    self.timeL.text = [ZCDataTool convertMouseToTimeString:time];
    self.energeL.text = [ZCDataTool reviseString:[NSString stringWithFormat:@"%.1f", energy]];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.groupL.text = checkSafeContent(dataDic[@"count"]);
    self.timeL.text = [ZCDataTool convertMouseToMSTimeString:[checkSafeContent(dataDic[@"duration"]) integerValue]];
    NSString *en = checkSafeContent(dataDic[@"energy"]);
    NSString *contentStr = @"";
    if ([en doubleValue] > 0.0) {
        contentStr = [NSString stringWithFormat:@"%@KJ", en];
    } else {
        contentStr = @"--";
    }
    self.energeL.text = contentStr;
}

@end

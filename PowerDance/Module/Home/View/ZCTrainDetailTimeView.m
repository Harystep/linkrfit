//
//  ZCTrainDetailTimeView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/1.
//

#import "ZCTrainDetailTimeView.h"

@interface ZCTrainDetailTimeView ()

@property (nonatomic,strong) UILabel *energeL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *groupL;

@end

@implementation ZCTrainDetailTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = rgba(255, 255, 255, 0.2);
    [self addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.width.mas_equalTo(1);
        make.leading.equalTo(self.mas_trailing).dividedBy(3);
        make.top.mas_equalTo(self.mas_top);
        make.centerY.mas_equalTo(self);
    }];
    
    UIView *sep1View = [[UIView alloc] init];
    sep1View.backgroundColor = rgba(255, 255, 255, 0.2);
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
    UILabel *enTitleL = [self createSimpleLabelWithTitle:title font:14 bold:NO color:rgba(255, 255, 255, 0.5)];
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
    
    UILabel *energeL = [self createSimpleLabelWithTitle:@"-" font:20 bold:YES color:rgba(255, 255, 255, 1)];
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

@end

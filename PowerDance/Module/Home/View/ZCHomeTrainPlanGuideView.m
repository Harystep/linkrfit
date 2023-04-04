//
//  ZCHomeTrainPlanGuideView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/29.
//

#import "ZCHomeTrainPlanGuideView.h"
#import "ZCHomeTrainSelectTargetGuideView.h"
#import "ZCHomeTrainSelectEquipmentGuideView.h"
#import "ZCHomeTrainPlanExperienceGuideView.h"
#import "ZCHomeTrainPlanTimeGuideView.h"
#import "ZCHomeTrainPlanAgeGuideView.h"
#import "ZCHomeTrainPlanWeightGuideView.h"
#import "ZCHomeTrainPlanHeightGuideView.h"
#import "ZCHomeTrainPlanSexGuideView.h"
#import "ZCHomeTrainPlanWeightTargetGuideView.h"
#import "ZCHomeUserHealthyGuideView.h"
#import "ZCHomeTrainRangeGuideView.h"

@interface ZCHomeTrainPlanGuideView ()

@property (nonatomic,strong) UIView *containerView;//视图容器

@property (nonatomic,strong) ZCHomeTrainSelectTargetGuideView *targetView;//目标
@property (nonatomic,strong) ZCHomeTrainSelectEquipmentGuideView *equipmentView;//器械
@property (nonatomic,strong) ZCHomeTrainPlanExperienceGuideView *experienceView;// 经验
@property (nonatomic,strong) ZCHomeTrainPlanTimeGuideView *timeView;//  希望健身时长
@property (nonatomic,strong) ZCHomeTrainPlanWeightTargetGuideView *weightTargetView;//目标体重
@property (nonatomic,strong) ZCHomeTrainPlanSexGuideView *sexView;//性别
@property (nonatomic,strong) ZCHomeTrainPlanHeightGuideView *heightView;//身高
@property (nonatomic,strong) ZCHomeTrainPlanWeightGuideView *weightView;//体重
@property (nonatomic,strong) ZCHomeTrainPlanAgeGuideView *ageView;//年龄
@property (nonatomic,strong) ZCHomeUserHealthyGuideView *healthyView;//健康指数
@property (nonatomic,strong) ZCHomeTrainRangeGuideView *rangeView;//计划安排

@property (nonatomic,strong) UIButton *setBtn;//    提示当前步骤

@property (nonatomic,strong) NSMutableDictionary *parmDic;//设置参数

@end

@implementation ZCHomeTrainPlanGuideView

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
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"你的专属家庭训练计划", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(assignView.mas_centerY);
        make.leading.mas_equalTo(assignView.mas_trailing).offset(AUTO_MARGIN(5));
    }];
    
    UIButton *setBtn = [self createSimpleButtonWithTitle:[self convertEnTitleWithContent:@"1/9"] font:AUTO_MARGIN(12) color:rgba(138, 205, 215, 1)];
    self.setBtn = setBtn;
    [self addSubview:setBtn];
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(assignView.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(AUTO_MARGIN(60));
    }];
    setBtn.userInteractionEnabled = NO;
    [setBtn setViewCornerRadiu:12];
    [setBtn setViewBorderWithColor:1 color:rgba(138, 205, 215, 1)];
    
    self.containerView = [[UIView alloc] init];
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(titleL.mas_bottom).offset(20);
        make.height.mas_equalTo(232);
    }];
             
    [self.containerView addSubview:self.targetView];
    [self.targetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.containerView);
    }];
    
    self.parmDic = [NSMutableDictionary dictionary];
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    [ZCDataTool judgeUserMode];
    if ([eventName isEqualToString:@"target"]) {
        [self.containerView addSubview:self.equipmentView];
        [self.equipmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.containerView);
        }];
        NSInteger targetID = [userInfo[@"target"] integerValue] + 1; //健身目标
        [self.parmDic setValue:@(targetID) forKey:@"target"];
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"2/9"] forState:UIControlStateNormal];
    } else if ([eventName isEqualToString:@"equipmentNext"]) {
        NSArray *apparatusId = userInfo[@"apparatusId"];// 选择器械
        [self.containerView addSubview:self.experienceView];
        [self.experienceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.containerView);
        }];
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"3/9"] forState:UIControlStateNormal];
        [self.parmDic setValue:apparatusId forKey:@"apparatusId"];
        
    } else if ([eventName isEqualToString:@"experienceTag"]) {
        NSInteger experienceTag = [userInfo[@"experience"] integerValue] + 1;// 选择健身经验 0 1 2 + 1
        [self.containerView addSubview:self.timeView];
        [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.containerView);
        }];
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"4/9"] forState:UIControlStateNormal];
        [self.parmDic setValue:@(experienceTag) forKey:@"foundation"];
        
    } else if ([eventName isEqualToString:@"timeTrain"]) {//    健身时长
        NSInteger timeTrain = [userInfo[@"timeTrain"] integerValue] + 1; //0 1 2 +1
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"5/9"] forState:UIControlStateNormal];
        [self.containerView addSubview:self.weightView];
        [self.weightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.containerView);
        }];
        [self.parmDic setValue:@(timeTrain) forKey:@"sportsDuration"];
    } else if ([eventName isEqualToString:@"weightNext"]) {
                
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"6/9"] forState:UIControlStateNormal];
        [self.containerView addSubview:self.heightView];
        [self.heightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.containerView);
        }];
        NSString *weight = userInfo[@"weight"];//体重
        [self.parmDic setValue:weight forKey:@"weight"];
        
    } else if ([eventName isEqualToString:@"heightNext"]) {
        
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"7/9"] forState:UIControlStateNormal];
        [self.containerView addSubview:self.weightTargetView];
        [self.weightTargetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.containerView);
        }];
        NSString *height = userInfo[@"height"];//身高
        [self.parmDic setValue:height forKey:@"height"];
        
    } else if ([eventName isEqualToString:@"weightTargetNext"]) {
        
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"8/9"] forState:UIControlStateNormal];
        [self.containerView addSubview:self.sexView];
        [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.containerView);
        }];
        NSString *weightTarget = userInfo[@"weightTarget"];//目标体重
        [self.parmDic setValue:weightTarget forKey:@"targetWeight"];
        
    } else if ([eventName isEqualToString:@"sexNext"]) {
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"9/9"] forState:UIControlStateNormal];
        [self.containerView addSubview:self.ageView];
        [self.ageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.containerView);
        }];
        NSInteger sex = [userInfo[@"sex"] integerValue];//性别    1 男  2 女
        [self.parmDic setValue:@(sex) forKey:@"sex"];
        
    } else if([eventName isEqualToString:@"ageNext"]) {//生日
        NSString *birthday = userInfo[@"age"];
        [self.parmDic setValue:birthday forKey:@"birthday"];
        [self getUserTrainPlanHealthyInfo];
        self.setBtn.hidden = YES;
    } else if ([eventName isEqualToString:@"healthyNext"]) {//健康指数
        [self submitTrainPlanOperate];
    } else if ([eventName isEqualToString:@"rangeNext"]) {//使用计划
        [ZCDataTool saveHomeTrainPlanStatus:YES];
        [self routerWithEventName:@"refreshTrainPlan"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self resetTrainPlan];
        });
    } else if ([eventName isEqualToString:@"resetOperate"]) {//重新设置
        
        [self resetTrainPlan];
        
        [self.containerView addSubview:self.targetView];
        [self.targetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.containerView);
        }];
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"1/9"] forState:UIControlStateNormal];
        self.setBtn.hidden = NO;
        
    } else if ([eventName isEqualToString:@"equipmentBack"]) {
        [self.containerView bringSubviewToFront:self.targetView];
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"1/9"] forState:UIControlStateNormal];
    } else if ([eventName isEqualToString:@"experienceBack"]) {
        [self.containerView bringSubviewToFront:self.equipmentView];
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"2/9"] forState:UIControlStateNormal];
    } else if ([eventName isEqualToString:@"timeBack"]) {
        [self.containerView bringSubviewToFront:self.experienceView];
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"3/9"] forState:UIControlStateNormal];
    } else if ([eventName isEqualToString:@"weightBack"]) {//重新设置
        [self.containerView bringSubviewToFront:self.timeView];
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"4/9"] forState:UIControlStateNormal];
    } else if ([eventName isEqualToString:@"heightBack"]) {//重新设置
        [self.containerView bringSubviewToFront:self.weightView];
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"5/9"] forState:UIControlStateNormal];
    } else if ([eventName isEqualToString:@"weightTargetBack"]) {//重新设置
        [self.containerView bringSubviewToFront:self.heightView];
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"6/9"] forState:UIControlStateNormal];
    } else if ([eventName isEqualToString:@"sexBack"]) {//重新设置
        [self.containerView bringSubviewToFront:self.weightTargetView];
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"7/9"] forState:UIControlStateNormal];
    } else if ([eventName isEqualToString:@"ageBack"]) {//重新设置
        [self.containerView bringSubviewToFront:self.sexView];
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"8/9"] forState:UIControlStateNormal];
    } else if ([eventName isEqualToString:@"healthyBack"]) {//重新设置
        [self.containerView bringSubviewToFront:self.ageView];
        [self.setBtn setTitle:[self convertEnTitleWithContent:@"9/9"] forState:UIControlStateNormal];
        self.setBtn.hidden = NO;
    } else if ([eventName isEqualToString:@"rangeBack"]) {//重新设置
        [self.containerView bringSubviewToFront:self.healthyView];
        self.setBtn.hidden = YES;
    }
}

- (NSString *)convertEnTitleWithContent:(NSString *)content {
    return [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"步骤", nil), content];
}

#pragma -- mark 重新设置
- (void)resetTrainPlan {
    self.targetView = nil;
    self.equipmentView = nil;
    self.experienceView = nil;
    self.ageView = nil;
    self.weightView = nil;
    self.weightTargetView = nil;
    self.heightView = nil;
    self.timeView = nil;
    self.sexView = nil;
    self.healthyView = nil;
    self.rangeView = nil;
}
#pragma -- mark 上传训练计划
- (void)submitTrainPlanOperate {
    
    [ZCClassSportManage submitUserTrainPlanOperateURL:self.parmDic completeHandler:^(id  _Nonnull responseObj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.containerView addSubview:self.rangeView];
            [self.rangeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.containerView);
            }];
            self.rangeView.dataDic = responseObj[@"data"];
        });
    }];
}

#pragma -- mark 获取健康指数
- (void)getUserTrainPlanHealthyInfo {
    
    NSDictionary *parms = @{@"weight":self.parmDic[@"weight"],
                            @"height":self.parmDic[@"height"],
                            @"foundation":self.parmDic[@"foundation"],
                            @"sex":self.parmDic[@"sex"]
    };
    [ZCClassSportManage queryUserTrainHealthyInfoURL:parms completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.containerView addSubview:self.healthyView];
            [self.healthyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.containerView);
            }];
            self.healthyView.dataDic = responseObj[@"data"];
        });
    }];
}

- (ZCHomeTrainSelectEquipmentGuideView *)equipmentView {
    if (!_equipmentView) {
        _equipmentView = [[ZCHomeTrainSelectEquipmentGuideView alloc] init];
    }
    return _equipmentView;
}

- (ZCHomeTrainPlanExperienceGuideView *)experienceView {
    if (!_experienceView) {
        _experienceView = [[ZCHomeTrainPlanExperienceGuideView alloc] init];
    }
    return _experienceView;
}

- (ZCHomeTrainPlanTimeGuideView *)timeView {
    if (!_timeView) {
        _timeView = [[ZCHomeTrainPlanTimeGuideView alloc] init];
    }
    return _timeView;
}

- (ZCHomeTrainPlanWeightTargetGuideView *)weightTargetView {
    if (!_weightTargetView) {
        _weightTargetView = [[ZCHomeTrainPlanWeightTargetGuideView alloc] init];
    }
    return _weightTargetView;
}

- (ZCHomeTrainPlanAgeGuideView *)ageView {
    if (!_ageView) {
        _ageView = [[ZCHomeTrainPlanAgeGuideView alloc] init];
    }
    return _ageView;
}

- (ZCHomeTrainPlanSexGuideView *)sexView {
    if (!_sexView) {
        _sexView = [[ZCHomeTrainPlanSexGuideView alloc] init];
    }
    return _sexView;
}

- (ZCHomeTrainPlanHeightGuideView *)heightView {
    if (!_heightView) {
        _heightView = [[ZCHomeTrainPlanHeightGuideView alloc] init];
    }
    return _heightView;
}

- (ZCHomeTrainPlanWeightGuideView *)weightView {
    if (!_weightView) {
        _weightView = [[ZCHomeTrainPlanWeightGuideView alloc] init];
    }
    return _weightView;
}

- (ZCHomeUserHealthyGuideView *)healthyView {
    if (!_healthyView) {
        _healthyView = [[ZCHomeUserHealthyGuideView alloc] init];
    }
    return _healthyView;
}

- (ZCHomeTrainSelectTargetGuideView *)targetView {
    if (!_targetView) {
        _targetView = [[ZCHomeTrainSelectTargetGuideView alloc] init];
    }
    return _targetView;
}

- (ZCHomeTrainRangeGuideView *)rangeView {
    if (!_rangeView) {
        _rangeView = [[ZCHomeTrainRangeGuideView alloc] init];
    }
    return _rangeView;
}

@end

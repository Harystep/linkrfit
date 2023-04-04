//
//  CFFHomeLastWeightView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/10/13.
//

#import "CFFHomeLastWeightView.h"
#import "CFFChangeNickView.h"

@interface CFFHomeLastWeightView ()

@end

@implementation CFFHomeLastWeightView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.timeL = [self createSimpleLabelWithTitle:NSLocalizedString(@"尚未称量", nil) font:12 bold:NO color:RGBA_COLOR(255, 255, 255, 0.5)];
    [self addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self).inset(AUTO_MARGIN(15));
        make.height.mas_equalTo(AUTO_MARGIN(17));
    }];
    
    self.weightL = [self createSimpleLabelWithTitle:[NSString stringWithFormat:@"%.1f", [checkSafeContent(kUserStore.userData[@"weight"]) doubleValue]] font:40 bold:YES color:UIColor.whiteColor];
    [self addSubview:self.weightL];
    [self.weightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(52));
        make.leading.mas_equalTo(AUTO_MARGIN(15));
        make.height.mas_equalTo(AUTO_MARGIN(40));
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(16));
    }];
    
    self.unitL = [self createSimpleLabelWithTitle:@"KG" font:14 bold:NO color:UIColor.whiteColor];
    [self addSubview:self.unitL];
    [self.unitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.weightL.mas_trailing).offset(AUTO_MARGIN(5));
        make.bottom.mas_equalTo(self.weightL.mas_bottom).inset(AUTO_MARGIN(2));
    }];
    
    UIButton *cloudBtn = [[UIButton alloc] init];
    self.cloudBtn = cloudBtn;
    [self addSubview:cloudBtn];
    [cloudBtn addTarget:self action:@selector(cloudScaleOperate) forControlEvents:UIControlEventTouchUpInside];
    [cloudBtn setImage:kIMAGE(@"smart_cloud_icon") forState:UIControlStateNormal];
    [cloudBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(self.weightL.mas_centerY);
    }];
    
    UIButton *change = [[UIButton alloc] init];
    self.changeBtn = change;
    [change setImage:kIMAGE(@"home_weight_change") forState:UIControlStateNormal];
    [self addSubview:change];
    [change mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(cloudBtn.mas_leading).inset(AUTO_MARGIN(17));
        make.height.width.mas_equalTo(AUTO_MARGIN(40));
        make.centerY.mas_equalTo(cloudBtn.mas_centerY);
    }];
    [change addTarget:self action:@selector(changeWeight) forControlEvents:UIControlEventTouchUpInside];
    
    @weakify(self);

}

- (void)setValue:(double)value {
    _value = value;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.weightL.text = [NSString stringWithFormat:@"%.1f", value];
    });
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    if (dataArr.count > 0) {
        NSDictionary *first = dataArr[0];        
        self.timeL.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"最后称量：", nil), [self convertTimeFromContent:first[@"createTime"]]];
        self.weightL.text = [NSString stringWithFormat:@"%.1f", [checkSafeContent(kUserStore.userData[@"weight"]) doubleValue]];
    }
}

- (NSString *)convertTimeFromContent:(NSString *)content {
    NSString *time;
    time = [content substringWithRange:NSMakeRange(5, 11)];
    return time;
}

- (void)changeWeight {
    CFFChangeNickView *change = [[CFFChangeNickView alloc] init];
    change.title = NSLocalizedString(@"体重", nil);
    change.placeholder = NSLocalizedString(@"请输入您的体重", nil);
    change.tf.keyboardType = UIKeyboardTypeDecimalPad;
    change.unitL.hidden = NO;
    [change showAlertView];
    kweakself(self);
    change.SaveNickOperate = ^(NSString * _Nonnull name) {
        weakself.weightL.text = [NSString stringWithFormat:@"%.1f", [name doubleValue]];
        [weakself changeUserWeight:[NSString stringWithFormat:@"%.1f", [name doubleValue]]];
    };
}

- (void)changeUserWeight:(NSString *)value {
    double bmi = [value doubleValue] / ([kUserStore.userData[@"height"] doubleValue]*[kUserStore.userData[@"height"] doubleValue]/10000.0);
    NSString *bmiStr = [NSString stringWithFormat:@"%.1f", bmi];
    NSDictionary *parm = @{
        @"bfr":@(0),
        @"bmc":@(0),
        @"bmi":bmiStr,
        @"bmr":@(0),
        @"bpr":@(0),
        @"bwr":@(0),
        @"phyAge":@(0),
        @"sbw":@(0),
        @"score":@(0),
        @"slm":@(0),
        @"vfr":@(0),
        @"weight":value,
        @"weightB":@(0),
        @"impedance":@(0)
    };
    
    [kCFF_COMMON_STORE saveCloudWeightRecordOperate:parm Success:^(id  _Nullable responseObject) {
        [self changeBodyWeight:value];
    } failed:^(NSError * _Nonnull error) {
        
    }];
            
}

- (void)changeBodyWeight:(NSString *)value {
    [kCFF_PROFILE_STORE updateUserInfo:@{@"weight":value} success:^(id  _Nullable responseObject) {
        kCFF_COMMON_STORE.weight = [value doubleValue];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

- (void)cloudScaleOperate {
    [HCRouter router:@"SmartCloud" params:@{} viewController:self.superViewController animated:YES];
}

@end

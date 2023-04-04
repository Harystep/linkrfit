//
//  CFFHomeStandardView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/29.
//

#import "CFFHomeStandardView.h"
#import "ScaleAlgorithmTool.h"

#define kColorBlue RGBA_COLOR(174, 194, 228, 1)  //蓝
#define kColorBrown RGBA_COLOR(198, 138, 104, 1) //棕
#define kColorGreen RGBA_COLOR(69, 161, 138, 1) //绿

@interface CFFHomeStandardView ()

@property (nonatomic,strong) NSMutableArray *viewArr;

@end

@implementation CFFHomeStandardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.viewArr = [NSMutableArray array];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.alpha = 0.74;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    //rgba(44, 87, 76, 0.27)
    UIView *bmi = [[UIView alloc] init];
    [self addSubview:bmi];
    [bmi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.33);
    }];
    
    UIView *muscle = [[UIView alloc] init];
    [self addSubview:muscle];
    [muscle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.33);
    }];
    
    UIView *fat = [[UIView alloc] init];
    [self addSubview:fat];
    [fat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.leading.mas_equalTo(bmi.mas_trailing);
        make.trailing.mas_equalTo(muscle.mas_leading);
    }];
    
    [self createSubviewsOnTargetView:bmi tittle:@"BMI" status:YES];
    [self createSubviewsOnTargetView:fat tittle:NSLocalizedString(@"体脂率", nil) status:YES];
    [self createSubviewsOnTargetView:muscle tittle:NSLocalizedString(@"肌肉量", nil) status:NO];
    
}

- (void)createSubviewsOnTargetView:(UIView *)targetView tittle:(NSString *)title status:(BOOL)status {
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(title, nil) font:15 bold:NO color:RGBA_COLOR(44, 87, 76, 0.6)];
    [targetView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(targetView.mas_top).offset(AUTO_MARGIN(18));
        make.leading.mas_equalTo(targetView.mas_leading).offset(AUTO_MARGIN(15));
        make.height.mas_equalTo(AUTO_MARGIN(20));
    }];
    
    UILabel *statusL = [self createSimpleLabelWithTitle:@"" font:12 bold:NO color:UIColor.whiteColor];
    [targetView addSubview:statusL];
    [statusL setViewCornerRadiu:3];
    [statusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(lb.mas_trailing).offset(AUTO_MARGIN(8));
        make.centerY.mas_equalTo(lb.mas_centerY);
    }];
    
    UILabel *numL = [self createSimpleLabelWithTitle:@"--" font:18 bold:YES color:RGBA_COLOR(44, 87, 76, 1)];
    [targetView addSubview:numL];
    [numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(14));
        make.height.mas_equalTo(AUTO_MARGIN(24));
        make.leading.mas_equalTo(lb.mas_leading);
    }];
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:kIMAGE(@"home_otherData_down")];
    arrow.hidden = YES;
    UILabel *differL = [self createSimpleLabelWithTitle:@"--" font:13 bold:YES color:RGBA_COLOR(44, 87, 76, 1)];
    differL.hidden = YES;
    [targetView addSubview:differL];
    [targetView addSubview:arrow];
    arrow.contentMode = UIViewContentModeScaleToFill;
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(numL.mas_trailing).offset(AUTO_MARGIN(6));
        make.centerY.mas_equalTo(differL.mas_centerY);
        make.width.height.mas_equalTo(10);
    }];
    
    [differL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(arrow.mas_trailing).offset(AUTO_MARGIN(2));;
        make.height.mas_equalTo(AUTO_MARGIN(16));
        make.bottom.mas_equalTo(numL.mas_bottom).inset(AUTO_MARGIN(3));
    }];
    
    if (status) {
        UIView *sepView = [[UIView alloc] init];
        sepView.backgroundColor = RGBA_COLOR(44, 87, 76, 0.27);
        [targetView addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(targetView.mas_trailing);
            make.top.mas_equalTo(targetView.mas_top).offset(AUTO_MARGIN(26));
            make.height.mas_equalTo(AUTO_MARGIN(53));
            make.width.mas_equalTo(AUTO_MARGIN(1));
        }];
    }
    
    [self.viewArr addObject:numL];
    [self.viewArr addObject:differL];
    [self.viewArr addObject:statusL];
    [self.viewArr addObject:arrow];
}

- (void)setDataArr:(NSArray *)dataArr {
    
    if (dataArr.count > 0) {
        [self setSubViewsWithData:dataArr index:0 end:3 no:1];
        [self setSubViewsWithData:dataArr index:4 end:7 no:2];
        [self setSubViewsWithData:dataArr index:8 end:11 no:3];
    }
}

- (void)setSubViewsWithData:(NSArray *)dataArr index:(NSInteger)index end:(NSInteger)end no:(NSInteger)type {
    if (dataArr.count > 0) {
        NSDictionary *dict = dataArr[0];
        NSString *impedance = [CFFDataTool reviseString:checkSafeContent(dict[@"impedance"])];
        SicBiaAlgOutInfStr outInfo = [ScaleAlgorithmTool scaleAlgorithToolWithNum:[dict[@"weight"] doubleValue] Impedance:[impedance integerValue]];
        [self setStandViewTypeStatus:outInfo index:index type:type];
    }
}

- (void)setStandViewTypeStatus:(SicBiaAlgOutInfStr)outInfo index:(NSInteger)index type:(NSInteger)type {
    UILabel *numL = self.viewArr[index];
    UILabel *icon = self.viewArr[index+2];
    if (type == 1) {
        NSInteger status = outInfo.bmi_l;
        numL.text = [NSString stringWithFormat:@"%.1f", outInfo.BMI/100.0];
        if (status > 0) {
            icon.hidden = NO;
            if (status == 4) {
                icon.text = NSLocalizedString(@"偏低", nil);
                icon.backgroundColor = kColorBlue;
            } else if (status == 5) {
                icon.text = NSLocalizedString(@"标准", nil);
                icon.backgroundColor = kColorGreen;
            } else if (status > 5) {
                icon.text = NSLocalizedString(@"偏高", nil);
                icon.backgroundColor = kColorBrown;
            } else {
                icon.text = NSLocalizedString(@"偏低", nil);
                icon.backgroundColor = kColorBlue;
            }
        } else {
            icon.hidden = YES;
        }
    } else if (type == 2) {
        NSInteger status = outInfo.bfr_l;
        if (status > 0) {
            icon.hidden = NO;
            numL.text = [NSString stringWithFormat:@"%.1f", outInfo.BFR/100.0];
            if (status == 5) {
                icon.text = NSLocalizedString(@"标准", nil);
                icon.backgroundColor = kColorGreen;
            } else if (status > 5) {
                icon.text = NSLocalizedString(@"偏高", nil);
                icon.backgroundColor = kColorBrown;
            } else {
                icon.text = NSLocalizedString(@"偏低", nil);
                icon.backgroundColor = kColorBlue;
            }
        } else {
            icon.hidden = YES;
            numL.text = @"--";
        }
    } else {
        NSInteger status = outInfo.slm_l;
        if (status > 0) {
            icon.hidden = NO;
            numL.text = [NSString stringWithFormat:@"%.1f", outInfo.SLM/100.0];
            if (status == 4) {
                icon.text = NSLocalizedString(@"偏低", nil);
                icon.backgroundColor = kColorBlue;
            } else if (status == 5) {
                icon.text = NSLocalizedString(@"标准", nil);
                icon.backgroundColor = kColorGreen;
            } else if (status == 6) {
                icon.text = NSLocalizedString(@"优", nil);
                icon.backgroundColor = kColorGreen;
            } else {
                icon.text = NSLocalizedString(@"偏低", nil);
                icon.backgroundColor = kColorBlue;
            }
        } else {
            icon.hidden = YES;
            numL.text = @"--";
        }
    }
}

@end

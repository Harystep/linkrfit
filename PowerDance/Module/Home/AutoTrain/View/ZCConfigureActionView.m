//
//  ZCConfigureActionView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/25.
//

#import "ZCConfigureActionView.h"
#import "ZCSimpleTextView.h"
#import "ZCAlertPickerView.h"
#import "ZCAlertTimePickView.h"

@interface ZCConfigureActionView ()

@property (nonatomic,strong) UITextField *numF;
@property (nonatomic,strong) UITextField *timeF;
@property (nonatomic,strong) UILabel *timeTL;
@property (nonatomic,strong) ZCSimpleTextView *timeView;
@property (nonatomic,strong) UILabel *numTL;
@property (nonatomic,strong) ZCSimpleTextView *numView;

@end

@implementation ZCConfigureActionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"", nil) font:20 bold:YES color:[ZCConfigColor txtColor]];
    self.titleL = titleL;
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(30));
    }];
    
    UILabel *numTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"个数", nil) font:15 bold:NO color:[ZCConfigColor txtColor]];
    [self addSubview:numTL];
    self.numTL = numTL;
    [numTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGIN(48));
    }];
    
    ZCSimpleTextView *numView = [[ZCSimpleTextView alloc] init];
    self.numView = numView;
    [self addSubview:numView];
    [numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(numTL.mas_centerY);
        make.leading.mas_equalTo(numTL.mas_trailing).offset(AUTO_MARGIN(10));
        make.width.mas_equalTo(AUTO_MARGIN(78));
        make.height.mas_equalTo(AUTO_MARGIN(34));
    }];
    [numView.bgView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [numView setViewCornerRadiu:6];
    numView.contentF.text = @"0";
    numView.contentF.textAlignment = NSTextAlignmentCenter;
    numView.contentF.font = FONT_BOLD(20);
    numView.contentF.enabled = NO;
    self.numF = numView.contentF;
    UITapGestureRecognizer *numTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numViewOperate)];
    [numView addGestureRecognizer:numTap];
    
    ZCSimpleTextView *timeView = [[ZCSimpleTextView alloc] init];
    [self addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(numView.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(25));
        make.width.mas_equalTo(AUTO_MARGIN(132));
        make.height.mas_equalTo(AUTO_MARGIN(34));
    }];
    self.timeView = timeView;
    [timeView.bgView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [timeView setViewCornerRadiu:6];
    timeView.contentF.text = @"00:00:00";
    timeView.contentF.textAlignment = NSTextAlignmentCenter;
    timeView.contentF.font = FONT_BOLD(20);
    timeView.contentF.enabled = NO;
    self.timeF = timeView.contentF;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeViewOperate)];
    [timeView addGestureRecognizer:tap];
    
    UILabel *timeTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"时长", nil) font:15 bold:NO color:[ZCConfigColor txtColor]];
    self.timeTL = timeTL;
    [self addSubview:timeTL];
    [timeTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(timeView.mas_leading).inset(AUTO_MARGIN(10));
        make.centerY.mas_equalTo(timeView.mas_centerY);
    }];
    
    UIButton *sureBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"确定", nil) font:15 color:[ZCConfigColor whiteColor]];
    [self addSubview:sureBtn];
    sureBtn.backgroundColor = [ZCConfigColor txtColor];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(52));
        make.height.mas_equalTo(AUTO_MARGIN(56));
    }];
    [sureBtn addTarget:self action:@selector(sureOperate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setEnergy:(NSString *)energy {
    _energy = energy;
}

- (void)setRestStatus:(BOOL)restStatus {
    _restStatus = restStatus;
    [self.timeTL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(35));
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(AUTO_MARGIN(48));
    }];
    [self.timeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeTL.mas_centerY);
        make.leading.mas_equalTo(self.timeTL.mas_trailing).offset(AUTO_MARGIN(20));
        make.width.mas_equalTo(AUTO_MARGIN(132));
        make.height.mas_equalTo(AUTO_MARGIN(34));
    }];
    self.numTL.hidden = YES;
    self.numView.hidden = YES;
}

#pragma -- mark 点击数量
- (void)numViewOperate {
    ZCAlertPickerView *pick = [[ZCAlertPickerView alloc] init];
    [self addSubview:pick];
    [pick showAlertView];
    pick.titleL.text = NSLocalizedString(@"需要做的个数", nil);
    kweakself(self);
    pick.sureRepeatOperate = ^(NSString * _Nonnull content) {
        weakself.numF.text = content;
    };
}
#pragma -- mark 点击时间
- (void)timeViewOperate {
    ZCAlertTimePickView *pick = [[ZCAlertTimePickView alloc] init];
    [self addSubview:pick];
    [pick showAlertView];
    pick.titleL.text = NSLocalizedString(@"完成该动作限定的时间", nil);
    kweakself(self);
    pick.sureRepeatOperate = ^(NSString * _Nonnull content) {
        weakself.timeF.text = content;
    };
}

- (void)sureOperate {
    if (self.restStatus) {
    } else {
        if ([self.numF.text integerValue] == 0) {
            [self makeToast:NSLocalizedString(@"请设置动作个数", nil) duration:2.0 position:CSToastPositionCenter];
            return;
        }
    }
    NSString *timeStr = self.timeF.text;
    NSArray *timeArr = [timeStr componentsSeparatedByString:@":"];
    BOOL flag = YES;
    for (NSString *value in timeArr) {
        if ([value isEqualToString:@"00"]) {
        } else {
            flag = NO;
            break;
        }
    }
    if (flag) {
        [self makeToast:NSLocalizedString(@"请设置动作时间", nil) duration:2.0 position:CSToastPositionCenter];
        return;
    }
    if (self.saveActionTimeOperate) {
        NSDictionary *dic = @{@"count":self.numF.text, @"duration":self.timeF.text, @"energy":checkSafeContent(self.energy)};
        self.saveActionTimeOperate(dic);
    }
}

@end

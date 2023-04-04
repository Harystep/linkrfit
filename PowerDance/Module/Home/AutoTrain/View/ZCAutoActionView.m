//
//  ZCAutoActionView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/24.
//

#import "ZCAutoActionView.h"
#import "ZCSimpleTextView.h"

@interface ZCAutoActionView ()

@property (nonatomic,strong) UITextField *energeF;

@property (nonatomic,strong) ZCSimpleTextView *textView;

@end

@implementation ZCAutoActionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"自定义动作", nil) font:20 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(AUTO_MARGIN(20));
    }];
    
    ZCSimpleTextView *textView = [[ZCSimpleTextView alloc] init];
    self.textView = textView;
    [self addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGIN(15));
        make.height.mas_equalTo(AUTO_MARGIN(60));
    }];
    [textView.bgView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    textView.contentF.placeholder = NSLocalizedString(@"命名自己的动作", nil);
    
    UILabel *minuteL = [self createSimpleLabelWithTitle:NSLocalizedString(@"能量消耗（每分钟）", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [self addSubview:minuteL];
    [minuteL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(textView.mas_bottom).offset(AUTO_MARGIN(40));
    }];
    
    UITextField *energeF = [[UITextField alloc] init];
    self.energeF = energeF;
    energeF.text = @"0";
    energeF.font = FONT_BOLD(15);
    [self addSubview:energeF];
    [energeF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AUTO_MARGIN(74));
        make.height.mas_equalTo(AUTO_MARGIN(34));
        make.centerY.mas_equalTo(minuteL.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    energeF.textAlignment = NSTextAlignmentCenter;
    [energeF setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [energeF setViewCornerRadiu:6];
    
    UIButton *addBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"自定义动作", nil) font:14 color:[ZCConfigColor whiteColor]];
    addBtn.backgroundColor = [ZCConfigColor txtColor];
    [self addSubview:addBtn];
    [addBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleLeft space:5];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(energeF.mas_bottom).offset(AUTO_MARGIN(40));
        make.height.mas_equalTo(AUTO_MARGIN(52));
    }];
    [addBtn addTarget:self action:@selector(sureOperate) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)sureOperate {
    if (self.textView.contentF.text.length == 0) {
        [self makeToast:NSLocalizedString(@"请输入动作名称", nil) duration:2 position:CSToastPositionCenter];
        return;
    }
    NSDictionary *dic = @{@"name":self.textView.contentF.text,
                          @"energy":self.energeF.text
    };
    if (self.saveAutoActionOperate) {
        self.saveAutoActionOperate(dic);
    }
}

@end

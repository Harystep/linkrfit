//
//  ZCCustonActionEditCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/27.
//

#import "ZCCustonActionEditCell.h"

@interface ZCCustonActionEditCell ()



@end

@implementation ZCCustonActionEditCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *bgView = [[UIView alloc] init];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [bgView layoutIfNeeded];
    [self setupTargetViewShadow:bgView];
    
    UIButton *addBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"添加动作", nil) font:AUTO_MARGIN(13) color:[ZCConfigColor whiteColor]];
    addBtn.backgroundColor = [ZCConfigColor txtColor];
    [self.contentView addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addActionOperate) forControlEvents:UIControlEventTouchUpInside];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(10));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(33));
        make.height.mas_equalTo(AUTO_MARGIN(30));
    }];
    [addBtn setViewCornerRadiu:AUTO_MARGIN(15)];
    
    UIButton *restBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"添加休息", nil) font:AUTO_MARGIN(13) color:[ZCConfigColor txtColor]];
    [restBtn setViewColorAlpha:0.1 color:kColorHex(@"#ADADAD")];
    [self.contentView addSubview:restBtn];
    [restBtn addTarget:self action:@selector(restActionOperate) forControlEvents:UIControlEventTouchUpInside];
    [restBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(10));
        make.top.mas_equalTo(addBtn.mas_bottom).offset(AUTO_MARGIN(17));
        make.height.mas_equalTo(AUTO_MARGIN(30));
    }];
    [restBtn setViewCornerRadiu:AUTO_MARGIN(15)];
    
    [self setViewCornerRadiu:AUTO_MARGIN(10)];
}

- (void)addActionOperate {
    [self routerWithEventName:@"action" userInfo:@{}];
}

- (void)restActionOperate {
    [self routerWithEventName:@"rest" userInfo:@{}];
}

- (void)setupTargetViewShadow:(UIView *)view {
    view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = 10;
    view.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
    view.layer.shadowOffset = CGSizeMake(-24,0);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 20;
}

@end

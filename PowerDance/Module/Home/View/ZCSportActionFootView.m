//
//  ZCSportActionFootView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/25.
//

#import "ZCSportActionFootView.h"

@interface ZCSportActionFootView ()

@property (nonatomic,strong) UIView *colorView;

@end

@implementation ZCSportActionFootView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UIView *contentView = [[UIView alloc] init];
    [contentView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.bottom.mas_equalTo(self);
    }];
    UIView *sportView = [[UIView alloc] init];
    [contentView addSubview:sportView];
    [sportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView).offset(AUTO_MARGIN(13));
        make.height.mas_equalTo(AUTO_MARGIN(40));
        make.leading.trailing.mas_equalTo(contentView);
    }];
    
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = UIColor.whiteColor;
    [contentView addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.mas_equalTo(contentView);
        make.height.mas_equalTo(AUTO_MARGIN(10));
    }];
    
    [self createSubviewOnSportView:sportView];
}

- (void)createSubviewOnSportView:(UIView *)sport {
    
    UIView *color = [[UIView alloc] init];
    color.backgroundColor = rgba(250, 201, 3, 1);
    [sport addSubview:color];
    [color mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(sport);
        make.height.width.mas_equalTo(AUTO_MARGIN(10));
        make.leading.mas_equalTo(sport).offset(AUTO_MARGIN(21));
    }];
    [color setViewCornerRadiu:AUTO_MARGIN(5)];
    self.colorView = color;
    
    UIView *addView = [[UIView alloc] init];
    [addView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [sport addSubview:addView];
    [addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(sport);
        make.leading.mas_equalTo(color.mas_trailing).offset(AUTO_MARGIN(15));
        make.trailing.mas_equalTo(sport).inset(AUTO_MARGIN(20));
    }];
    
    UIButton *addBtn = [addView createSimpleButtonWithTitle:NSLocalizedString(@"添加动作", nil) font:AUTO_MARGIN(15) color:[ZCConfigColor txtColor]];
    [addBtn setImage:kIMAGE(@"sport_add") forState:UIControlStateNormal];
    [addView addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addSportOperate) forControlEvents:UIControlEventTouchUpInside];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(addView);
    }];
}

- (void)addSportOperate {
    if (self.addSportActionOperate) {
        self.addSportActionOperate();
    }
}

@end

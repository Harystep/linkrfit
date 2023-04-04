//
//  ZCSportGroupView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/1.
//

#import "ZCSportGroupView.h"
#import "ZCAlertPickerView.h"
#import "ZCAlertView.h"

@interface ZCSportGroupView ()

@property (nonatomic,strong) UILabel *groupL;

@property (nonatomic,strong) UILabel *numL;

@end

@implementation ZCSportGroupView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    [self setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    
    UIView *groupView = [[UIView alloc] init];
    [groupView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [self addSubview:groupView];
    [groupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(10));
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(13));
        make.width.mas_equalTo(AUTO_MARGIN(86));
        make.height.mas_equalTo(AUTO_MARGIN(34));
    }];
    [groupView setViewCornerRadiu:6];
    
    UIView *repeatView = [[UIView alloc] init];
    [repeatView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [self addSubview:repeatView];
    [repeatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(groupView);
        make.trailing.mas_equalTo(self).inset(AUTO_MARGIN(10));
        make.width.mas_equalTo(AUTO_MARGIN(71));
        make.height.mas_equalTo(AUTO_MARGIN(34));
    }];
    [groupView setViewCornerRadiu:6];
    
    UIView *sportView = [[UIView alloc] init];
    [self addSubview:sportView];
    [sportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).inset(AUTO_MARGIN(17));
        make.top.mas_equalTo(groupView.mas_bottom).offset(AUTO_MARGIN(17));
        make.height.mas_equalTo(AUTO_MARGIN(40));
        make.leading.trailing.mas_equalTo(self);
    }];
    
    [self createSubviewsOnGroupView:groupView];
    
    [self createSubviewsOnRepeatView:repeatView];
    
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
    [HCRouter router:@"TrainSportGroup" params:@{} viewController:self.superViewController animated:YES block:^(id  _Nonnull value) {
        
    }];
}

- (void)createSubviewsOnGroupView:(UIView *)group {
    UIImageView *icon = [[UIImageView alloc] initWithImage:kIMAGE(@"base_edit")];
    [group addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(group);
        make.trailing.mas_equalTo(group).inset(AUTO_MARGIN(8));
    }];
    
    UILabel *nameL = [self createSimpleLabelWithTitle:NSLocalizedString(@"动作组", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    self.groupL = nameL;
    nameL.textAlignment = NSTextAlignmentCenter;
    [group addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(group).offset(AUTO_MARGIN(2));
        make.trailing.mas_equalTo(icon.mas_leading).inset(AUTO_MARGIN(2));
        make.centerY.mas_equalTo(group);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNameOperate)];
    [group addGestureRecognizer:tap];
    
}

- (void)createSubviewsOnRepeatView:(UIView *)repeat {
    UILabel *numL = [self createSimpleLabelWithTitle:@"1" font:14 bold:YES color:[ZCConfigColor txtColor]];
    [repeat addSubview:numL];
    [numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(repeat);
        make.trailing.mas_equalTo(repeat).inset(AUTO_MARGIN(10));
    }];
    self.numL = numL;
    
    UILabel *nameL = [self createSimpleLabelWithTitle:NSLocalizedString(@"重复：", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    nameL.textAlignment = NSTextAlignmentCenter;
    [repeat addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(repeat).offset(AUTO_MARGIN(2));
        make.trailing.mas_equalTo(numL.mas_leading).inset(AUTO_MARGIN(2));
        make.centerY.mas_equalTo(repeat);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRepeatOperate)];
    [repeat addGestureRecognizer:tap];
}

- (void)tapRepeatOperate {
    kweakself(self);
    ZCAlertPickerView *pick = [[ZCAlertPickerView alloc] init];
    [self addSubview:pick];
    [pick showAlertView];
    pick.sureRepeatOperate = ^(NSString * _Nonnull content) {
        weakself.numL.text = content;
    };
}

- (void)tapNameOperate {
    kweakself(self);
    ZCAlertView *pick = [[ZCAlertView alloc] init];
    [pick showAlertView];
    pick.sureEditOperate = ^(NSString * _Nonnull content) {
        weakself.groupL.text = content;
    };
}

@end

//
//  ZCSportActionHeadView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/25.
//

#import "ZCSportActionHeadView.h"
#import "ZCAlertPickerView.h"
#import "ZCAlertView.h"

@interface ZCSportActionHeadView ()

@property (nonatomic,strong) UILabel *groupL;
@property (nonatomic,strong) UILabel *numL;

@end

@implementation ZCSportActionHeadView

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
    
    UIView *groupView = [[UIView alloc] init];
    [groupView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [contentView addSubview:groupView];
    [groupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(10));
        make.top.mas_equalTo(contentView.mas_top).offset(AUTO_MARGIN(13));
        make.width.mas_equalTo(AUTO_MARGIN(86));
        make.height.mas_equalTo(AUTO_MARGIN(34));
    }];
    [groupView setViewCornerRadiu:6];
    
    UIView *repeatView = [[UIView alloc] init];
    [repeatView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [contentView addSubview:repeatView];
    [repeatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(groupView);
        make.trailing.mas_equalTo(contentView).inset(AUTO_MARGIN(10));
        make.width.mas_equalTo(AUTO_MARGIN(71));
        make.height.mas_equalTo(AUTO_MARGIN(34));
    }];
    [groupView setViewCornerRadiu:6];
    
    [self createSubviewsOnGroupView:groupView];
    
    [self createSubviewsOnRepeatView:repeatView];
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
        if (weakself.changeGroupLoopOperate) {
            weakself.changeGroupLoopOperate(content);
        }
    };
}

- (void)tapNameOperate {
    kweakself(self);
    ZCAlertView *pick = [[ZCAlertView alloc] init];
    [pick showAlertView];
    pick.sureEditOperate = ^(NSString * _Nonnull content) {
        weakself.groupL.text = content;
        if (weakself.changeGroupNameOperate) {
            weakself.changeGroupNameOperate(content);
        }
    };
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.groupL.text = dataDic[@"title"];
    self.numL.text = dataDic[@"loop"];
}

@end

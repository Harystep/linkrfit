//
//  ZCClassPlayFinishTopView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/6.
//

#import "ZCClassPlayFinishTopView.h"

@interface ZCClassPlayFinishTopView ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UILabel *contentL;

@property (nonatomic,strong) UILabel *timeL;

@property (nonatomic,strong) UILabel *groupL;

@property (nonatomic,strong) UILabel *playTimeL;

@end

@implementation ZCClassPlayFinishTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
  
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"恭喜你完成训练!", nil) font:20 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self).offset(AUTO_MARGIN(20));
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [ZCConfigColor whiteColor];
    [self addSubview:contentView];
    [contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(30));
        make.height.mas_equalTo(AUTO_MARGIN(205));
    }];
    
    UILabel *subL = [self createSimpleLabelWithTitle:NSLocalizedString(@"为你推荐", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:subL];
    [subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(contentView.mas_bottom).offset(AUTO_MARGIN(30));
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(10));
    }];
    
    [self setupContentSubViews:contentView];
    
}

- (void)setupContentSubViews:(UIView *)contentView {
    self.iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"profile_user_icon")];
    [contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(contentView).offset(AUTO_MARGIN(20));
        make.height.width.mas_equalTo(AUTO_MARGIN(40));
    }];
    [self.iconIv setViewCornerRadiu:AUTO_MARGIN(20)];
    
    self.nameL = [self createSimpleLabelWithTitle:@"1212" font:14 bold:NO color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconIv.mas_centerY);
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(10));
    }];
    
    self.contentL = [self createSimpleLabelWithTitle:@"KK燃脂速成" font:20 bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(AUTO_MARGIN(30));
    }];
    
    self.timeL = [self createSimpleLabelWithTitle:@"2005/08/01" font:14 bold:NO color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.contentL.mas_bottom).offset(AUTO_MARGIN(20));
    }];
 
    self.groupL = [self createSimpleLabelWithTitle:@"动作数：7" font:14 bold:NO color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.groupL];
    [self.groupL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.timeL.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    
    self.playTimeL = [self createSimpleLabelWithTitle:@"总时长：00:32" font:14 bold:NO color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.playTimeL];
    [self.playTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(self.groupL.mas_centerY);
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.contentL.text = checkSafeContent(dataDic[@"title"]);
    NSArray *actionList = [ZCDataTool convertEffectiveData:dataDic[@"actionList"]];
    NSMutableArray *temArr = [NSMutableArray array];
    for (NSDictionary *dic in actionList) {
        NSDictionary *courseAction = dic[@"courseAction"];
        if ([courseAction[@"rest"] integerValue] == 1 || [courseAction[@"name"] isEqualToString:NSLocalizedString(@"休息", nil)]) {
        } else {
            [temArr addObject:dic];
        }
    }
    self.groupL.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"动作组", nil), @(temArr.count)];
    NSInteger time = [checkSafeContent(dataDic[@"duration"]) integerValue];
    self.playTimeL.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"总时长", nil), [ZCDataTool convertMouseToTimeString:time]];
    self.timeL.text = [NSDate convertStringFormDate:[NSDate date] format:@"yyyy/MM/dd hh:mm"];
}

- (void)setUserDic:(NSDictionary *)userDic {
    _userDic = userDic;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(userDic[@"imgUrl"])] placeholderImage:kIMAGE(@"profile_user_icon")];
    self.nameL.text = checkSafeContent(userDic[@"nickName"]);
}

@end

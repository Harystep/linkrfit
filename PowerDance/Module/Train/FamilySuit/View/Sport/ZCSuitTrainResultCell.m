//
//  ZCSuitTrainSimpleCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/8/1.
//

#import "ZCSuitTrainResultCell.h"

@interface ZCSuitTrainResultCell ()

@property (nonatomic,strong) UILabel *timeL;

@property (nonatomic,strong) UILabel *targetL;

@property (nonatomic,strong) UILabel *finishL;

@property (nonatomic,strong) UIButton *statusBtn;

@property (nonatomic,strong) UIImageView *iconIv;

@end

@implementation ZCSuitTrainResultCell

+ (instancetype)suitTrainResultCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCSuitTrainResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCSuitTrainResultCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *contentView = [[UIView alloc] init];
    [self.contentView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.contentView).inset(AUTO_MARGIN(15));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(AUTO_MARGIN(90));
    }];
    contentView.backgroundColor = [ZCConfigColor whiteColor];
    [contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    UIImageView *iconIv = [[UIImageView alloc] init];
    [contentView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(AUTO_MARGIN(40));
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(contentView.mas_centerY);
    }];
    iconIv.backgroundColor = [ZCConfigColor bgColor];
    self.iconIv = iconIv;
    
    UILabel *timeTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"训练时长", nil) font:AUTO_MARGIN(12) bold:NO color:[ZCConfigColor subTxtColor]];
    [contentView addSubview:timeTL];
    [timeTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(AUTO_MARGIN(25));
        make.top.mas_equalTo(contentView.mas_top).offset(AUTO_MARGIN(25));
    }];
    
    UILabel *finishTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"完成个数", nil) font:AUTO_MARGIN(12) bold:NO color:[ZCConfigColor subTxtColor]];
    [contentView addSubview:finishTL];
    [finishTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(AUTO_MARGIN(25));
        make.top.mas_equalTo(timeTL.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    
    self.timeL = [self createSimpleLabelWithTitle:@" " font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(timeTL.mas_centerY);
        make.leading.mas_equalTo(timeTL.mas_trailing).offset(AUTO_MARGIN(10));
    }];
    
    self.finishL = [self createSimpleLabelWithTitle:@"100个" font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.finishL];
    [self.finishL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(finishTL.mas_centerY);
        make.leading.mas_equalTo(finishTL.mas_trailing).offset(AUTO_MARGIN(10));
    }];
    
    UILabel *targetTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"设定目标", nil) font:AUTO_MARGIN(12) bold:NO color:[ZCConfigColor subTxtColor]];
    [contentView addSubview:targetTL];
    [targetTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(timeTL.mas_centerY);
        make.centerX.mas_equalTo(contentView.mas_centerX).offset(AUTO_MARGIN(75));
    }];
    
    self.targetL = [self createSimpleLabelWithTitle:@"95个" font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.targetL];
    [self.targetL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(targetTL.mas_centerY);
        make.leading.mas_equalTo(targetTL.mas_trailing).offset(AUTO_MARGIN(10));
    }];
        
    self.statusBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"😊已完成目标", nil) font:AUTO_MARGIN(12) color:rgba(76, 217, 149, 1)];
    [contentView addSubview:self.statusBtn];
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(finishTL.mas_centerY);
        make.leading.mas_equalTo(self.finishL.mas_trailing).offset(AUTO_MARGIN(10));
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.targetL.text = [NSString stringWithFormat:@"%@%@", checkSafeContent(dataDic[@"num"]), NSLocalizedString(@"end_个", nil)];
    self.finishL.text = [NSString stringWithFormat:@"%@%@", checkSafeContent(dataDic[@"trainCount"]), NSLocalizedString(@"end_个", nil)];
    NSInteger targetNum = [checkSafeContent(dataDic[@"num"]) integerValue];
    NSInteger trainNum = [checkSafeContent(dataDic[@"trainCount"]) integerValue];
    NSString *desc;
    UIColor *color;
    if (targetNum == trainNum) {
        desc = NSLocalizedString(@"😊已完成目标", nil);
        color = rgba(76, 217, 149, 1);
    } else {
        desc = NSLocalizedString(@"😔未完成目标", nil);
        color = rgba(224, 32, 32, 1);
    }
    [self.statusBtn setTitleColor:color forState:UIControlStateNormal];
    [self.statusBtn setTitle:desc forState:UIControlStateNormal];
    
    NSInteger mouse = [checkSafeContent(dataDic[@"trainTime"]) integerValue];
    self.timeL.text = [NSString stringWithFormat:@"%@%@", [ZCDataTool convertMouseToMSTimeString:mouse], NSLocalizedString(@"end_分", nil)];
    
}

@end

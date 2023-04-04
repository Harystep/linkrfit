//
//  ZCHomePlanClassCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/25.
//

#import "ZCHomePlanClassCell.h"

@interface ZCHomePlanClassCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UILabel *descL;

@property (nonatomic,strong) UILabel *statusL;

@property (nonatomic,strong) UIView *finishView;//标记已完成

@end

@implementation ZCHomePlanClassCell

+ (instancetype)homePlanClassCell:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCHomePlanClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCHomePlanClassCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
            
    self.iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@" ")];
    self.iconIv.contentMode = UIViewContentModeScaleAspectFill;
    self.iconIv.clipsToBounds = YES;
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(AUTO_MARGIN(20));
        make.width.mas_equalTo(AUTO_MARGIN(120));
        make.height.mas_equalTo(AUTO_MARGIN(75));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    [self.iconIv setViewCornerRadiu:AUTO_MARGIN(10)];
    
    self.titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@" ", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.titleL];
    [self.titleL setContentLineFeedStyle];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(10));
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(12));
        make.top.mas_equalTo(self.iconIv).offset(AUTO_MARGIN(10));
    }];
    
    self.descL = [self createSimpleLabelWithTitle:NSLocalizedString(@" ", nil) font:AUTO_MARGIN(11) bold:NO color:[ZCConfigColor point8TxtColor]];
    [self.contentView addSubview:self.descL];
    [self.descL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(10));
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(AUTO_MARGIN(6));
        make.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(10));
    }];
    
    self.statusL = [self createSimpleLabelWithTitle:NSLocalizedString(@"该课程还未完成", nil) font:AUTO_MARGIN(11) bold:NO color:[ZCConfigColor subTxtColor]];
    [self.contentView addSubview:self.statusL];
    [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(10));
        make.bottom.mas_equalTo(self.iconIv.mas_bottom).inset(AUTO_MARGIN(6));
    }];
    
    self.finishView = [[UIView alloc] init];
    [self.contentView addSubview:self.finishView];
    [self.finishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.statusL.mas_leading);
        make.bottom.mas_equalTo(self.iconIv.mas_bottom).inset(AUTO_MARGIN(6));
        make.height.mas_equalTo(AUTO_MARGIN(16));
    }];
    self.finishView.backgroundColor = [ZCConfigColor bgColor];
    [self.finishView setViewCornerRadiu:3];
    self.finishView.hidden = YES;
    
    [self createFinishViewSubviews];
}

- (void)createFinishViewSubviews {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_plan_train_finish")];
    [self.finishView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.finishView.mas_centerY);
        make.leading.mas_equalTo(self.finishView.mas_leading).offset(AUTO_MARGIN(5));
        make.height.width.mas_equalTo(AUTO_MARGIN(11));
    }];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"已完成", nil) font:10 bold:NO color:[ZCConfigColor point6TxtColor]];
    [self.finishView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(AUTO_MARGIN(2));
        make.centerY.mas_equalTo(iconIv.mas_centerY);
        make.trailing.mas_equalTo(self.finishView.mas_trailing).inset(AUTO_MARGIN(5));
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSDictionary *courseDic = dataDic[@"course"];
    self.titleL.text = checkSafeContent(courseDic[@"title"]);
    NSString *time = [ZCDataTool convertMouseToMSUnitString:[checkSafeContent(courseDic[@"duration"]) integerValue]];
    if (checkSafeContent(courseDic[@"difficultyTag"]).length == 0) {
        self.descL.text = [NSString stringWithFormat:@"%@ · %@%@", time, checkSafeContent(courseDic[@"energy"]), NSLocalizedString(@"千卡", nil)];
    } else {
        self.descL.text = [NSString stringWithFormat:@"%@ · %@ · %@%@", checkSafeContent(courseDic[@"difficultyTag"]), time, checkSafeContent(courseDic[@"energy"]), NSLocalizedString(@"千卡", nil)];
    }
    NSString *iconStr = checkSafeContent(courseDic[@"cover"]);
    if (iconStr.length == 0) {
        iconStr = checkSafeContent(dataDic[@"cover"]);
    }
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:nil];
    if ([dataDic[@"status"] integerValue] == 1) {
        self.finishView.hidden = NO;
        self.statusL.hidden = YES;
        [self configureTitleColorStatus:YES];
    } else {
        self.finishView.hidden = YES;
        self.statusL.hidden = NO;
        [self configureTitleColorStatus:NO];
    }
}

- (void)configureTitleColorStatus:(BOOL)status {
    UIColor *color;
    if (status) {
        color = [ZCConfigColor point6TxtColor];
    } else {
        color = [ZCConfigColor txtColor];
    }
    self.titleL.textColor = color;
    self.descL.textColor = color;
}

@end

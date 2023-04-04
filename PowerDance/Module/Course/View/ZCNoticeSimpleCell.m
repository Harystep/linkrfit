//
//  ZCNoticeSimpleCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/5.
//

#import "ZCNoticeSimpleCell.h"
@interface ZCNoticeSimpleCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UILabel *descL;

@property (nonatomic,strong) UILabel *numL;

@end

@implementation ZCNoticeSimpleCell

+ (instancetype)noticeSimpleCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCNoticeSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCNoticeSimpleCell" forIndexPath:indexPath];
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
    
    self.numL = [self createSimpleLabelWithTitle:NSLocalizedString(@"  ", nil) font:AUTO_MARGIN(11) bold:NO color:[ZCConfigColor subTxtColor]];
    [self.contentView addSubview:self.numL];
    [self.numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(10));
        make.bottom.mas_equalTo(self.iconIv.mas_bottom).inset(AUTO_MARGIN(9));
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titleL.text = checkSafeContent(dataDic[@"title"]);
    NSString *time = [ZCDataTool convertMouseToMSUnitString:[checkSafeContent(dataDic[@"duration"]) integerValue]];
    if (checkSafeContent(dataDic[@"difficultyTag"]).length == 0) {
        self.descL.text = [NSString stringWithFormat:@"%@ · %@%@", time, checkSafeContent(dataDic[@"energy"]), NSLocalizedString(@"千卡", nil)];
    } else {
        self.descL.text = [NSString stringWithFormat:@"%@ · %@ · %@%@", checkSafeContent(dataDic[@"difficultyTag"]), time, checkSafeContent(dataDic[@"energy"]), NSLocalizedString(@"千卡", nil)];
    }
    NSString *iconStr = checkSafeContent(dataDic[@"cover"]);
    if (iconStr.length == 0) {
        iconStr = checkSafeContent(dataDic[@"cover"]);
    }
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:nil];
    NSInteger count = [checkSafeContent(dataDic[@"usedCount"]) integerValue];
    if (count > 0) {
        self.numL.text = [NSString stringWithFormat:@"%tu%@", count, NSLocalizedString(@"人练过", nil)];
    } else {
        self.numL.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"暂无人训练", nil)];
    }
}

@end

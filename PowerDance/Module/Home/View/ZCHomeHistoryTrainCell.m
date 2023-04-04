//
//  ZCHomeHistoryTrainCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/29.
//

#import "ZCHomeHistoryTrainCell.h"

@interface ZCHomeHistoryTrainCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UILabel *timeL;

@end

@implementation ZCHomeHistoryTrainCell

+ (instancetype)homeHistoryTrainCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCHomeHistoryTrainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCHomeHistoryTrainCell" forIndexPath:indexPath];
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
    
    self.iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_reduce")];
    self.iconIv.contentMode = UIViewContentModeScaleAspectFill;
    self.iconIv.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(AUTO_MARGIN(20));
        make.width.mas_equalTo(AUTO_MARGIN(160));
        make.height.mas_equalTo(AUTO_MARGIN(100));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    
    self.titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"通用减脂", nil) font:16 bold:YES color:rgba(255, 255, 255, 1)];    
    [self.iconIv addSubview:self.titleL];
    [self.titleL setContentLineFeedStyle];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_leading).offset(AUTO_MARGIN(15));
        make.trailing.mas_equalTo(self.iconIv.mas_trailing).inset(10);
        make.top.mas_equalTo(self.iconIv).offset(AUTO_MARGIN(22));
    }];
    
    self.timeL = [self createSimpleLabelWithTitle:@"" font:16 bold:NO color:[ZCConfigColor txtColor]];
    self.timeL.numberOfLines = 0;
    self.timeL.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(30));
        make.centerY.mas_equalTo(self.iconIv.mas_centerY);
        make.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(10));
    }];
    
    [self configTimeView:self.timeL time:@"2021-10-10 12:08:22"];
}

- (void)configTimeView:(UILabel *)timeL time:(NSString *)time {
    if (time.length > 16) {
        NSArray *timeArr = [time componentsSeparatedByString:@" "];
        NSString *endStr = timeArr[1];
        NSString *timeStr = [NSString stringWithFormat:@"%@\n%@", timeArr[0], [endStr substringWithRange:NSMakeRange(0, 5)]];
        self.timeL.text = timeStr;
    }
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titleL.text = checkSafeContent(dataDic[@"name"]);
    [self configTimeView:self.titleL time:checkSafeContent(dataDic[@"createTime"])];
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"cover"])] placeholderImage:kIMAGE(@"train_reduce")];
}

@end

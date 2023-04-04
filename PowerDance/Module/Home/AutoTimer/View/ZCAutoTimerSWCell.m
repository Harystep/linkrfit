//
//  ZCAutoTimerSWCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/24.
//

#import "ZCAutoTimerSWCell.h"

@interface ZCAutoTimerSWCell ()

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UILabel *minuteL;

@end

@implementation ZCAutoTimerSWCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)autoTimerSWCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCAutoTimerSWCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCAutoTimerSWCell" forIndexPath:indexPath];
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
    
    self.titleL = [self createSimpleLabelWithTitle:@"" font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(32));
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(20));
    }];
    
    self.minuteL = [self createSimpleLabelWithTitle:@"" font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.minuteL];
    [self.minuteL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(20));
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titleL.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"计次", nil), dataDic[@"title"]];
    self.minuteL.text = dataDic[@"content"];
}

@end

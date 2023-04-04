//
//  ZCSuitTestResultItemCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/8/2.
//

#import "ZCSuitTestResultItemCell.h"

@interface ZCSuitTestResultItemCell ()

@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *scoreL;

@end

@implementation ZCSuitTestResultItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)suitTestItemCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCSuitTestResultItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCSuitTestResultItemCell" forIndexPath:indexPath];
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
    
    self.timeL = [self createSimpleLabelWithTitle:@"2022-08-01 10:22" font:AUTO_MARGIN(12) bold:NO color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(10));
    }];
    
    self.scoreL = [self createSimpleLabelWithTitle:@"90分" font:AUTO_MARGIN(14) bold:YES color:rgba(250, 100, 0, 1)];
    [self.contentView addSubview:self.scoreL];
    [self.scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(self.timeL.mas_centerY);
    }];
    
}

@end

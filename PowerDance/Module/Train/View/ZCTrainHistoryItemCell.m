//
//  ZCTrainHistoryItemCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/8/29.
//

#import "ZCTrainHistoryItemCell.h"

@interface ZCTrainHistoryItemCell ()

@property (nonatomic,strong) UILabel *titleL;

@end

@implementation ZCTrainHistoryItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)trainHistoryItemCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCTrainHistoryItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCTrainHistoryItemCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [ZCConfigColor bgColor];
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.titleL = [self createSimpleLabelWithTitle:@"1990/07/10的训练" font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self.contentView).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(16));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(10));
    }];
    
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_simple_arrow")];
    [self.contentView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleL.mas_centerY);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titleL.text = [NSString stringWithFormat:@"%@%@", checkSafeContent(dataDic[@"trainTime"]), NSLocalizedString(@"的训练", nil)];
}

@end

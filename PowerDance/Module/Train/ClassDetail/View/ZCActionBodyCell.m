//
//  ZCActionBodyCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/15.
//

#import "ZCActionBodyCell.h"

@interface ZCActionBodyCell ()

@property (nonatomic,strong) UIImageView *firstIv;
@property (nonatomic,strong) UIImageView *secordIv;

@end

@implementation ZCActionBodyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)actionBodyCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCActionBodyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCActionBodyCell" forIndexPath:indexPath];
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
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"肌肉主要示意图", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(20));
    }];
    
//    CGFloat margin = (SCREEN_W - AUTO_MARGIN(160)*2) / 3.0;
    self.firstIv = [[UIImageView alloc] init];
    [self.firstIv setViewContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:self.firstIv];
    [self.firstIv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.leading.mas_equalTo(self.contentView.mas_leading).offset(margin);
        make.trailing.leading.mas_equalTo(self.contentView);
        make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(30));
//        make.width.mas_equalTo(AUTO_MARGIN(160));
        make.height.mas_equalTo(AUTO_MARGIN(260));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(30));
    }];
    
//    self.secordIv = [[UIImageView alloc] init];
//    self.secordIv.hidden = YES;
//    [self.secordIv setViewContentMode:UIViewContentModeScaleAspectFit];
//    [self.contentView addSubview:self.secordIv];
//    [self.secordIv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_equalTo(self.firstIv.mas_trailing).offset(margin);
//        make.top.mas_equalTo(self.firstIv.mas_top);
//        make.width.mas_equalTo(AUTO_MARGIN(160));
//        make.height.mas_equalTo(AUTO_MARGIN(260));
//    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSDictionary *actionDic = dataDic[@"action"];
    [self.firstIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(actionDic[@"muscleUrl"])] placeholderImage:nil];
}

@end

//
//  ZCEquipmentDescCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/15.
//

#import "ZCEquipmentDescCell.h"

@interface ZCEquipmentDescCell ()

@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *subL;

@end

@implementation ZCEquipmentDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)equipmentDescCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCEquipmentDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCEquipmentDescCell" forIndexPath:indexPath];
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
    self.nameL = [self createSimpleLabelWithTitle:NSLocalizedString(@"智能拉力器", nil) font:20 bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(6));
    }];
    
    self.subL = [self createSimpleLabelWithTitle:NSLocalizedString(@"拉力器，是一种适合于大众健身锻炼的器械。使用拉力器锻炼的好处在于：肱二头肌是一块有两个肌头的肌肉，其主要作用是屈臂。", nil) font:12 bold:NO color:[ZCConfigColor txtColor]];
    [self.subL setContentLineFeedStyle];
    [self.contentView addSubview:self.subL];
    [self.subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.nameL.mas_bottom).offset(AUTO_MARGIN(10));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(2));
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.nameL.text = checkSafeContent(dataDic[@"title"]);
//    self.subL.text = checkSafeContent(dataDic[@"briefDesc"]);
    [self.subL setAttributeStringContent:checkSafeContent(dataDic[@"briefDesc"]) space:5 font:FONT_SYSTEM(12) alignment:NSTextAlignmentLeft];
}

@end

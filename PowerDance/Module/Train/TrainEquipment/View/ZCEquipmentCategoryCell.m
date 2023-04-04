//
//  ZCEquipmentCategoryCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/15.
//

#import "ZCEquipmentCategoryCell.h"

@interface ZCEquipmentCategoryCell ()

@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UIView  *bgView;

@end

@implementation ZCEquipmentCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)equipmentCategoryCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCEquipmentCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCEquipmentCategoryCell" forIndexPath:indexPath];
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
        
    self.nameL = [self createSimpleLabelWithTitle:NSLocalizedString(@"爆发力", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.nameL];
    self.nameL.textAlignment = NSTextAlignmentCenter;
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(10));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(20));
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.nameL.text = checkSafeContent(dataDic[@"name"]);
    if ([dataDic[@"status"] integerValue] == 1) {
        self.contentView.backgroundColor = [ZCConfigColor whiteColor];
        self.nameL.textColor = [ZCConfigColor cyanColor];
    } else {
        self.contentView.backgroundColor = [ZCConfigColor bgColor];
        self.nameL.textColor = [ZCConfigColor txtColor];
    }
}

@end

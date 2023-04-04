//
//  ZCSportAddGroupCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/25.
//

#import "ZCSportAddGroupCell.h"

@implementation ZCSportAddGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)sportAddGroupCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCSportAddGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCSportAddGroupCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIButton *addBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"添加工作组", nil) font:14 color:[ZCConfigColor txtColor]];
    [addBtn setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [addBtn setImage:kIMAGE(@"train_simple_add") forState:UIControlStateNormal];
    [self.contentView addSubview:addBtn];
    [addBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleLeft space:5];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(100));
        make.top.bottom.mas_equalTo(self.contentView);
    }];
    [addBtn addTarget:self action:@selector(addSportGroupOperate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addSportGroupOperate {
    if (self.addNewGroupOperate) {
        self.addNewGroupOperate(0);
    }
}

@end

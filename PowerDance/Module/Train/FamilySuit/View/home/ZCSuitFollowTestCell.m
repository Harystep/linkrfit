//
//  ZCSuitFollowTestCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/7/28.
//

#import "ZCSuitFollowTestCell.h"

@interface ZCSuitFollowTestCell ()

@property (nonatomic,strong) NSArray *titleArr;

@end

@implementation ZCSuitFollowTestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)suitFollowTestCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCSuitFollowTestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCSuitFollowTestCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"体能测试", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(10));
    }];
    
    CGFloat width = (SCREEN_W - AUTO_MARGIN(80))/3.0;
    UIView *targetView = [[UIView alloc] init];
    [self.contentView addSubview:targetView];
    [targetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGIN(18));
        make.height.mas_equalTo(width);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    targetView.backgroundColor = [ZCConfigColor bgColor];
    NSArray *titleArr = @[
        @{@"title":NSLocalizedString(@"力量", nil), @"image":@"suit_power"},
        @{@"title":NSLocalizedString(@"耐力", nil), @"image":@"suit_endurance"},
        @{@"title":NSLocalizedString(@"心肺", nil), @"image":@"suit_heart"},
    ];
    self.titleArr = titleArr;
    for (int i = 0; i < titleArr.count; i ++) {
        NSDictionary *dic = titleArr[i];
        UIButton *item = [self createSimpleButtonWithTitle:dic[@"title"] font:AUTO_MARGIN(14) color:[ZCConfigColor whiteColor]];
        [targetView addSubview:item];
        item.tag = i;
        [item setImage:kIMAGE(dic[@"image"]) forState:UIControlStateNormal];
        [item dn_layoutButtonEdgeInset:DNEdgeInsetStyleTop space:10];
        item.frame = CGRectMake((width+AUTO_MARGIN(20))*i, 0, width, width);
        if (i == 0) {
            [item configureViewColorGradient:item width:width height:width one:rgba(254, 225, 64, 1) two:rgba(250, 112, 154, 1) cornerRadius:AUTO_MARGIN(10)];
        } else if (i == 1) {
            [item configureViewColorGradient:item width:width height:width one:rgba(196, 113, 245, 1) two:rgba(250, 113, 205, 1) cornerRadius:AUTO_MARGIN(10)];
        } else {
            [item configureViewColorGradient:item width:width height:width one:rgba(23, 234, 217, 1) two:rgba(96, 120, 234, 1) cornerRadius:AUTO_MARGIN(10)];
        }
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void)itemClick:(UIButton *)sender {
    [HCRouter router:@"SuitEquipmentTest" params:@{@"data":self.titleArr[sender.tag]} viewController:self.superViewController animated:YES];
}

@end

//
//  ZCAddressManageItemCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/12/5.
//

#import "ZCAddressManageItemCell.h"
#import "ZCShopAddressModel.h"

@interface ZCAddressManageItemCell ()

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UILabel *phoneL;

@property (nonatomic,strong) UIView *defaultView;

@property (nonatomic,strong) UILabel *addressL;

@end

@implementation ZCAddressManageItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)addressManageItemCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCAddressManageItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCAddressManageItemCell" forIndexPath:indexPath];
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
    
    UIView *bgView = [[UIView alloc] init];
    [self.contentView addSubview:bgView];
    bgView.backgroundColor = [ZCConfigColor whiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(15));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(10));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    [bgView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    self.nameL = [self createSimpleLabelWithTitle:@" " font:AUTO_MARGIN(15) bold:YES color:[ZCConfigColor txtColor]];
    [bgView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(bgView).offset(AUTO_MARGIN(15));
    }];
    
    self.phoneL = [self createSimpleLabelWithTitle:@" " font:AUTO_MARGIN(13) bold:NO color:[ZCConfigColor point6TxtColor]];
    [bgView addSubview:self.phoneL];
    [self.phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameL.mas_centerY);
        make.leading.mas_equalTo(self.nameL.mas_trailing).offset(AUTO_MARGIN(8));
    }];
    
    UIButton *editBtn = [[UIButton alloc] init];
    [bgView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.trailing.mas_equalTo(bgView.mas_trailing).inset(AUTO_MARGIN(10));
        make.width.height.mas_equalTo(AUTO_MARGIN(20));
    }];
    [editBtn setImage:kIMAGE(@"address_edit") forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editAddressOperate) forControlEvents:UIControlEventTouchUpInside];
    
    self.addressL = [self createSimpleLabelWithTitle:@" " font:AUTO_MARGIN(13) bold:NO color:[ZCConfigColor txtColor]];
    [bgView addSubview:self.addressL];
    [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(bgView.mas_leading).offset(AUTO_MARGIN(15));
        make.top.mas_equalTo(self.nameL.mas_bottom).offset(AUTO_MARGIN(10));
        make.trailing.mas_equalTo(editBtn.mas_leading).inset(AUTO_MARGIN(15));
        make.bottom.mas_equalTo(bgView.mas_bottom).inset(AUTO_MARGIN(15));
    }];
    [self.addressL setContentLineFeedStyle];
    
    self.defaultView = [[UIView alloc] init];
    [bgView addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameL.mas_centerY);
        make.leading.mas_equalTo(self.phoneL.mas_trailing).offset(AUTO_MARGIN(8));
        make.height.mas_equalTo(AUTO_MARGIN(13));
        make.width.mas_equalTo(AUTO_MARGIN(35));
    }];
    
    UILabel *descL = [self createSimpleLabelWithTitle:@"默认" font:8 bold:NO color:[ZCConfigColor whiteColor]];
    [self.defaultView addSubview:descL];
    [descL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.defaultView);
    }];
    descL.textAlignment = NSTextAlignmentCenter;
    
    [self.defaultView configureLeftToRightViewColorGradient:self.defaultView width:AUTO_MARGIN(35) height:AUTO_MARGIN(13) one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:6];
    self.defaultView.hidden = YES;
}

#pragma -- mark 编辑地址
- (void)editAddressOperate {
    [self routerWithEventName:@"edit" userInfo:@{@"model":self.model}];
}

- (void)setModel:(ZCShopAddressModel *)model {
    _model = model;
    self.nameL.text = checkSafeContent(model.realName);
    self.phoneL.text = [checkSafeContent(model.phone) dn_hideCharacters:3 length:4];
    NSString *content = [NSString stringWithFormat:@"%@%@%@%@", checkSafeContent(model.province), checkSafeContent(model.city) ,checkSafeContent(model.region), checkSafeContent(model.address)];
    self.addressL.text = content;
    if ([model.isDefault integerValue] == 1) {
        self.defaultView.hidden = NO;
    } else {
        self.defaultView.hidden = YES;
    }
}

@end

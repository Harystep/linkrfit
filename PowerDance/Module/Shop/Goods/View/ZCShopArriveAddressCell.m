//
//  ZCShopArriveAddressCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import "ZCShopArriveAddressCell.h"
#import "ZCShopAddressModel.h"

@interface ZCShopArriveAddressCell ()

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UILabel *phoneL;

@property (nonatomic,strong) UILabel *addressL;

@property (nonatomic,assign) NSInteger index;

@end

@implementation ZCShopArriveAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)shopArriveAddressCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath; {
    ZCShopArriveAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCShopArriveAddressCell" forIndexPath:indexPath];
    cell.index = indexPath.row;
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
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = rgba(246, 246, 246, 1);
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(15));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    self.nameL = [self createSimpleLabelWithTitle:NSLocalizedString(@"JHON", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [bgView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(bgView).offset(AUTO_MARGIN(20));
    }];
    
    self.phoneL = [self createSimpleLabelWithTitle:NSLocalizedString(@"1880000000", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [bgView addSubview:self.phoneL];
    [self.phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameL.mas_trailing).offset(AUTO_MARGIN(10));
        make.centerY.mas_equalTo(self.nameL.mas_centerY);
    }];
    
    self.editBtn = [[UIButton alloc] init];
    [self.editBtn setImage:kIMAGE(@"shop_address_edit") forState:UIControlStateNormal];
    [bgView addSubview:self.editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.phoneL.mas_centerY);
        make.leading.mas_equalTo(self.phoneL.mas_trailing);
        make.width.height.mas_equalTo(AUTO_MARGIN(30));
    }];
    self.editBtn.hidden = YES;
    [self.editBtn addTarget:self action:@selector(editAddressOperate) forControlEvents:UIControlEventTouchUpInside];
    
    self.addressL = [self createSimpleLabelWithTitle:NSLocalizedString(@"江苏省苏州市吴中区工业园区创意产业园11栋10楼", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [self.addressL setContentLineFeedStyle];
    [bgView addSubview:self.addressL];
    [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(bgView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.phoneL.mas_bottom).offset(AUTO_MARGIN(12));
        make.bottom.mas_equalTo(bgView.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    
    self.selectIv = [[UIImageView alloc] initWithImage:kIMAGE(@"shop_address")];
    self.selectIv.hidden = YES;
    [bgView addSubview:self.selectIv];
    [self.selectIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.mas_equalTo(bgView).inset(AUTO_MARGIN(5));
        make.width.height.mas_equalTo(AUTO_MARGIN(20));
    }];
    
}

- (void)setModel:(ZCShopAddressModel *)model {
    _model = model;
    self.nameL.text = model.realName;
    self.phoneL.text = model.phone;
    self.addressL.text = [NSString stringWithFormat:@"%@%@%@%@", model.province, model.city, model.region, model.address];
    if ([model.status integerValue] == 1) {
        self.selectIv.hidden = NO;
        self.editBtn.hidden = NO;
    } else {
        self.selectIv.hidden = YES;
        self.editBtn.hidden = YES;
    }
}

- (void)editAddressOperate {    
    [self routerWithEventName:[NSString stringWithFormat:@"%tu", self.index] userInfo:@{@"model":self.model}];
}

@end

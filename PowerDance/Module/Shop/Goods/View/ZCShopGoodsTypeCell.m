//
//  ZCShopGoodsTypeCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/29.
//

#import "ZCShopGoodsTypeCell.h"
#import "ZCGoodsTypeModel.h"

@interface ZCShopGoodsTypeCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel     *contentL;

@property (nonatomic,strong) UIView *bgView;

@end

@implementation ZCShopGoodsTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)shopGoodsTypeCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCShopGoodsTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCShopGoodsTypeCell" forIndexPath:indexPath];
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
    
    [self.contentView setViewCornerRadiu:AUTO_MARGIN(3)];
    
    UIView *bgView = [[UIView alloc] init];
    self.bgView = bgView;
    bgView.backgroundColor = rgba(249, 249, 249, 1);
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(AUTO_MARGIN(40));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(10));
    }];
    [bgView setViewCornerRadiu:5];
    
    self.iconIv = [[UIImageView alloc] init];
    [bgView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.leading.mas_equalTo(bgView.mas_leading).offset(AUTO_MARGIN(5));
        make.width.height.mas_equalTo(AUTO_MARGIN(30));
    }];
    [self.iconIv setViewCornerRadiu:5];
    
    self.contentL = [self createSimpleLabelWithTitle:NSLocalizedString(@"123", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [bgView addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(14));
        make.centerY.mas_equalTo(self.iconIv.mas_centerY);
    }];
}

- (void)setModel:(ZCGoodsTypeModel *)model {
    _model = model;
    if ([model.status integerValue] == 1) {
        self.bgView.backgroundColor = [ZCConfigColor txtColor];
        self.contentL.textColor = [ZCConfigColor whiteColor];
    } else {
        self.bgView.backgroundColor = rgba(249, 249, 249, 1);
        self.contentL.textColor = [ZCConfigColor txtColor];
    }
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(model.imgUrl)] placeholderImage:nil];
    self.contentL.text = checkSafeContent(model.specTitle);
}

@end

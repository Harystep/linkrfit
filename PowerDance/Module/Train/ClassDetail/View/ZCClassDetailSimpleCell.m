//
//  ZCClassDetailSimpleCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/14.
//

#import "ZCClassDetailSimpleCell.h"

@interface ZCClassDetailSimpleCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@end

@implementation ZCClassDetailSimpleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)classDetailSimpleCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCClassDetailSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCClassDetailSimpleCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = rgba(246, 246, 246, 1);
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [ZCConfigColor whiteColor];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(5));
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(90));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(10));
    }];
    [bgView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    self.iconIv = [[UIImageView alloc] init];
    self.iconIv.backgroundColor = [ZCConfigColor bgColor];
    [bgView addSubview:self.iconIv];
    [self.iconIv setContentMode:UIViewContentModeScaleAspectFill];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.mas_equalTo(bgView);
        make.width.mas_equalTo(AUTO_MARGIN(160));
    }];
    
    self.nameL = [self createSimpleLabelWithTitle:@"下斜哑铃卧推" font:14 bold:NO color:[ZCConfigColor txtColor]];
    [bgView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(45));
        make.trailing.mas_equalTo(bgView.mas_trailing).inset(AUTO_MARGIN(15));
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSDictionary *contentDic = dataDic[@"courseAction"];
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(contentDic[@"cover"])] placeholderImage:nil];
    self.nameL.text = checkSafeContent(contentDic[@"name"]);
}

@end

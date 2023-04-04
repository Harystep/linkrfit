//
//  ZCMoreSetSimpleCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/9.
//

#import "ZCMoreSetSimpleCell.h"

@interface ZCMoreSetSimpleCell ()

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *contentL;

@end

@implementation ZCMoreSetSimpleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)moreSetSimpleCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCMoreSetSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCMoreSetSimpleCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = rgba(246, 246, 246, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [ZCConfigColor whiteColor];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(50));
    }];
    
    self.titleL = [self createSimpleLabelWithTitle:@"" font:14 bold:NO color:[ZCConfigColor txtColor]];
    [bgView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.leading.mas_equalTo(bgView.mas_leading).offset(AUTO_MARGIN(15));
    }];
    
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:kIMAGE(@"profile_simple_arrow")];
    [bgView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(bgView.mas_trailing).inset(AUTO_MARGIN(15));
        make.centerY.mas_equalTo(bgView.mas_centerY);
    }];
    
    self.contentL = [self createSimpleLabelWithTitle:@"" font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    [bgView addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(arrowIv.mas_centerY);
        make.trailing.mas_equalTo(arrowIv.mas_leading).inset(AUTO_MARGIN(10));
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titleL.text = dataDic[@"title"];
    self.contentL.text = dataDic[@"content"];
}

@end

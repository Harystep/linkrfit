//
//  ZCTrainTargetClassCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/15.
//

#import "ZCTrainTargetClassCell.h"

@interface ZCTrainTargetClassCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UILabel *subL;

@end

@implementation ZCTrainTargetClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)trainTargetClassCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCTrainTargetClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCTrainTargetClassCell" forIndexPath:indexPath];
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
    self.iconIv = [[UIImageView alloc] init];
    self.iconIv.contentMode = UIViewContentModeScaleAspectFill;
    self.iconIv.layer.masksToBounds = YES;
    [self.iconIv setViewCornerRadiu:AUTO_MARGIN(10)];
    self.iconIv.backgroundColor = UIColor.groupTableViewBackgroundColor;
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(6));
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.width.mas_equalTo(AUTO_MARGIN(120));
        make.height.mas_equalTo(AUTO_MARGIN(75));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(10));
    }];
    
    self.nameL = [self createSimpleLabelWithTitle:@"五分钟减脂" font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconIv.mas_top).offset(AUTO_MARGIN(15));
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(15));
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    
    self.subL = [self createSimpleLabelWithTitle:@"简单减脂、快乐轻松" font:12 bold:NO color:[ZCConfigColor subTxtColor]];
    [self.contentView addSubview:self.subL];
    [self.subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameL.mas_leading);
        make.top.mas_equalTo(self.nameL.mas_bottom).offset(AUTO_MARGIN(10));
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(20));
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.nameL.text = checkSafeContent(dataDic[@"title"]);
    self.subL.text = checkSafeContent(dataDic[@"briefDesc"]);
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"imgUrl"])] placeholderImage:nil];
}

@end

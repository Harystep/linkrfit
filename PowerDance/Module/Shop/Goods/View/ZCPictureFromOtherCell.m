//
//  ZCPictureFromOtherCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/30.
//

#import "ZCPictureFromOtherCell.h"

@interface ZCPictureFromOtherCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UIImageView *picIv;

@property (nonatomic,strong) UILabel *timeL;

@end

@implementation ZCPictureFromOtherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)chatMessageCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCPictureFromOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCPictureFromOtherCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = rgba(246, 246, 246, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.timeL = [self createSimpleLabelWithTitle:NSLocalizedString(@"", nil) font:13 bold:NO color:[ZCConfigColor subTxtColor]];
    [self.contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(5));
    }];
    
    self.iconIv = [[UIImageView alloc] init];
    self.iconIv.backgroundColor = UIColor.groupTableViewBackgroundColor;
    [self.contentView addSubview:self.iconIv];
    [self.iconIv setViewCornerRadiu:AUTO_MARGIN(21)];
    [self.iconIv mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(AUTO_MARGIN(42));
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.timeL.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    
    self.picIv = [[UIImageView alloc] init];
    self.picIv.contentMode = UIViewContentModeScaleAspectFill;
    self.picIv.clipsToBounds = YES;
    [self.contentView addSubview:self.picIv];
    self.picIv.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureClick)];
    [self.picIv addGestureRecognizer:tap];
}

- (void)pictureClick {
    [XLPhotoBrowser showPhotoBrowserWithImages:@[checkSafeContent(self.dataDic[@"message"])] currentImageIndex:0];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSString *content = dataDic[@"message"];
    [self.picIv mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(AUTO_MARGIN(140));
        make.leading.mas_equalTo(self.iconIv.mas_trailing).inset(AUTO_MARGIN(15));
        make.top.mas_equalTo(self.iconIv.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    self.picIv.hidden = NO;
    [self.picIv sd_setImageWithURL:[NSURL URLWithString:content] placeholderImage:nil];
    self.timeL.text = [NSString convertYMDHMStringWithContent:checkSafeContent(dataDic[@"createTime"])];
}

- (void)setPreDic:(NSDictionary *)preDic {
    _preDic = preDic;
    NSString *cur = checkSafeContent(self.dataDic[@"createTime"]);
    NSString *pre = checkSafeContent(preDic[@"createTime"]);
    NSString *curTime = [NSString convertYMDHMStringWithContent:cur];
    NSString *preTime = [NSString convertYMDHMStringWithContent:pre];
    if ([curTime isEqualToString:preTime]) {
        self.timeL.text = @"";
    } else {
        self.timeL.text = curTime;
    }
}

@end

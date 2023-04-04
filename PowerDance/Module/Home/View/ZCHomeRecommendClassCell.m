//
//  ZCHomeRecommendClassCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/25.
//

#import "ZCHomeRecommendClassCell.h"

@interface ZCHomeRecommendClassCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UILabel *descL;

@property (nonatomic,strong) UILabel *equipmentL;

@end

@implementation ZCHomeRecommendClassCell

+ (instancetype)homeRecommendClassCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCHomeRecommendClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCHomeRecommendClassCell" forIndexPath:indexPath];
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
            
    self.iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@" ")];
    self.iconIv.contentMode = UIViewContentModeScaleAspectFill;
    self.iconIv.clipsToBounds = YES;
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(AUTO_MARGIN(20));
        make.width.mas_equalTo(AUTO_MARGIN(120));
        make.height.mas_equalTo(AUTO_MARGIN(75));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    [self.iconIv setViewCornerRadiu:AUTO_MARGIN(10)];
    
    self.titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@" ", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.titleL];
    [self.titleL setContentLineFeedStyle];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(10));
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(12));
        make.top.mas_equalTo(self.iconIv).offset(AUTO_MARGIN(8));
    }];
    
    self.descL = [self createSimpleLabelWithTitle:NSLocalizedString(@" ", nil) font:AUTO_MARGIN(11) bold:NO color:[ZCConfigColor point8TxtColor]];
    [self.contentView addSubview:self.descL];
    [self.descL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(10));
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(AUTO_MARGIN(4));
        make.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(10));
    }];
    
    UIView *bgView = [[UIView alloc] init];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(10));
        make.bottom.mas_equalTo(self.iconIv.mas_bottom).inset(AUTO_MARGIN(8));
        make.height.mas_equalTo(AUTO_MARGIN(16));
    }];
    bgView.backgroundColor = rgba(138, 205, 215, 0.2);
    [bgView setViewCornerRadiu:3];
    
    self.equipmentL = [self createSimpleLabelWithTitle:NSLocalizedString(@"  ", nil) font:10 bold:NO color:rgba(158, 168, 194, 1)];
    [bgView addSubview:self.equipmentL];
    [self.equipmentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(bgView.mas_leading).offset(AUTO_MARGIN(5));
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.centerY.mas_equalTo(bgView.mas_centerY);
    }];
        
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titleL.text = checkSafeContent(dataDic[@"title"]);
    NSString *time = [ZCDataTool convertMouseToMSUnitString:[checkSafeContent(dataDic[@"duration"]) integerValue]];
    if (checkSafeContent(dataDic[@"difficultyTag"]).length == 0) {
        self.descL.text = [NSString stringWithFormat:@"%@ · %@%@", time, checkSafeContent(dataDic[@"energy"]), NSLocalizedString(@"千卡", nil)];
    } else {
        self.descL.text = [NSString stringWithFormat:@"%@ · %@ · %@%@", checkSafeContent(dataDic[@"difficultyTag"]), time, checkSafeContent(dataDic[@"energy"]), NSLocalizedString(@"千卡", nil)];
    }
    NSString *iconStr = checkSafeContent(dataDic[@"cover"]);
    if (iconStr.length == 0) {
        iconStr = checkSafeContent(dataDic[@"cover"]);
    }
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:nil];
    NSArray *apparatusList = dataDic[@"apparatusList"];
    if (apparatusList.count > 0) {
        NSDictionary *itemDic = apparatusList[0];
        NSString *name = [NSString stringWithFormat:@" %@ ", checkSafeContent(itemDic[@"name"])];
        if (name.length > 4) {
            self.equipmentL.attributedText = [name dn_changeColor:rgba(138, 205, 215, 1) andRange:NSMakeRange(3, name.length-3)];
        } else {
            self.equipmentL.text = name;
        }
        self.equipmentL.hidden = NO;
        
    } else {
        self.equipmentL.hidden = YES;
    }
        
}


@end

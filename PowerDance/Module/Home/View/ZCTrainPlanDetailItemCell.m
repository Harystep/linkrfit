//
//  ZCTrainPlanDetailItemCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/12/1.
//

#import "ZCTrainPlanDetailItemCell.h"

@interface ZCTrainPlanDetailItemCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UILabel *sportTimeL;

@property (nonatomic,strong) UILabel *numL;

@property (nonatomic,strong) UILabel *timeL;

@end

@implementation ZCTrainPlanDetailItemCell

+ (instancetype)trainPlanDetailItemCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCTrainPlanDetailItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCTrainPlanDetailItemCell" forIndexPath:indexPath];
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

    self.iconIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.height.width.mas_equalTo(AUTO_MARGIN(37));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(14));
    }];
    [self.iconIv setViewCornerRadiu:3];
    self.iconIv.backgroundColor = [ZCConfigColor bgColor];
    
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [ZCConfigColor bgColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(1));
    }];
    
    self.titleL = [self createSimpleLabelWithTitle:@"家庭健身套装-哑铃球" font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconIv.mas_top);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(70));
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(8);
    }];
    
    self.sportTimeL = [self createSimpleLabelWithTitle:@" " font:AUTO_MARGIN(11) bold:NO color:[ZCConfigColor point8TxtColor]];
    [self.contentView addSubview:self.sportTimeL];
    [self.sportTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(8);
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(8);
    }];
    
    self.numL = [self createSimpleLabelWithTitle:@" " font:AUTO_MARGIN(11) bold:NO color:[ZCConfigColor point8TxtColor]];
    [self.contentView addSubview:self.numL];
    [self.numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.sportTimeL.mas_centerY);
        make.leading.mas_equalTo(self.sportTimeL.mas_trailing).offset(10);
    }];
    
    self.timeL = [self createSimpleLabelWithTitle:@"" font:AUTO_MARGIN(11) bold:NO color:[ZCConfigColor subTxtColor]];
    [self.contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconIv.mas_centerY);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"imgUrl"])] placeholderImage:nil];
    self.titleL.text = [NSString stringWithFormat:@"%@", checkSafeContent(dataDic[@"courseName"])];
    NSString *apparatusName = checkSafeContent(dataDic[@"apparatusName"]);
    if (apparatusName.length > 0) {
        self.titleL.text = [NSString stringWithFormat:@"%@-%@", checkSafeContent(dataDic[@"courseName"]), apparatusName];
    }
    NSString *time = checkSafeContent(dataDic[@"whichDay"]);
    if (time.length > 10) {
        time = [time substringWithRange:NSMakeRange(5, 5)];
        time = [time stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
        self.timeL.text = [NSString stringWithFormat:@"%@日", time];
    }
    
    self.sportTimeL.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"用时", nil), [ZCDataTool convertMouseToTimeString:[checkSafeContent(dataDic[@"duration"]) integerValue]]];
    
}

@end

//
//  ZCTrainDetailActionCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/26.
//

#import "ZCTrainDetailActionCell.h"

@interface ZCTrainDetailActionCell ()

@property (nonatomic,strong) UILabel *groupL;
@property (nonatomic,strong) UILabel *loopL;
@property (nonatomic,strong) UIView *colorView;

@end

@implementation ZCTrainDetailActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)trainDetailActionCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCTrainDetailActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCTrainDetailActionCell" forIndexPath:indexPath];
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
    [bgView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(15));
    }];
    
    self.groupL = [self createSimpleLabelWithTitle:@"" font:14 bold:YES color:[ZCConfigColor txtColor]];
    [bgView addSubview:self.groupL];
    [self.groupL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.leading.mas_equalTo(bgView.mas_leading).offset(AUTO_MARGIN(30));
        make.top.mas_equalTo(bgView.mas_top).offset(AUTO_MARGIN(20));
    }];
    
    self.loopL = [self createSimpleLabelWithTitle:@"" font:14 bold:YES color:[ZCConfigColor txtColor]];
    [bgView addSubview:self.loopL];
    [self.loopL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.trailing.mas_equalTo(bgView.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    
    self.colorView = [[UIView alloc] init];
    [bgView addSubview:self.colorView];
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.leading.mas_equalTo(bgView.mas_leading).offset(AUTO_MARGIN(15));
        make.height.width.mas_equalTo(AUTO_MARGIN(8));
    }];
    [self.colorView setViewCornerRadiu:AUTO_MARGIN(4)];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.groupL.text = checkSafeContent(dataDic[@"name"]);
    self.loopL.text = [ZCDataTool convertMouseToTimeString:[dataDic[@"duration"] integerValue]];
    if ([dataDic[@"rest"] integerValue] == 1) {
        self.colorView.backgroundColor = [UIColor blueColor];
    }
    self.colorView.backgroundColor = kColorHex(dataDic[@"color"]);
}

@end

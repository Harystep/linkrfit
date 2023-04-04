//
//  ZCAutoPracticeActionCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/28.
//

#import "ZCAutoPracticeActionCell.h"

@interface ZCAutoPracticeActionCell ()

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UIView *bgView;

@end

@implementation ZCAutoPracticeActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)autoPracticeActionCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCAutoPracticeActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCAutoPracticeActionCell" forIndexPath:indexPath];
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
    self.bgView = bgView;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(AUTO_MARGIN(90));
    }];
    [bgView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    self.nameL = [self createSimpleLabelWithTitle:@"" font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor whiteColor]];
    [bgView addSubview:self.nameL];
    self.nameL.textAlignment = NSTextAlignmentCenter;
    [self.nameL setContentLineFeedStyle];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.leading.trailing.mas_equalTo(bgView).inset(AUTO_MARGIN(15));
        make.centerY.mas_equalTo(bgView.mas_centerY);
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.nameL.text = checkSafeContent(dataDic[@"title"]);
    self.bgView.backgroundColor = kColorHex(checkSafeContent(dataDic[@"colour"]));
}

@end

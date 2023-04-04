//
//  ZCActionAttentionCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/14.
//

#import "ZCActionAttentionCell.h"

@interface ZCActionAttentionCell ()

@property (nonatomic,strong) UILabel *contentL;

@end

@implementation ZCActionAttentionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)actionAttentionCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCActionAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCActionAttentionCell" forIndexPath:indexPath];
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
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.contentView.mas_top);
    }];
    [bgView setViewCornerRadiu:AUTO_MARGIN(10)];
    [bgView setViewBorderWithColor:1 color:rgba(43, 42, 51, 0.1)];
   
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"注意事项", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [bgView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(bgView).offset(AUTO_MARGIN(15));
    }];
    
    self.contentL = [self createSimpleLabelWithTitle:NSLocalizedString(@"全程保持头部和背部贴在凳子上，双脚全程接触地面确保支撑。", nil) font:12 bold:NO color:[ZCConfigColor txtColor]];
    [bgView addSubview:self.contentL];
    [self.contentL setContentLineFeedStyle];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(lb.mas_leading);
        make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(12));
        make.trailing.mas_equalTo(bgView.mas_trailing).inset(AUTO_MARGIN(15));
        make.bottom.mas_equalTo(bgView.mas_bottom).inset(AUTO_MARGIN(15));
    }];
    
    UIView *sepView = [[UIView alloc] init];
    [self.contentView addSubview:sepView];
    sepView.backgroundColor = rgba(246, 246, 246, 1);
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_bottom).offset(AUTO_MARGIN(15));
        make.height.mas_offset(AUTO_MARGIN(5));
        make.leading.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
}

- (void)setPointsAttention:(NSString *)pointsAttention {
    _pointsAttention = pointsAttention;
//    self.contentL.text = checkSafeContent(pointsAttention);
    [self.contentL setAttributeStringContent:checkSafeContent(pointsAttention) space:5 font:FONT_SYSTEM(12) alignment:NSTextAlignmentLeft];
}

@end

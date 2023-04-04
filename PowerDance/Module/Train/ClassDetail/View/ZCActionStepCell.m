//
//  ZCActionStepCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/14.
//

#import "ZCActionStepCell.h"

@interface ZCActionStepCell ()

@property (nonatomic,strong) UILabel *contentL;

@property (nonatomic,strong) UILabel *numL;

@end

@implementation ZCActionStepCell

+ (instancetype)actionStepWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCActionStepCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCActionStepCell" forIndexPath:indexPath];
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
    
    self.numL = [self createSimpleLabelWithTitle:@"1" font:12 bold:NO color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.numL];
    self.numL.backgroundColor = rgba(43, 42, 51, 0.1);
    [self.numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.contentView.mas_top);
        make.width.height.mas_equalTo(AUTO_MARGIN(30));
    }];
    self.numL.textAlignment = NSTextAlignmentCenter;
    [self.numL setViewCornerRadiu:AUTO_MARGIN(15)];
    
    self.contentL = [self createSimpleLabelWithTitle:@"缓慢的将哑铃举起，直到手臂和上身垂直，举的过程中呼气。" font:12 bold:NO color:[ZCConfigColor txtColor]];
    [self.contentL setContentLineFeedStyle];
    [self.contentView addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.numL.mas_trailing).offset(AUTO_MARGIN(15));
        make.top.mas_equalTo(self.numL.mas_top).offset(AUTO_MARGIN(8));
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(20));
    }];

}

- (void)setIndex:(NSInteger)index {
    _index = index;
    self.numL.text = [NSString stringWithFormat:@"%tu", index+1];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
//    self.contentL.text = checkSafeContent(dataDic[@"title"]);
    [self.contentL setAttributeStringContent:checkSafeContent(dataDic[@"title"]) space:5 font:FONT_SYSTEM(12) alignment:NSTextAlignmentLeft];
}

@end

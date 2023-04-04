//
//  ZCAutoWRCModelSimpleCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/23.
//

#import "ZCAutoWRCModelSimpleCell.h"

@interface ZCAutoWRCModelSimpleCell ()

@property (nonatomic,strong) UILabel *timeTitleL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *restTitleL;
@property (nonatomic,strong) UILabel *restL;
@property (nonatomic,assign) NSInteger index;


@end

@implementation ZCAutoWRCModelSimpleCell
    
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)wrcModelCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCAutoWRCModelSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCAutoWRCModelSimpleCell" forIndexPath:indexPath];
    cell.index = indexPath.row;
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
            
    UIView *timeView = [[UIView alloc] init];
    [self.contentView addSubview:timeView];
    timeView.tag = 0;
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(15));
        make.width.mas_equalTo(AUTO_MARGIN(120));
        make.height.mas_equalTo(44);
    }];
    [timeView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [timeView setViewCornerRadiu:6];
    
    self.timeTitleL = [self createSimpleLabelWithTitle:[NSString stringWithFormat:@"%@(%@)", NSLocalizedString(@"时间", nil), @"F1"] font:14 bold:NO color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.timeTitleL];
    [self.timeTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(timeView.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(40));
    }];
    
    UIView *signView = [[UIView alloc] init];
    [self.contentView addSubview:signView];
    [signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeTitleL.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.height.width.mas_equalTo(AUTO_MARGIN(10));
    }];
    signView.backgroundColor = [ZCConfigColor txtColor];
    [signView setViewCornerRadiu:AUTO_MARGIN(5)];
    
    self.timeL = [self.contentView createSimpleLabelWithTitle:NSLocalizedString(@"00:00:00", nil) font:20 bold:YES color:[ZCConfigColor txtColor]];
    [timeView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.mas_equalTo(timeView);
    }];
             
    [self createTimeViewSubviews:timeView];
}

- (void)createTimeViewSubviews:(UIView *)topView {
    UIView *timeView = [[UIView alloc] init];
    [self.contentView addSubview:timeView];
    timeView.tag = 1;
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(topView.mas_bottom).offset(AUTO_MARGIN(15));
        make.width.mas_equalTo(AUTO_MARGIN(120));
        make.height.mas_equalTo(AUTO_MARGIN(40));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    [timeView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [timeView setViewCornerRadiu:6];
    
    self.restTitleL = [self createSimpleLabelWithTitle:[NSString stringWithFormat:@"%@(%@)", NSLocalizedString(@"时间", nil), @"C1"] font:14 bold:NO color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.restTitleL];
    [self.restTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(timeView.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(40));
    }];
    
    UIView *signView = [[UIView alloc] init];
    [self.contentView addSubview:signView];
    [signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.restTitleL.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.height.width.mas_equalTo(AUTO_MARGIN(10));
    }];
    signView.backgroundColor = rgba(233, 233, 234, 1);
    [signView setViewCornerRadiu:AUTO_MARGIN(5)];
    
    self.restL = [self.contentView createSimpleLabelWithTitle:NSLocalizedString(@"00:00:00", nil) font:20 bold:YES color:[ZCConfigColor txtColor]];
    [timeView addSubview:self.restL];
    [self.restL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.mas_equalTo(timeView);
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.timeTitleL.text = [NSString stringWithFormat:@"%@(F%@)", NSLocalizedString(@"时间", nil), @(self.index + 1)];
    self.restTitleL.text = [NSString stringWithFormat:@"%@(C%@)", NSLocalizedString(@"时间", nil), @(self.index + 1)];
    self.timeL.text = checkSafeContent(dataDic[@"time"]);
    self.restL.text = checkSafeContent(dataDic[@"rest"]);
}

@end

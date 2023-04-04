//
//  ZCTrainPlanDetailDataCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/12/1.
//

#import "ZCTrainPlanDetailDataCell.h"
#import "ZCTrainPlanDetailChartDataView.h"

@interface ZCTrainPlanDetailDataCell ()

@property (nonatomic,strong) UILabel *sportTimeL;//运动时长

@property (nonatomic,strong) UILabel *timeL;//运动时间

@property (nonatomic,strong) UILabel *consumeL;//累计消耗

@property (nonatomic,strong) UILabel *classNumL;//完成课程数

@property (nonatomic,strong) UILabel *dayNumL;//运动天数

@property (nonatomic,strong) ZCTrainPlanDetailChartDataView *chartView;

@end

@implementation ZCTrainPlanDetailDataCell

//+ (instancetype)trainPlanDetailDataCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
//    ZCTrainPlanDetailDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCTrainPlanDetailDataCell" forIndexPath:indexPath];
//    return cell;
//}
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self createSubviews];
//    }
//    return self;
//}
//
//- (void)createSubviews {
//
//    UIView *lineView = [[UIView alloc] init];
//    [self.contentView addSubview:lineView];
//    lineView.backgroundColor = SYB_VIEW_BG_COLOR;
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.bottom.mas_equalTo(self);
//        make.height.mas_equalTo(AUTO_MARGIN(1));
//    }];
//
//}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    lineView.backgroundColor = [ZCConfigColor bgColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(1));
        make.top.mas_equalTo(self.mas_top).offset(90);
    }];
    
    UILabel *sportTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"时长（分钟）", nil) font:11 bold:NO color:[ZCConfigColor point6TxtColor]];
    [self addSubview:sportTL];
    [sportTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(35));
        make.bottom.mas_equalTo(lineView.mas_top).inset(16);
    }];
    
    self.sportTimeL = [self createSimpleLabelWithTitle:@"-" font:35 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.sportTimeL];
    [self.sportTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(sportTL.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(20);
    }];
    
    self.timeL = [self createSimpleLabelWithTitle:@"-" font:12 bold:NO color:[ZCConfigColor point8TxtColor]];
    [self addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.mas_top).offset(43);
    }];
    
    UILabel *consumeTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"累计消耗（千卡）", nil) font:11 bold:NO color:[ZCConfigColor point6TxtColor]];
    [self addSubview:consumeTL];
    [consumeTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(35);
        make.top.mas_equalTo(lineView.mas_bottom).offset(46);
    }];
    
    self.consumeL = [self createSimpleLabelWithTitle:@"-" font:24 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.consumeL];
    [self.consumeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(consumeTL.mas_centerX);
        make.top.mas_equalTo(lineView.mas_bottom).offset(16);
    }];
        
    self.classNumL = [self createSimpleLabelWithTitle:@"-" font:24 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.classNumL];
    [self.classNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.consumeL.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    UILabel *classNumTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"课程完成（次）", nil) font:11 bold:NO color:[ZCConfigColor point6TxtColor]];
    [self addSubview:classNumTL];
    [classNumTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.classNumL.mas_centerX);
        make.centerY.mas_equalTo(consumeTL.mas_centerY);
    }];
    
//    UILabel *dayNumL = [self createSimpleLabelWithTitle:@"累计（天）" font:11 bold:NO color:[ZCConfigColor point6TxtColor]];
//    [self addSubview:dayNumL];
//    [dayNumL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
//        make.centerY.mas_equalTo(consumeTL.mas_centerY);
//    }];
//
//    self.dayNumL = [self createSimpleLabelWithTitle:@"1" font:24 bold:YES color:[ZCConfigColor txtColor]];
//    [self addSubview:self.dayNumL];
//    [self.dayNumL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.consumeL.mas_centerY);
//        make.centerX.mas_equalTo(dayNumL.mas_centerX);
//    }];
    
    self.chartView = [[ZCTrainPlanDetailChartDataView alloc] init];
    [self addSubview:self.chartView];
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self).inset(10);
        make.top.mas_equalTo(lineView.mas_bottom).offset(90);
    }];
    
    UIView *sepView = [[UIView alloc] init];
    [self addSubview:sepView];
    sepView.backgroundColor = [ZCConfigColor bgColor];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self);
        make.height.mas_equalTo(10);
    }];
    
}
// 0:日 1:周 2:月
- (void)setType:(NSInteger)type {
    _type = type;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    self.chartView.selectedSegmentIndex = self.type;
    self.chartView.dataArr = dataArr;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.sportTimeL.text = [NSString stringWithFormat:@"%.1f", [checkSafeContent(dataDic[@"duration"]) integerValue]/60.0];
    self.consumeL.text = checkSafeContent(dataDic[@"energy"]);
    self.classNumL.text = checkSafeContent(dataDic[@"courseCount"]);
    if (self.type == 1) {
        NSString *startTime = dataDic[@"startTime"];
        NSString *endTime = dataDic[@"endTime"];
        self.timeL.text = [NSString stringWithFormat:@"%@~%@", [startTime substringWithRange:NSMakeRange(5, 5)], [endTime substringWithRange:NSMakeRange(5, 5)]];
    } else {
        self.timeL.text = checkSafeContent(dataDic[@"time"]);
    }
}

- (void)setSelectRow:(NSInteger)selectRow {
    _selectRow = selectRow;
    self.dataDic = self.dataArr[self.selectRow];
}

@end

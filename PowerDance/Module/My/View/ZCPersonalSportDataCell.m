//
//  ZCPersonalSportDataCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/12/2.
//

#import "ZCPersonalSportDataCell.h"

@interface ZCPersonalSportDataCell ()

@property (nonatomic,strong) NSMutableArray *viewArr;

@end

@implementation ZCPersonalSportDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)personalSportDataCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCPersonalSportDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCPersonalSportDataCell" forIndexPath:indexPath];
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
    self.contentView.backgroundColor = [ZCConfigColor bgColor];
    
    UIView *bgView = [[UIView alloc] init];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(15));
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(10));
        make.height.mas_equalTo(AUTO_MARGIN(132));
    }];
    bgView.backgroundColor = [ZCConfigColor whiteColor];
    
    UIView *lineView = [[UIView alloc] init];
    [bgView addSubview:lineView];
    lineView.backgroundColor = [ZCConfigColor bgColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(bgView.mas_top).offset(44);
        make.height.mas_equalTo(AUTO_MARGIN(1));
    }];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"运动数据", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [bgView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(bgView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(bgView.mas_top).offset(15);
    }];
    UIButton *checkBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"查看详情", nil) font:AUTO_MARGIN(13) color:rgba(138, 205, 215, 1)];
    [bgView addSubview:checkBtn];
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleL.mas_centerY);
        make.trailing.mas_equalTo(bgView.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    [checkBtn addTarget:self action:@selector(checkSportDataOp) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat width = (SCREEN_W-AUTO_MARGIN(15)*2)/3.0;
    NSArray *titleArr = @[@{@"title":[NSString stringWithFormat:@"%@", NSLocalizedString(@"总运动(分钟)", nil)], @"image":@"personal_sport_time"},
                          @{@"title":[NSString stringWithFormat:@"%@", NSLocalizedString(@"消耗(千卡)", nil)], @"image":@"personal_sport_consume"},
                          @{@"title":[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"课程", nil), NSLocalizedString(@"(完成数)", nil)], @"image":@"personal_sport_class"}];
    self.viewArr = [NSMutableArray array];
    
    for (int i = 0; i < 3; i ++) {
        UIView *itemView = [[UIView alloc] init];
        [bgView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.leading.mas_equalTo(bgView.mas_leading).offset(width*i);
            make.bottom.mas_equalTo(bgView);
            make.top.mas_equalTo(lineView.mas_bottom);
        }];
        NSDictionary *dic = titleArr[i];
        UILabel *numL = [self createSimpleLabelWithTitle:@"0" font:AUTO_MARGIN(19) bold:YES color:[ZCConfigColor txtColor]];
        [itemView addSubview:numL];
        [numL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(itemView.mas_centerX);
            make.top.mas_equalTo(itemView.mas_top).offset(AUTO_MARGIN(21));
        }];
        
        UIButton *subBtn = [self createSimpleButtonWithTitle:dic[@"title"] font:AUTO_MARGIN(10) color:[ZCConfigColor point6TxtColor]];
        [itemView addSubview:subBtn];
        subBtn.userInteractionEnabled = NO;
        [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(itemView.mas_centerX);
            make.top.mas_equalTo(numL.mas_bottom).offset(AUTO_MARGIN(10));
        }];
        [subBtn setImage:kIMAGE(dic[@"image"]) forState:UIControlStateNormal];
        [subBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleLeft space:2];
        
        [self.viewArr addObject:numL];
    }
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    double minute = [checkSafeContent(dataDic[@"duration"]) doubleValue] / 60.;
    NSString *duration = [NSString stringWithFormat:@"%.1f", minute];
    NSArray *valueArr = @[duration,
                          checkSafeContent(dataDic[@"energy"]),
                          checkSafeContent(dataDic[@"courseCount"])
    ];
    for (int i = 0; i < valueArr.count; i ++) {
        UILabel *lb = self.viewArr[i];
        lb.text = valueArr[i];
    }
}

#pragma -- mark 查看运动数据
- (void)checkSportDataOp {
    [HCRouter router:@"TrainPlanAllData" params:@{} viewController:self.superViewController animated:YES];
}

@end

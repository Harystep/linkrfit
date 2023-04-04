//
//  ZCSelectSportEquipmentCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/29.
//

#import "ZCSelectSportEquipmentCell.h"
#import "ZCEquipmentModel.h"

@interface ZCSelectSportEquipmentCell ()

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIImageView *iconIv;
@property (nonatomic,strong) UIImageView *selectIv;
@property (nonatomic,strong) NSMutableArray *temArr;

@end

@implementation ZCSelectSportEquipmentCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *bgView = [[UIView alloc] init];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    bgView.backgroundColor = UIColor.whiteColor;    
    
    self.iconIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(AUTO_MARGIN(32));
        make.centerX.mas_equalTo(self.contentView);
        make.height.width.mas_equalTo(AUTO_MARGIN(54));
    }];
    
    self.titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"", nil) font:16 bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(AUTO_MARGIN(18));
        make.centerX.mas_equalTo(self.iconIv);
    }];
    
    self.selectIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_equipment_sel")];
    [self.contentView addSubview:self.selectIv];
    self.selectIv.hidden = YES;
    [self.selectIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(15));
    }];
    
}

- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
}

- (void)setModel:(ZCEquipmentModel *)model {
    _model = model;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:nil];
    self.titleL.text = model.name;
//    if (model.status) {
//        self.selectIv.hidden = NO;
//    } else {
//        self.selectIv.hidden = YES;
//    }
    BOOL status = NO;
    NSMutableArray *temArr = [NSMutableArray array];
    for (ZCEquipmentModel *tem in self.dataArr) {
        [temArr addObject:tem.ID];
    }
    if ([temArr containsObject:model.ID]) {
        status = YES;
    }
    if (status) {
        self.selectIv.hidden = NO;
    } else {
        self.selectIv.hidden = YES;
    }
}


@end

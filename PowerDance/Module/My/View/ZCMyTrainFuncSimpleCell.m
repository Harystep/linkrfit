//
//  ZCMyTrainFuncSimpleCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/8.
//

#import "ZCMyTrainFuncSimpleCell.h"

@interface ZCMyTrainFuncSimpleCell ()

@property (nonatomic,strong) UILabel *contentL;
@property (nonatomic,strong) UIImageView *iconIv;
@property (nonatomic,strong) UILabel *titleL;

@end

@implementation ZCMyTrainFuncSimpleCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    self.contentView.backgroundColor = rgba(255, 255, 255, 0.76);
    [self.contentView setViewCornerRadiu:10];
    
    self.iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_total_time")];
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(12);
        make.height.width.mas_equalTo(40);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"时长", nil) font:12 bold:NO color:[ZCConfigColor subTxtColor]];
    self.titleL = titleL;
    [self.contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconIv.mas_top);
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(10);
    }];
    
    self.contentL = [self createSimpleLabelWithTitle:NSLocalizedString(@"1.2", nil) font:18 bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AUTO_MARGIN(20));
        make.leading.mas_equalTo(titleL);
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGIN(10));
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.iconIv.image = kIMAGE(dataDic[@"image"]);
    self.titleL.text = dataDic[@"title"];
}

- (void)setContent:(NSMutableAttributedString *)content {
    _content = content;
    self.contentL.attributedText = content;   
}

@end

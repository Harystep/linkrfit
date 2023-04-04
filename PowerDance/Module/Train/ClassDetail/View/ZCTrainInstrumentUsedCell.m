//
//  ZCTrainInstrumentUsedCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/6.
//

#import "ZCTrainInstrumentUsedCell.h"

@interface ZCTrainInstrumentUsedCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@end

@implementation ZCTrainInstrumentUsedCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.iconIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"imgUrl"])] placeholderImage:kIMAGE(@"")];
}

@end

//
//  ZCTrainDetailGroupHeaderView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/29.
//

#import "ZCTrainDetailGroupHeaderView.h"

@interface ZCTrainDetailGroupHeaderView ()

@property (nonatomic,strong) UILabel *groupL;
@property (nonatomic,strong) UILabel *loopL;

@end

@implementation ZCTrainDetailGroupHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *bgView = [[UIView alloc] init];
    [bgView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(15));
    }];
    
    self.groupL = [self createSimpleLabelWithTitle:@"" font:14 bold:YES color:[ZCConfigColor txtColor]];
    [bgView addSubview:self.groupL];
    [self.groupL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.leading.mas_equalTo(bgView.mas_leading).offset(AUTO_MARGIN(15));
    }];
    
    self.loopL = [self createSimpleLabelWithTitle:@"" font:14 bold:YES color:[ZCConfigColor txtColor]];
    [bgView addSubview:self.loopL];
    [self.loopL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.trailing.mas_equalTo(bgView.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.groupL.text = checkSafeContent(dataDic[@"title"]);
    NSInteger count = [dataDic[@"loop"] integerValue];
    if (count == 1) {
        self.loopL.hidden = YES;
    } else {
        self.loopL.hidden = NO;
        self.loopL.text = [NSString stringWithFormat:@"%@%tu", NSLocalizedString(@"重复：", nil), count];
    }
    
}

@end

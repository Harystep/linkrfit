//
//  ZCBuyGoodsInfoView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/19.
//

#import "ZCBuyGoodsInfoView.h"

@implementation ZCBuyGoodsInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UIView *topView = [[UIView alloc] init];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(96));
    }];
    [self createTopViewSubViews:topView];
}

- (void)createTopViewSubViews:(UIView *)topView {
    UIView *lineView = [[UIView alloc] init];
    self.lineView = lineView;
    lineView.backgroundColor = rgba(43, 42, 51, 0.1);
    [topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(topView);
        make.height.mas_equalTo(1);
        make.trailing.mas_equalTo(topView.mas_trailing);
        make.leading.mas_equalTo(topView.mas_leading).offset(AUTO_MARGIN(20));
    }];
    
    self.iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"")];
//    self.iconIv.contentMode = UIViewContentModeScaleAspectFill;
    [topView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(AUTO_MARGIN(60));
        make.top.leading.mas_equalTo(AUTO_MARGIN(20));
    }];
    
    self.nameL = [self createSimpleLabelWithTitle:NSLocalizedString(@" ", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [topView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_top).offset(AUTO_MARGIN(35));
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(15));
    }];
    
    self.subNameL = [self createSimpleLabelWithTitle:NSLocalizedString(@" ", nil) font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    [topView addSubview:self.subNameL];
    [self.subNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameL.mas_bottom).offset(AUTO_MARGIN(9));
        make.leading.mas_equalTo(self.nameL.mas_leading);
        make.trailing.mas_equalTo(topView.mas_trailing).inset(AUTO_MARGIN(15));
    }];
    
    self.numL = [self createSimpleLabelWithTitle:NSLocalizedString(@"x1", nil) font:15 bold:YES color:[ZCConfigColor txtColor]];
    [topView addSubview:self.numL];
    [self.numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(topView.mas_trailing).inset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(self.nameL.mas_centerY);
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSArray *productList = dataDic[@"productList"];
    if (productList.count > 0) {
        NSDictionary *infoDic = productList[0];
        self.nameL.text = infoDic[@"name"];
        NSInteger count = [infoDic[@"count"] integerValue];
        self.subNameL.text = checkSafeContent(infoDic[@"specTitle"]);
        self.numL.text = [NSString stringWithFormat:@"x%tu", count];
        [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(infoDic[@"imgUrl"])] placeholderImage:nil];
    }
}

@end

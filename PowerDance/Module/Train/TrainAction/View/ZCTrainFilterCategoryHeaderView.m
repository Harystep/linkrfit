//
//  ZCTrainFilterCategoryHeaderView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/16.
//

#import "ZCTrainFilterCategoryHeaderView.h"

@implementation ZCTrainFilterCategoryHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.titleL = [self createSimpleLabelWithTitle:@"" font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.top.bottom.mas_equalTo(self);
    }];
    
    UIButton *operateBtn = [[UIButton alloc] init];
    self.operateBtn = operateBtn;
    [self addSubview:operateBtn];
    [operateBtn setImage:kIMAGE(@"base_arrow_up") forState:UIControlStateNormal];
    [operateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleL.mas_centerY);
        make.width.height.mas_equalTo(AUTO_MARGIN(30));
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(10));
    }];
    [operateBtn addTarget:self action:@selector(operateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)operateBtnClick {
    [self routerWithEventName:@"" userInfo:@{}];
}

@end

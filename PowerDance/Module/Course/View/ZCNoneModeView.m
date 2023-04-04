//
//  ZCNoneModeView.m
//  BrandGogo
//
//  Created by PC-N121 on 2022/6/24.
//

#import "ZCNoneModeView.h"

@implementation ZCNoneModeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createModeSubviews];
    }
    return self;
}

- (void)createModeSubviews {
    
}

- (void)configureNoneViewWithData:(NSArray *)dataArr {
    if (dataArr.count > 0) {
        self.noneView.hidden = YES;
    } else {
        self.noneView.hidden = NO;
    }
}

- (void)setShowNoneStatus:(BOOL)showNoneStatus {
    _showNoneStatus = showNoneStatus;
    if (showNoneStatus) {
        self.noneView.hidden = NO;
    } else {
        self.noneView.hidden = YES;
    }
}

- (ZCSimpleNoneView *)noneView {
    if (!_noneView) {
        _noneView = [[ZCSimpleNoneView alloc] init];
        [self addSubview:_noneView];
        [_noneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return _noneView;
}

@end

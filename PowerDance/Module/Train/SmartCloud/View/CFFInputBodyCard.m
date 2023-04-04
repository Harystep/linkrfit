//
//  CFFInputBodyCard.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/25.
//

#import "CFFInputBodyCard.h"
#import "CFFInputBodyDataView.h"

@interface CFFInputBodyCard ()

@property (nonatomic,strong)CFFInputBodyDataView *weightView;
@property (nonatomic,strong)CFFInputBodyDataView *heightView;

@end

@implementation CFFInputBodyCard
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = kCFF_COLOR_GRAY_COMMON;
        [self addSubview:self.weightView];
        [self addSubview:self.heightView];
        self.weightView.type = CFFBodyDataType_Weight;
        self.heightView.type = CFFBodyDataType_Height;
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints{
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"stepOneWeightAlert", nil) font:12 bold:NO color:RGBA_COLOR(0, 0, 0, 0.5)];
    [self addSubview:titleL];
    titleL.numberOfLines = 0;
    titleL.lineBreakMode = NSLineBreakByCharWrapping;
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self).offset(AUTO_MARGIN(15));
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(15));
    }];
    
    CGFloat halfWidth = (kCFF_SCREEN_WIDTH - 15 * 2) / 2;
    [self.weightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(@(halfWidth));
    }];
    [self.heightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.equalTo(@(halfWidth));
    }];
}

- (CFFInputBodyDataView *)weightView {
    if (!_weightView) {
        _weightView = [[CFFInputBodyDataView alloc] init];
    }
    return _weightView;
}

- (CFFInputBodyDataView *)heightView {
    if (!_heightView) {
        _heightView = [[CFFInputBodyDataView alloc] init];
    }
    return _heightView;
}

@end

//
//  CFFNoneDataView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/10/22.
//

#import "CFFNoneDataView.h"

@interface CFFNoneDataView ()

@property (nonatomic,strong) UIImageView *iconIv;
@property (nonatomic,strong) UILabel *alertContentL;

@end

@implementation CFFNoneDataView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    self.iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"data_no_more")];
    [contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(contentView);
    }];
    
    self.alertContentL = [self createSimpleLabelWithTitle:NSLocalizedString(@"暂无内容", nil) font:14 bold:NO color:kCFF_COLOR_CONTENT_TITLE];
    [contentView addSubview:self.alertContentL];
    [self.alertContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(contentView.mas_bottom);
    }];
    
    
}


@end

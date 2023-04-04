//
//  ZCMyBottomSetView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/8.
//

#import "ZCMyBottomSetView.h"

@interface ZCMyBottomSetView ()

@property (nonatomic,strong) NSArray *titleArr;

@end

@implementation ZCMyBottomSetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    CGFloat width = (SCREEN_W - AUTO_MARGIN(40))/3.0;
    for (int i = 0; i < self.titleArr.count; i ++) {
        NSDictionary *dic = self.titleArr[i];
        UIView *contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.mas_leading).offset(i * width);
            make.top.bottom.mas_equalTo(self);
            make.width.mas_equalTo(width);
        }];
        contentView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOperate:)];
        [contentView addGestureRecognizer:tap];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:kIMAGE(dic[@"image"])];
        icon.contentMode = UIViewContentModeCenter;
        [contentView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(AUTO_MARGIN(50));
            make.centerX.mas_equalTo(contentView);
            make.top.mas_equalTo(contentView).offset(AUTO_MARGIN(25));
        }];
        icon.backgroundColor = rgba(246, 246, 246, 1);
        [icon setViewCornerRadiu:AUTO_MARGIN(25)];
        
        UILabel *titleL = [self createSimpleLabelWithTitle:dic[@"title"] font:14 bold:NO color:[ZCConfigColor txtColor]];
        [contentView addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(icon);
            make.top.mas_equalTo(icon.mas_bottom).offset(AUTO_MARGIN(10));
        }];
        
    }
}

- (void)clickOperate:(UITapGestureRecognizer *)tap {
    switch (tap.view.tag) {
        case 0:
            [HCRouter router:@"MyOrderList" params:@{} viewController:self.superViewController animated:YES];
            break;
        case 1:
            [HCRouter router:@"ContactService" params:@{} viewController:self.superViewController animated:YES];
            break;
        case 2:
            [HCRouter router:@"MoreSet" params:@{} viewController:self.superViewController animated:YES];
            break;
            
        default:
            break;
    }
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[
            @{@"image":@"my_order", @"title":NSLocalizedString(@"我的订单", nil)},
            @{@"image":@"my_message", @"title":NSLocalizedString(@"客服反馈", nil)},
            @{@"image":@"my_set", @"title":NSLocalizedString(@"更多设置", nil)}
        ];
    }
    return _titleArr;
}

@end

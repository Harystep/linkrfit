//
//  ZCSuitOperateView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/7/28.
//

#import "ZCSuitOperateView.h"

@interface ZCSuitOperateView ()

@property (nonatomic,strong) UIView *itemView;

@end

@implementation ZCSuitOperateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    [self setupSubviews:self];
}


- (void)setupSubviews:(UIView *)topView {
    CGFloat marginX = AUTO_MARGIN(28);
    CGFloat width = (SCREEN_W - AUTO_MARGIN(80) - AUTO_MARGIN(56)) / 3.0;
    for (int i = 0; i < 3; i ++) {
        self.itemView = [[UIView alloc] init];
        [topView addSubview:self.itemView];
        [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.leading.mas_equalTo((width+marginX)*i);
            make.bottom.top.mas_equalTo(topView);
        }];
        UILabel *lb = [self createSimpleLabelWithTitle:[NSString stringWithFormat:@"%d", i+1] font:AUTO_MARGIN(12) bold:YES color:[ZCConfigColor whiteColor]];;
        lb.backgroundColor = [ZCConfigColor txtColor];
        [lb setViewCornerRadiu:AUTO_MARGIN(8)];
        lb.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            [self.itemView addSubview:lb];
            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.itemView.mas_centerX);
                make.width.height.mas_equalTo(AUTO_MARGIN(16));
                make.centerY.mas_equalTo(self.itemView.mas_centerY);
            }];
        } else {
            [self.itemView addSubview:lb];
            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.itemView.mas_centerX).offset(AUTO_MARGIN(-12));
                make.width.height.mas_equalTo(AUTO_MARGIN(16));
                make.centerY.mas_equalTo(self.itemView.mas_centerY);
            }];
            
            UIButton *btn = [[UIButton alloc] init];
            [self.itemView addSubview:btn];
            [btn setImage:kIMAGE(@"device_operate") forState:UIControlStateNormal];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.itemView.mas_centerX).offset(AUTO_MARGIN(12));
                make.width.height.mas_equalTo(AUTO_MARGIN(30));
                make.bottom.top.mas_equalTo(self.itemView);
            }];
            [btn setViewCornerRadiu:AUTO_MARGIN(8)];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnOperate:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)btnOperate:(UIButton *)sender {
    [self routerWithEventName:@"move" userInfo:@{@"index":@(sender.tag)}];
}

@end

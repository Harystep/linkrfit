//
//  ZCGoodsNumView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import "ZCGoodsNumView.h"

@interface ZCGoodsNumView ()

@end

@implementation ZCGoodsNumView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [view setViewBorderWithColor:1 color:rgba(0, 0, 0, 0.07)];
    [view setViewCornerRadiu:16];
    
    UIButton *add = [[UIButton alloc] init];
    add.tag = 1;
    [view addSubview:add];
    [add setImage:kIMAGE(@"goods_num_add") forState:UIControlStateNormal];
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(26);
    }];
    [add addTarget:self action:@selector(numOperate:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *mouse = [[UIButton alloc] init];
    [view addSubview:mouse];
    [mouse setImage:kIMAGE(@"goods_num_mouse") forState:UIControlStateNormal];
    [mouse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(26);
    }];
    mouse.tag = 0;
    [mouse addTarget:self action:@selector(numOperate:) forControlEvents:UIControlEventTouchUpInside];
    
    self.numF = [[UITextField alloc] init];
    self.numF.textAlignment = NSTextAlignmentCenter;
    self.numF.font = FONT_BOLD(20);
    self.numF.textColor = rgba(43, 42, 51, 1);
    self.numF.text = @"1";
    [view addSubview:self.numF];
    [self.numF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(mouse.mas_trailing);
        make.trailing.mas_equalTo(add.mas_leading);
        make.bottom.top.mas_equalTo(view);
    }];
    
}

- (void)numOperate:(UIButton *)sender {
    if (sender.tag) {
        NSInteger count = [self.numF.text integerValue];
        count ++;
        self.numF.text = [NSString stringWithFormat:@"%tu", count];
    } else {
        NSInteger count = [self.numF.text integerValue];
        if (count <= 1) return;
        count --;
        self.numF.text = [NSString stringWithFormat:@"%tu", count];
    }
    if (self.selectGoodsNumBlock) {
        self.selectGoodsNumBlock(self.numF.text);
    }
}

@end

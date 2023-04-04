//
//  ZCSimpleTextView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/24.
//

#import "ZCSimpleTextView.h"

@implementation ZCSimpleTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UIView *bgView = [[UIView alloc] init];
    self.bgView = bgView;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITextField *tf = [[UITextField alloc] init];
    self.contentF = tf;
    tf.font = FONT_SYSTEM(14);
    tf.textColor = [ZCConfigColor txtColor];
    [self addSubview:tf];    
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self).inset(AUTO_MARGIN(10));
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(15));
    }];
}

@end

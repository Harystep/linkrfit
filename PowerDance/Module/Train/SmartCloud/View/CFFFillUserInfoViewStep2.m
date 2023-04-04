//
//  CFFFillUserInfoViewStep2.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/25.
//

#import "CFFFillUserInfoViewStep2.h"

@interface CFFFillUserInfoViewStep2 ()

@end

@implementation CFFFillUserInfoViewStep2

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.targetView = [[CFFUserInfoSelectTargetView alloc] init];
    [self addSubview:self.targetView];
    [self.targetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self);
    }];
}


@end

//
//  ZCSimpleButton.m
//  FitTimer
//
//  Created by PC-N121 on 2021/12/27.
//

#import "ZCSimpleButton.h"

@interface ZCSimpleButton ()

@property (nonatomic,strong) UIColor *currentColor;

@end

@implementation ZCSimpleButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];    
    
}

- (void)touchDown {
    self.currentColor = self.backgroundColor;
    self.backgroundColor = [ZCConfigColor subTxtColor];
    self.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.backgroundColor = self.currentColor;
        self.userInteractionEnabled = YES;
    });
}


@end

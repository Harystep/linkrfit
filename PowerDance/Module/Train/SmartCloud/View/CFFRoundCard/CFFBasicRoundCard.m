//
//  CFFFBasicRoundCard.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/25.
//

#import "CFFBasicRoundCard.h"


@interface CFFBasicRoundCard ()



@end

@implementation CFFBasicRoundCard

- (instancetype) init {
    self = [super init];
    if (self) {
//        self.layer.cornerRadius = 10;
        self.layer.cornerRadius = 10;
        self.layer.borderWidth = kCFF_SINGLE_LINE_WIDTH;
        self.isWarning = NO;
        
    }
    return self;
}

- (void)setIsWarning:(BOOL)isWarning {
    _isWarning = isWarning;
    if (isWarning) {
        self.layer.borderColor = [UIColor redColor].CGColor;
    }else {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end

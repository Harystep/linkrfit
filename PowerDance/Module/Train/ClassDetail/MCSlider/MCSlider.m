//
//  MCSlider.m
//  MCSlider
//
//  Created by M_Code on 2017/10/10.
//  Copyright © 2017年 M_Code. All rights reserved.
//

#import "MCSlider.h"

@implementation MCSlider
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    bounds = [super trackRectForBounds:bounds];
    CGFloat y = bounds.origin.y;
    if (self.lineTop != y) {
        if (_delegate && [_delegate respondsToSelector:@selector(updateSliderFrame:)]) {
            self.lineTop = y;
            [_delegate updateSliderFrame:bounds];
        }
    }
    return CGRectMake(bounds.origin.x, y, bounds.size.width, MCSliderLineHeight);
}
@end

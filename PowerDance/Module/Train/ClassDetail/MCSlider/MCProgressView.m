//
//  MCProgressView.m
//  MCSlider
//
//  Created by M_Code on 2017/10/10.
//  Copyright © 2017年 M_Code. All rights reserved.
//

#import "MCProgressView.h"

@implementation MCProgressView

-(void)setProgress:(CGFloat)progress
{
    _progress=progress;
    [self setNeedsDisplay];
}
- (void)setProColor:(UIColor *)proColor
{
    _proColor = proColor;
    [self setNeedsDisplay];
}
- (void)setSurColor:(UIColor *)surColor
{
    _surColor = surColor;
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect
{
    CGFloat w = self.progress * self.frame.size.width;
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath * p1 = [UIBezierPath bezierPathWithRect:CGRectMake(rect.origin.x, rect.origin.y,w,self.frame.size.height)];
    CGContextAddPath(context, p1.CGPath);
    [self.proColor set];
    CGContextFillPath(context);
    UIBezierPath * p2 = [UIBezierPath bezierPathWithRect:CGRectMake(w, rect.origin.y,self.frame.size.width - w,self.frame.size.height)];
    CGContextAddPath(context, p2.CGPath);
    [self.surColor set];
    CGContextFillPath(context);
}

@end

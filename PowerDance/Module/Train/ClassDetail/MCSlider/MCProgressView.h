//
//  MCProgressView.h
//  MCSlider
//
//  Created by M_Code on 2017/10/10.
//  Copyright © 2017年 M_Code. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCProgressView : UIView
/**
 *  进度 这个进度 是百分比 0 - 1
 */
@property (nonatomic, assign) CGFloat progress;
/**
 *  进度的颜色
 */
@property (nonatomic, retain) UIColor * proColor;
/**
 *  剩余的颜色
 */
@property (nonatomic, retain) UIColor *  surColor;
@end

//
//  MCSlider.h
//  MCSlider
//
//  Created by M_Code on 2017/10/10.
//  Copyright © 2017年 M_Code. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MCSliderLineHeight 8.0f  //进度条的线条高度 (最好是整数 小数大小不一)
@protocol MCSliderDelegate <NSObject>
- (void)updateSliderFrame:(CGRect)rect;
@end

@interface MCSlider : UISlider
@property (assign, nonatomic) CGFloat lineTop;
@property (weak, nonatomic) id<MCSliderDelegate> delegate;
@end

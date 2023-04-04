//
//  UIButton+Extra.m
//  DNProject
//
//  Created by zjs on 2019/1/16.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "UIButton+Extra.h"
#import <objc/runtime.h>

@implementation UIButton (Extra)

static NSString *insideHandlerKey = @"insideHandlerKey";

- (void)dn_selectorEvenHandler:(TouchHandler)handler {
    
    [self dn_selectorEvent:UIControlEventTouchUpInside handler:^{
       
        handler();
    }];
}

- (void)dn_selectorEvent:(UIControlEvents)events handler:(TouchHandler)handler {
    
    objc_setAssociatedObject(self, &insideHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(selectorEvent) forControlEvents:events];
}

- (void)selectorEvent {
    
    TouchHandler handler = (TouchHandler)objc_getAssociatedObject(self, &insideHandlerKey);
    if (handler) {
        handler();
    }
}

- (void)dn_layoutButtonEdgeInset:(DNEdgeInsetStyle)style space:(CGFloat)space {
    
    // 强制更新布局，以获得最新的 imageView 和 titleLabel 的 frame
    [self layoutIfNeeded];
    
    // 1. 得到imageView和titleLabel的宽、高
    //    CGFloat imageWith = self.imageView.frame.size.width;
    //    CGFloat imageHeight = self.imageView.frame.size.height;
    CGFloat imageWith = self.currentImage.size.width;
    CGFloat imageHeight = self.currentImage.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case DNEdgeInsetStyleTop: {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space, 0);
        }
            break;
        case DNEdgeInsetStyleLeft: {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space, 0, space);
            labelEdgeInsets = UIEdgeInsetsMake(0, space, 0, -space);
        }
            break;
        case DNEdgeInsetStyleBottom: {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space, -imageWith, 0, 0);
        }
            break;
        case DNEdgeInsetStyleRight: {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space, 0, -labelWidth-space);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space, 0, imageWith+space);
        }
            break;
        default:
            break;
    }
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

- (void)dn_timeDown:(NSInteger)timeDown {
    
    [self dn_timeDown:timeDown downStr:@"" finishStr:@"重新发送"];
}

- (void)dn_timeDown:(NSInteger)timeDown downStr:(NSString *)downStr finishStr:(NSString *)finishStr {
    
    __block NSInteger  time = timeDown;
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 每秒执行一次
    dispatch_source_set_timer(_time, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_time, ^{
        
        if (time <= 0) {
            
            dispatch_source_cancel(_time);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.userInteractionEnabled = YES;
                [self setTitle:finishStr forState:UIControlStateNormal];
            });
            
        } else {
            
            int seconds = time % 61;
            NSString *timeStr = [NSString stringWithFormat:@"%@%.2d s", downStr, seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.userInteractionEnabled = NO;
                [self setTitle:timeStr forState:UIControlStateNormal];
            });
            time--;
        }
    });
    dispatch_resume(_time);
}

- (void)configureButtonImage:(NSString *)imageStr selImage:(NSString *)selImageStr {
    [self setImage:kIMAGE(imageStr) forState:UIControlStateNormal];
    [self setImage:kIMAGE(selImageStr) forState:UIControlStateSelected];
}

@end

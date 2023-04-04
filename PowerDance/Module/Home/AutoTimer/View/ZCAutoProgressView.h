//
//  ZCAutoProgressView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCAutoProgressView : UIView

@property (nonatomic, assign) CGFloat progress;
//进度条颜色
@property(nonatomic,strong) UIColor *progerssColor;
//进度条背景颜色
@property(nonatomic,strong) UIColor *progerssBackgroundColor;
//进度条边框的颜色
@property(nonatomic,strong) UIColor *progerssStokeBackgroundColor;
//进度条边框的宽度
@property(nonatomic,assign) CGFloat progerStokeWidth;

@end

NS_ASSUME_NONNULL_END

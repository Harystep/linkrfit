//
//  ZCClassPlayMiddleView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCClassPlayMiddleView : UIView

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic, copy) NSString *iconStr;

- (void)fireCustomTimer;

@end

NS_ASSUME_NONNULL_END

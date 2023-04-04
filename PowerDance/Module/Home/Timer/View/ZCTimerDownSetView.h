//
//  ZCTimerDownSetView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/12/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCTimerDownSetView : UIView

@property (nonatomic, copy) void(^sureRepeatOperate)(NSString *content);

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic, copy) NSString *valueStr;
@property (nonatomic, copy) NSString *mouseStr;
@property (nonatomic, copy) NSString *minuteStr;

@end

NS_ASSUME_NONNULL_END

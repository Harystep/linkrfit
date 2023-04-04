//
//  ZCAutoTimerDownSetView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCAutoTimerDownSetView : UIView

@property (nonatomic, copy) void (^saveBownTimeOperate)(NSString *time);

@end

NS_ASSUME_NONNULL_END

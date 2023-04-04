//
//  ZCAutoActionView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCAutoActionView : UIView

@property (nonatomic, copy) void (^saveAutoActionOperate)(id value);

@end

NS_ASSUME_NONNULL_END

//
//  ZCAlertView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCAlertView : UIView

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) void(^sureEditOperate)(NSString *content);

- (void)showAlertView;

@end

NS_ASSUME_NONNULL_END

//
//  ZCCustomCourseEditView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCustomCourseEditView : UIView

@property (nonatomic, copy) void(^sureEditOperate)(NSString *content);

- (void)showAlertView;

- (void)hideAlertView;

@end

NS_ASSUME_NONNULL_END

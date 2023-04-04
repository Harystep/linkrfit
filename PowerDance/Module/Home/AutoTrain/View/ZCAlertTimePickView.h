//
//  ZCAlertTimePickView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCAlertTimePickView : UIView

@property (nonatomic, copy) void(^sureRepeatOperate)(NSString *content);

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,assign) BOOL close;

@property (nonatomic,assign) NSInteger hourType;

- (void)showAlertView;

@end

NS_ASSUME_NONNULL_END

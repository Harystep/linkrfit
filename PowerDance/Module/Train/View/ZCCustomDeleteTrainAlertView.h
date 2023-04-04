//
//  ZCCustomDeleteTrainAlertView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCustomDeleteTrainAlertView : UIView

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, copy) NSString *content;

@property (nonatomic,strong) NSString *time;

@property (nonatomic, copy) void(^sureEditOperate)(NSString *content);

- (void)showAlertView;

@end

NS_ASSUME_NONNULL_END

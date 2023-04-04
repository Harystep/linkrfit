//
//  ZCClassTrainOverView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/4/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCClassTrainOverView : UIView

@property (nonatomic, copy) void (^handleTrainOperate)(NSInteger type);

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, copy) NSString *leftStr;

@property (nonatomic, copy) NSString *rightStr;


- (void)showAlertView;

@end

NS_ASSUME_NONNULL_END

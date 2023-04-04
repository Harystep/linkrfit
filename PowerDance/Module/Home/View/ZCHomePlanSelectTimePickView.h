//
//  ZCHomePlanSelectTimePickView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCHomePlanSelectTimePickView : UIView

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic, copy) NSString *valueStr;
@property (nonatomic, copy) NSString *mouseStr;
@property (nonatomic, copy) NSString *minuteStr;

@end

NS_ASSUME_NONNULL_END

//
//  ZCCustomTrainTimeView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCustomTrainTimeView : UIView

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic, copy) NSString *valueStr;
@property (nonatomic, copy) NSString *mouseStr;
@property (nonatomic, copy) NSString *minuteStr;

@end

NS_ASSUME_NONNULL_END

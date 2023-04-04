//
//  ZCTrainSportDownView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/12/1.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCTrainSportDownView : UIView

@property (nonatomic,strong) void (^downFunctionFinish)(void);

@end

NS_ASSUME_NONNULL_END

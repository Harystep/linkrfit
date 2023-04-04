//
//  ZCArrivePlaceView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCArrivePlaceView : UIView

@property (nonatomic, copy) void(^sureAddressOperate)(id value);

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

NS_ASSUME_NONNULL_END

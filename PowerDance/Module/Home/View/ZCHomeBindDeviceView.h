//
//  ZCHomeBindDeviceView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCHomeBindDeviceView : UIView

@property (nonatomic, copy) void (^bindDeviceOperate)(void);
@property (nonatomic, copy) void (^hideDeviceOperate)(void);
@property (nonatomic, copy) void (^connectDeviceOperate)(NSDictionary *dic);

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) NSArray *dataArr;

- (void)showContentView;

- (void)hideContentView;

@end

NS_ASSUME_NONNULL_END

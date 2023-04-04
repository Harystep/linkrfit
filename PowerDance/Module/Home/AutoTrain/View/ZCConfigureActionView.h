//
//  ZCConfigureActionView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCConfigureActionView : UIView

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic, copy) NSString *energy;

@property (nonatomic, copy) void (^saveActionTimeOperate)(NSDictionary *dic);

@property (nonatomic,assign) BOOL restStatus;

@end

NS_ASSUME_NONNULL_END

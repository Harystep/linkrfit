//
//  ZCPowerPlatformTypeView.h
//  PowerDance
//
//  Created by oneStep on 2023/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCPowerPlatformTypeView : UIView

@property (nonatomic,strong) UILabel *unitL;

@property (nonatomic,strong) UIButton *targetSetBtn;//目标设置

@property (nonatomic,strong) UILabel *consumeL;//消耗

@property (nonatomic,strong) UILabel *totalL;//实际拉力

@property (nonatomic,strong) UILabel *eruptL;//爆发力

@property (nonatomic,strong) UILabel *totalTL;//实际拉力

@property (nonatomic,strong) UILabel *eruptTL;//爆发力

@end

NS_ASSUME_NONNULL_END

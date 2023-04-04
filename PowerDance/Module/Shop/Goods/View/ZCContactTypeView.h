//
//  ZCContactTypeView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import <UIKit/UIKit.h>
#import "ZCShopAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCContactTypeView : UIView

@property (nonatomic,strong) UITextField *nameF;
@property (nonatomic,strong) UITextField *phoneF;

@property (nonatomic,strong) ZCShopAddressModel *model;

@end

NS_ASSUME_NONNULL_END

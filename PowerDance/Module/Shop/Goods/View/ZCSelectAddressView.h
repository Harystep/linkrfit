//
//  ZCSelectAddressView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/15.
//

#import <UIKit/UIKit.h>
#import "ZCShopAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    AddressTypeProvinceMode = 0,
    AddressTypeCityMode,
} AddressTypeMode;

@interface ZCSelectAddressView : UIView

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UITextField *contentF;

@property (nonatomic, copy) NSString *provinceName;

@property (nonatomic,assign) AddressTypeMode addressMode;

@property (nonatomic, copy) void(^changeProvinceBlock)(NSString *content);

@property (nonatomic, copy) void(^saveProvinceBlock)(NSString *content);

@property (nonatomic,strong) ZCShopAddressModel *model;

@end

NS_ASSUME_NONNULL_END

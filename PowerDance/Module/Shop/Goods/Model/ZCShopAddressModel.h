//
//  ZCShopAddressModel.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCShopAddressModel : NSObject

@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *isDefault;

@end

NS_ASSUME_NONNULL_END

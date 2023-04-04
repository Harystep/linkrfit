//
//  CFFSmartDeviceInfoModel.h
//  CofoFit
//
//  Created by PC-N121 on 2021/9/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFFSmartDeviceInfoModel : NSObject

@property (nonatomic, copy) NSString *deviceId;

@property (nonatomic, copy) NSString *deviceName;

@property (nonatomic, copy) NSString *deviceRemark;

@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, copy) NSString *jumpCode;

@end

NS_ASSUME_NONNULL_END

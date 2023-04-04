//
//  ZCEquipmentModel.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCEquipmentModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *briefDesc;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *flag;
@property (nonatomic,assign) BOOL status;

@end

NS_ASSUME_NONNULL_END

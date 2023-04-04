//
//  ZCGoodsTypeModel.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCGoodsTypeModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *imgUrl;
//@property (nonatomic, copy) NSString *sellPrice;
@property (nonatomic, copy) NSString *sellPriceDou;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *specTitle;
@property (nonatomic, copy) NSString *status;

@end

NS_ASSUME_NONNULL_END

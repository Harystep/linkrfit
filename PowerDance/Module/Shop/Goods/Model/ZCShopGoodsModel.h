//
//  ZCShopGoodsModel.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCShopGoodsModel : NSObject

@property (nonatomic, copy) NSString *briefDesc;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *priceDou;
@property (nonatomic,strong) NSArray *productImgs;
@property (nonatomic, copy) NSString *saleable;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *scopeCount;


@end

NS_ASSUME_NONNULL_END

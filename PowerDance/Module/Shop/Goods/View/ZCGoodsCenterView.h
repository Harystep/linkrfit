//
//  ZCGoodsCenterView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import <UIKit/UIKit.h>
@class ZCShopAddressModel;
@class ZCShopGoodsModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZCGoodsCenterView : UIView

@property (nonatomic,strong) ZCShopGoodsModel *goodsModel;

@property (nonatomic,strong) ZCShopAddressModel *model;

@property (nonatomic,assign) NSInteger num;

@end

NS_ASSUME_NONNULL_END

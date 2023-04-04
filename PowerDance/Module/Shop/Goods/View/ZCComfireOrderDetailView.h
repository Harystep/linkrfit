//
//  ZCComfireOrderDetailView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/15.
//

#import <UIKit/UIKit.h>
@class ZCShopGoodsModel;
@class ZCGoodsTypeModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZCComfireOrderDetailView : UIView

@property (nonatomic,strong) ZCShopGoodsModel *model;

@property (nonatomic,strong) ZCGoodsTypeModel *typeModel;

@property (nonatomic,assign) NSInteger num;

@end

NS_ASSUME_NONNULL_END

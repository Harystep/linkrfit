//
//  ZCSelectShopTypeView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/24.
//

#import <UIKit/UIKit.h>
@class ZCShopGoodsModel;


NS_ASSUME_NONNULL_BEGIN

@interface ZCSelectShopTypeView : UIView

@property (nonatomic,strong) ZCShopGoodsModel *goodsModel;

@property (nonatomic,strong) NSMutableArray *typeArr;

@property (nonatomic, copy) void (^exitSelectOperate)(void);

@property (nonatomic, copy) void (^selectGoodsNumOperate)(NSString *value);

@property (nonatomic, copy) void (^payGoodsOpereate)(id value);

@end

NS_ASSUME_NONNULL_END

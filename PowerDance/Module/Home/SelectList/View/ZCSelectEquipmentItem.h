//
//  ZCSelectEquipmentItem.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/26.
//

#import <UIKit/UIKit.h>
@class ZCEquipmentModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZCSelectEquipmentItem : UICollectionViewCell

@property (nonatomic, copy) void (^deleteItemOperate)(id value);

@property (nonatomic,strong) ZCEquipmentModel *model;

@end

NS_ASSUME_NONNULL_END

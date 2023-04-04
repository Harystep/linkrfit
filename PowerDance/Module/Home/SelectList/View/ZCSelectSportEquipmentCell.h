//
//  ZCSelectSportEquipmentCell.h
//  PowerDance
//
//  Created by PC-N121 on 2021/10/29.
//

#import <UIKit/UIKit.h>
@class ZCEquipmentModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZCSelectSportEquipmentCell : UICollectionViewCell

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) ZCEquipmentModel *model;

@end

NS_ASSUME_NONNULL_END

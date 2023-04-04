//
//  ZCTrainPlanDetailChartItemCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCTrainPlanDetailChartItemCell : UICollectionViewCell

@property (nonatomic,assign) double maxValues;

@property (nonatomic,assign) NSInteger selectFlag;//标记是否选中

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,strong) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END

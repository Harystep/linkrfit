//
//  ZCHomeTrainCardCell.h
//  PowerDance
//
//  Created by PC-N121 on 2021/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TrainTypeGeneral = 1,
    TrainTypeCustom,
    TrainTypeSystem,
} TrainType;

@interface ZCHomeTrainCardCell : UICollectionViewCell

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END

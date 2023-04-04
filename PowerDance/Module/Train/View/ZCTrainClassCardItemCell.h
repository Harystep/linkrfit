//
//  ZCTrainClassCardItemCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/11.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PostStyleBottom = 0,
    PostStyleCenter,
    PostStyleTop,
} PostStyle;

NS_ASSUME_NONNULL_BEGIN

@interface ZCTrainClassCardItemCell : UICollectionViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,assign) PostStyle postStyle;

@end

NS_ASSUME_NONNULL_END

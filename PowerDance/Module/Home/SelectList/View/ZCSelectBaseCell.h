//
//  ZCSelectBaseCell.h
//  PowerDance
//
//  Created by PC-N121 on 2021/10/29.
//

#import <UIKit/UIKit.h>
#import "ZCColorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCSelectBaseCell : UICollectionViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) ZCColorModel *model;

@end

NS_ASSUME_NONNULL_END

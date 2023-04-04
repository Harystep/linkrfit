//
//  ZCClassDetailActionRestCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/4/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCClassDetailActionRestCell : UICollectionViewCell

@property (nonatomic,assign) NSInteger signDeleteFlag;

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END

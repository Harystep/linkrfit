//
//  ZCTrainProfessionItemCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/7/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCTrainProfessionItemCell : UICollectionViewCell

@property (nonatomic,strong) NSDictionary *titleDic;

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END

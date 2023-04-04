//
//  ZCCustomCourseAddItemCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/5/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCustomCourseAddItemCell : UICollectionViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) NSDictionary *actionDic;

@property (nonatomic,assign) NSInteger signDeleteFlag;

@property (nonatomic,assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END

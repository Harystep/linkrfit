//
//  ZCTrainFilterClassCategoryView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCTrainFilterClassCategoryView : UIView

@property (nonatomic, copy) void (^saveFilterData)(NSDictionary *dataDic);

@property (nonatomic,strong) NSArray *dataArr;

@end

NS_ASSUME_NONNULL_END

//
//  ZCTrainFilterCategoryView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCTrainFilterActionCategoryView : UIView

@property (nonatomic, copy) void (^saveFilterData)(NSDictionary *dataDic);

@property (nonatomic, copy) void (^cleanFilterData)(void);

@property (nonatomic,strong) NSArray *dataArr;

@end

NS_ASSUME_NONNULL_END

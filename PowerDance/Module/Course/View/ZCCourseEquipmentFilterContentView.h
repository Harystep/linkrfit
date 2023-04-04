//
//  ZCCourseEquipmentFilterContentView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCourseEquipmentFilterContentView : UIView

@property (nonatomic, copy) void (^hideFilterViewOperate)(void);

@property (nonatomic, copy) void (^selectFilterItem)(id value);

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,assign) NSInteger selectIndex;

@end

NS_ASSUME_NONNULL_END

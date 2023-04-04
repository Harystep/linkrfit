//
//  ZCTrainPlanDetailDataCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCTrainPlanDetailDataCell : UIView

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,assign) NSInteger type;//时间类型

@property (nonatomic,assign) NSInteger selectRow;//选中列

@end

NS_ASSUME_NONNULL_END

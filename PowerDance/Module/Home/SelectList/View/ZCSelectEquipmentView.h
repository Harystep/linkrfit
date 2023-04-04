//
//  ZCSelectEquipmentView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCSelectEquipmentView : UIView

@property (nonatomic, copy) void (^deleteSelectItem)(id value);

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

NS_ASSUME_NONNULL_END

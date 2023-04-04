//
//  ZCCourseEquipmentFilterView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCourseEquipmentFilterView : UIView

@property (nonatomic, copy) void (^clickLabelResule)(id value);

/// 初始化
- (instancetype)init;

/// 行间距
@property (nonatomic) CGFloat spacingRow;
/// 列间距
@property (nonatomic) CGFloat spacingColumn;
/// 内容缩进
@property (nonatomic) UIEdgeInsets contentInset;
//1： 动作组  0 ：搜索
@property (nonatomic,assign) NSInteger type;

@property (nonatomic,strong) NSArray *tagsArr;

@property (nonatomic,assign) NSInteger selectIndex;//标记选中

@end

NS_ASSUME_NONNULL_END

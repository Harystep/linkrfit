//
//  ZCSportGroupTagView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCSportGroupTagView : UIView

@property (nonatomic, copy) void (^clickLabelResule)(id value);

/// 初始化
- (instancetype)init;

/// 行间距
@property (nonatomic) CGFloat spacingRow;
/// 列间距
@property (nonatomic) CGFloat spacingColumn;
/// 内容缩进
@property (nonatomic) UIEdgeInsets contentInset;
/// 加载小格子
@property (nonatomic, strong) NSArray *arrayTags;
//1： 动作组  0 ：搜索
@property (nonatomic,assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END

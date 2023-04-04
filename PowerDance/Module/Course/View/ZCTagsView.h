
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCTagsView : UIView

@property (nonatomic, copy) void (^clickLabelResule)(NSString *content);

/// 初始化
- (instancetype)init;

/// 行间距
@property (nonatomic) CGFloat spacingRow;
/// 列间距
@property (nonatomic) CGFloat spacingColumn;
/// 内容缩进
@property (nonatomic) UIEdgeInsets contentInset;
/// 加载小格子
@property (nonatomic, strong) NSArray <NSString *> *arrayTags;
//1： 动作组  0 ：搜索
@property (nonatomic,assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END

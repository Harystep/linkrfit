

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCircleDialView : UIView

@property (nonatomic,assign) NSInteger targetMouse;

@property (nonatomic,strong) UILabel *circleL;

@property (nonatomic,strong) UIColor *bgColor;
/// 是否顺时针
@property (nonatomic,assign) BOOL clockFlag;

@property (nonatomic,assign) double backMouseIndex;

@property (nonatomic,assign) double goBackCount;

- (void)startAnimal;

- (void)startAnimalOperate;

- (void)resetCircleView;

- (void)tick;

@end

NS_ASSUME_NONNULL_END

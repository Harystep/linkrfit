//
//  ZCShopTopView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCShopTopView : UICollectionReusableView

@property (nonatomic,strong) NSArray *favDataArr;//猜你喜欢

@property (nonatomic,strong) NSArray *nowDataArr;//上新产品呢

@property (nonatomic,strong) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END

//
//  ZCBuyGoodsInfoView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCBuyGoodsInfoView : UIView

@property (nonatomic,strong) UIImageView *iconIv;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *subNameL;
@property (nonatomic,strong) UILabel *numL;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END

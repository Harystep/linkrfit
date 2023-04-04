//
//  ZCArrviveAddressView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import <UIKit/UIKit.h>
#import "ZCShopAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCArrviveAddressView : UIView

@property (nonatomic,strong) UITextView *textF;

@property (nonatomic,strong) UILabel *placeStrL;

@property (nonatomic,strong) UITextField *addressF;

@property (nonatomic,strong) ZCShopAddressModel *model;

@end

NS_ASSUME_NONNULL_END

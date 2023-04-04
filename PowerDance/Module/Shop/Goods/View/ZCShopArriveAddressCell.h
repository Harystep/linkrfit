//
//  ZCShopArriveAddressCell.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import <UIKit/UIKit.h>
@class ZCShopAddressModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZCShopArriveAddressCell : UITableViewCell

@property (nonatomic,strong) ZCShopAddressModel *model;

@property (nonatomic,strong) UIButton *editBtn;

@property (nonatomic,strong) UIImageView *selectIv;

+ (instancetype)shopArriveAddressCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

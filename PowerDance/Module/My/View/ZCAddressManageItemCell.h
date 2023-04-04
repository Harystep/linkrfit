//
//  ZCAddressManageItemCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/12/5.
//

#import <UIKit/UIKit.h>
@class ZCShopAddressModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZCAddressManageItemCell : UITableViewCell

@property (nonatomic,strong) ZCShopAddressModel *model;

+ (instancetype)addressManageItemCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

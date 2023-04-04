//
//  ZCShopGoodsTypeCell.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/29.
//

#import <UIKit/UIKit.h>
@class ZCGoodsTypeModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZCShopGoodsTypeCell : UITableViewCell

@property (nonatomic,strong) ZCGoodsTypeModel *model;

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)shopGoodsTypeCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

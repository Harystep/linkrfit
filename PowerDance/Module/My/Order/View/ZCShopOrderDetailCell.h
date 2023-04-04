//
//  ZCShopOrderDetailCell.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCShopOrderDetailCell : UITableViewCell

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)shopOrderDetailCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

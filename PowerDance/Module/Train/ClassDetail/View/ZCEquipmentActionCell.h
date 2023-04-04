//
//  ZCEquipmentActionCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCEquipmentActionCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)equipmentActionCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

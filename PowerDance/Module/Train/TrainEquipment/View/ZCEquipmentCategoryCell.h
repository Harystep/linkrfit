//
//  ZCEquipmentCategoryCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCEquipmentCategoryCell : UITableViewCell

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)equipmentCategoryCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

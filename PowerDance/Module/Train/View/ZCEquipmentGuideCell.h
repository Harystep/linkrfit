//
//  ZCEquipmentGuideCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCEquipmentGuideCell : UITableViewCell

@property (nonatomic,strong) NSArray *dataArr;

+ (instancetype)equipmentGuideCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

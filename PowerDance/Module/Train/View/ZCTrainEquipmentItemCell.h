//
//  ZCTrainEquipmentItemCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCTrainEquipmentItemCell : UITableViewCell

@property (nonatomic,strong) NSArray *dataArr;

+ (instancetype)trainEquipmentItemCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

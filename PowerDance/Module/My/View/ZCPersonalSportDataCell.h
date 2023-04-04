//
//  ZCPersonalSportDataCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCPersonalSportDataCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)personalSportDataCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

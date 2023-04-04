//
//  ZCClassDetailActionCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/4/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCClassDetailActionCell : UITableViewCell

@property (nonatomic,strong) NSArray *dataArr;

+ (instancetype)classDetailActionCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

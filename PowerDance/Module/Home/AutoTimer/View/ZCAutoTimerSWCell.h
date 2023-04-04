//
//  ZCAutoTimerSWCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCAutoTimerSWCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)autoTimerSWCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

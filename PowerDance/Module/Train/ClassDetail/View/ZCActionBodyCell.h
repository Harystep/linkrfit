//
//  ZCActionBodyCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCActionBodyCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)actionBodyCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

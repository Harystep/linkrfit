//
//  ZCSportAddGroupCell.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCSportAddGroupCell : UITableViewCell

@property (nonatomic, copy) void (^addNewGroupOperate)(NSInteger index);

+ (instancetype)sportAddGroupCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

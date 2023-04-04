//
//  ZCSuitFollowTestCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCSuitFollowTestCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)suitFollowTestCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

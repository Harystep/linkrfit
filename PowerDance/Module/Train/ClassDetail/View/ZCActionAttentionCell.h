//
//  ZCActionAttentionCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCActionAttentionCell : UITableViewCell

@property (nonatomic,strong) NSString *pointsAttention;

+ (instancetype)actionAttentionCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

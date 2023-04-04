//
//  ZCShopCommentCell.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCShopCommentCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)shopCommentCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

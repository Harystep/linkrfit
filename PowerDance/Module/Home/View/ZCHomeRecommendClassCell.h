//
//  ZCHomeRecommendClassCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCHomeRecommendClassCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)homeRecommendClassCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

//
//  ZCSuitTestResultItemCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/8/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCSuitTestResultItemCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)suitTestItemCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

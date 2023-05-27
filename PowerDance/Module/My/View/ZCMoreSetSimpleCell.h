//
//  ZCMoreSetSimpleCell.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCMoreSetSimpleCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,copy) NSString *lastVersion;

+ (instancetype)moreSetSimpleCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

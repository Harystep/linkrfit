//
//  ZCNoticeSimpleCell.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCNoticeSimpleCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)noticeSimpleCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

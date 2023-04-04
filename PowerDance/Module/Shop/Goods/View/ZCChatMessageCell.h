//
//  ZCChatMessageCell.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCChatMessageCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)chatMessageCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

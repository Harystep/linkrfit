//
//  ZCShopManage.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCShopManage : NSObject

/// 查询商品分类
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryShopGoodsCategoryInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 查询商品分类列表
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryShopCategoryListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)queryShopGoodsDetailInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 地址列表
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryShopArriveAddressListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 新建地址
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)saveShopArriveAddressInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 更新地址
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)updateShopArriveAddressInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 获取默认地址
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)getDefaultArriveAddressInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 支付
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)payShopGoodsOperateInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 获取聊天记录
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)getChatRoomListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 获取未读消息
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)getChatRoomUnReadListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 标记消息已读
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)signChatRoomReadedOperate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 上传图片
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)uploadPictureOperate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 评论列表
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryGoodsCommentListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 商品评论
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)goodsCommentOperate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 订单列表
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryGoodsOrderListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 确认订单
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)sureOrdeReceiptOperate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)queryOrderStatusInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

@end

NS_ASSUME_NONNULL_END

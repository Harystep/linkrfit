//
//  ZCShopManage.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/23.
//

#import "ZCShopManage.h"

#define kShopGoodsCategoryInfoURL @"product/category"

#define kShopCategoryListInfoURL @"product/list"

#define kShopGoodsDetailInfoURL @"product/"

#define kShopArriveAddressInfoURL @"user/address/list"

#define kSaveArriveAddressInfoURL @"user/address/save"

#define kGetDefaultArriveAddressURL @"user/address/default"

#define kPayShopGoodsOperateURL @"pay/app/alipay"

#define kGetChatRoomInfoListURL @"chat/record"
#define kGetChatRoomUnReadInfoListURL @"chat/unread"
#define kSignChatRoomReadOperateURL @"chat/read/message"

#define kUploadPictureOperateURL @"user/upload/img"

#define kQueryGoodsCommentListInfoURL @"product/comment/list"

#define kGoodsCommentOperateURL @"product/comment"

#define kQueryMyOrderListInfoURL @"order/list"

#define kFinishMyOrderStatusOperateURL @"order/confirm/receipt"

#define kQueryOrderStatusInfoURL @"order"

#define kEditShopAddressInfoURL @"user/address/update"

@implementation ZCShopManage

+ (void)queryShopGoodsCategoryInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kShopGoodsCategoryInfoURL params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)queryShopCategoryListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [kShopCategoryListInfoURL stringByAppendingFormat:@"?categoryId=%@", checkSafeContent(parms[@"categoryId"])];
    [[ZCNetwork shareInstance] request_getWithApi:url params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)queryShopGoodsDetailInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [NSString stringWithFormat:@"%@%@", kShopGoodsDetailInfoURL, parms[@"id"]];
    [[ZCNetwork shareInstance] request_getWithApi:url params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)queryShopArriveAddressListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kShopArriveAddressInfoURL params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)getDefaultArriveAddressInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kGetDefaultArriveAddressURL params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)saveShopArriveAddressInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kSaveArriveAddressInfoURL params:parms isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)updateShopArriveAddressInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kEditShopAddressInfoURL params:parms isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)payShopGoodsOperateInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kPayShopGoodsOperateURL params:parms isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)getChatRoomListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parms];
    [dic setValue:@"20" forKey:@"size"];
    [[ZCNetwork shareInstance] request_getWithApi:kGetChatRoomInfoListURL params:dic isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)getChatRoomUnReadListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kGetChatRoomUnReadInfoListURL params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)signChatRoomReadOperate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kSignChatRoomReadOperateURL params:parms isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)signChatRoomReadedOperate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kSignChatRoomReadOperateURL params:parms isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)uploadPictureOperate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kUploadPictureOperateURL params:parms isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        completerHandler(data);
    }];
}

+ (void)queryGoodsCommentListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parms];
    [dic setValue:@"10" forKey:@"size"];
    [[ZCNetwork shareInstance] request_getWithApi:kQueryGoodsCommentListInfoURL params:dic isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        completerHandler(data);
    }];
}

+ (void)goodsCommentOperate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kGoodsCommentOperateURL params:parms isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        completerHandler(data);
    }];
}

+ (void)queryGoodsOrderListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kQueryMyOrderListInfoURL params:parms isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        completerHandler(data);
    }];
}

+ (void)sureOrdeReceiptOperate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [NSString stringWithFormat:@"%@?outOrderNo=%@",kFinishMyOrderStatusOperateURL, parms[@"outOrderNo"]];
    [[ZCNetwork shareInstance] request_postWithApi:url params:@{} isNeedSVP:YES success:^(id  _Nullable responseObj) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kOrderFinishKey" object:nil];
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        completerHandler(data);
    }];
}

+ (void)queryOrderStatusInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [kQueryOrderStatusInfoURL stringByAppendingFormat:@"/%@", parms[@"order"]];
    [[ZCNetwork shareInstance] request_getWithApi:url params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        completerHandler(data);
    }];
}

@end

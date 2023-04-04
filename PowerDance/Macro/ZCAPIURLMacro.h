//
//  ZCAPIURLMacro.h
//  PowerDance
//
//  Created by PC-N121 on 2021/10/27.
//

#ifndef ZCAPIURLMacro_h
#define ZCAPIURLMacro_h

#define k_API_HOST_KEY @""
#define k_Api_Host_Relase @"https://www.luckrfit.com/api/"// https://www.targetsiot.com
#define k_Api_Host_Debug @"http://192.168.1.140:9009/"//179  241   140

#define k_User_Agreement_URL [ZCDevice currentDevice].isUsingChinese?@"https://www.luckrfit.com/pg-user-agreement.html":@"https://www.luckrfit.com/pg-user-agreement-en.html"
#define k_User_PRIVACY_URL [ZCDevice currentDevice].isUsingChinese?@"https://www.luckrfit.com/pg-privacy-agreement.html":@"https://www.luckrfit.com/pg-privacy-agreement-en.html"

#define kAlipayResultNotification @"kAlipayResultNotification"

#define kAuthWechatHost   @"https://api.weixin.qq.com/sns/oauth2/access_token?"
#define kWECHAT_APP_ID @"wxbdf7f979c4b2abc8"
#define kWECHAT_APP_SECRET @"3e5a968ca46bc87eb3bdb14b257646f5"
//登录
#define kLoginSendCodeURL @"user/send/sms"
#define kLoginOperateURL @"user/login"

#define kUserInfoURL @"user/info"


#endif /* ZCAPIURLMacro_h */

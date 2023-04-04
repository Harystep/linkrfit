//
//  WebSocketManager.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/29.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,WebSocketConnectType){
    WebSocketDefault = 0, //初始状态,未连接
    WebSocketConnect,      //已连接
    WebSocketDisconnect    //连接后断开
};

@class WebSocketManager;
@protocol WebSocketManagerDelegate <NSObject>

- (void)webSocketManagerDidReceiveMessageWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WebSocketManager : NSObject

@property (nonatomic, strong) SRWebSocket *webSocket;
@property(nonatomic,weak)  id<WebSocketManagerDelegate > delegate;
@property (nonatomic, assign)   BOOL isConnect;  //是否连接
@property (nonatomic, assign)   WebSocketConnectType connectType;

+ (instancetype)shared;
- (void)connectServer;//建立长连接
- (void)reConnectServer;//重新连接
- (void)RMWebSocketClose;//关闭长连接
- (void)sendDataToServer:(NSString *)data;//发送数据给服务器

@end

NS_ASSUME_NONNULL_END


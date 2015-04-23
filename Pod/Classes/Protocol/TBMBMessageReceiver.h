/*
 * (C) 2007-2013 Alibaba Group Holding Limited
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 *
 */
// 接受消息
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-9 下午6:21.
//

#import "TBMBNotification.h"

#define TBMB_DEFAULT_RECEIVE_HANDLER_NAME  (@"$$")

@protocol TBMBMessageReceiver <NSObject>
//默认的key 用于回调判断用
- (const NSUInteger)notificationKey;

//处理通知的函数
- (void)handlerNotification:(id <TBMBNotification>)notification;

//列出需要监听的通知名
- (NSSet */*NSString*/)listReceiveNotifications;

//列出所有的Observer 需要释放
- (NSSet *)_$listObserver;

//加入被加到NotificationCenter的Observer
- (void)_$addObserver:(id)observer;

//移除被加到NotificationCenter的Observer
- (void)_$removeObserver:(id)observer;
@end
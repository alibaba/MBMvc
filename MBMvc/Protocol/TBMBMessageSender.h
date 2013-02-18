/*
 * (C) 2007-2013 Alibaba Group Holding Limited
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 *
 */
//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午3:29.
//


#import "TBMBNotification.h"

@protocol TBMBMessageSender
//发送通知
- (void)sendNotification:(NSString *)notificationName;

//发送通知
- (void)sendNotification:(NSString *)notificationName body:(id)body;

//发送通知
- (void)sendTBMBNotification:(id <TBMBNotification>)notification;

//发送通知
- (void)sendNotificationForSEL:(SEL)selector;

//发送通知
- (void)sendNotificationForSEL:(SEL)selector body:(id)body;

@end
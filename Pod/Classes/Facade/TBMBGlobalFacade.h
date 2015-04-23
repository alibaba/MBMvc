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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-13 下午1:18.
//


#import <Foundation/Foundation.h>
#import "TBMBFacade.h"

@interface TBMBGlobalFacade : NSObject <TBMBFacade>
+ (BOOL)setDefaultFacade:(Class)facadeClass;

+ (TBMBGlobalFacade *)instance;
@end

//封装好的 发送Notification接口
extern void TBMBGlobalSendNotification(NSString *notificationName);

//封装好的 发送Notification接口
extern void TBMBGlobalSendNotificationWithBody(NSString *notificationName, id body);

//封装好的 发送Notification接口
extern void TBMBGlobalSendNotificationForSEL(SEL selector);

//封装好的 发送Notification接口
extern void TBMBGlobalSendNotificationForSELWithBody(SEL selector, id body);

//封装好的 发送Notification接口
extern void TBMBGlobalSendTBMBNotification(id <TBMBNotification> notification);
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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午4:25.
//


#import <Foundation/Foundation.h>
#import "TBMBFacade.h"

#define TBMB_NOTIFICATION_KEY @"TBMB_NOTIFICATION_KEY"

@interface TBMBDefaultFacade : NSObject <TBMBFacade>
//设置分发消息的执行队列
+ (void)setDispatchQueue:(NSOperationQueue *)queue;

//设置Command的执行队列
+ (void)setCommandQueue:(dispatch_queue_t)queue;

//设置自定义的 NotificationCenter
+ (void)setNotificationCenter:(NSNotificationCenter *)notificationCenter;

+ (TBMBDefaultFacade *)instance;

@end
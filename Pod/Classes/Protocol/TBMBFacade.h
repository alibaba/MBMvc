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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午4:24.
//


#import "TBMBMessageReceiver.h"
#import "TBMBMessageSender.h"
#import "TBMBCommand.h"

@protocol TBMBFacade <TBMBMessageSender>
//Facade 是单例
+ (id <TBMBFacade>)instance;

- (void)setInterceptors:(NSArray *)interceptors;

//订阅receiver
- (void)subscribeNotification:(id <TBMBMessageReceiver>)receiver;

//注销订阅
- (void)unsubscribeNotification:(id <TBMBMessageReceiver>)receiver;

//订阅Command
- (void)registerCommand:(Class)commandClass;

//自动订阅Command 会扫描所有的Class 并将 TBMBCommand 进行订阅
- (void)registerCommandAuto;

//异步自动订阅Command 会扫描所有的Class 并将 TBMBCommand 进行订阅
- (void)registerCommandAutoAsync;

@end
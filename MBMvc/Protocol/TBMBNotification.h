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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午3:19.
//


@protocol TBMBNotification
//消息内容
- (id)body;

- (NSTimeInterval)delay;

- (void)setDelay:(NSTimeInterval)delay;

//消息名
- (NSString *)name;

//消息的key 一般是 receiver的key在createNextNotification的时候会把key带过去用来判断发送源
- (NSUInteger)key;

//设置key
- (void)setKey:(NSUInteger)key;

//设置消息内容
- (void)setBody:(id)body;

//用户自定义的信息,在createNextNotification的时候会带过去
- (NSDictionary *)userInfo;

//设置用户信息
- (void)setUserInfo:(NSDictionary *)value;

//被重放的次数
- (NSUInteger)retryCount;

//设置被重放的次数
- (void)setRetryCount:(NSUInteger)value;

//当createNextNotification时,源消息被放到这个lastNotification中,以便形成调用链
- (id <TBMBNotification>)lastNotification;

//设置 lastNotification
- (void)setLastNotification:(id <TBMBNotification>)notification;

//以当前消息 创建 下一个消息
- (id <TBMBNotification>)createNextNotification:(NSString *)name;

//以当前消息 创建 下一个消息
- (id <TBMBNotification>)createNextNotification:(NSString *)name withBody:(id)body;

//以当前消息 创建 下一个消息
- (id <TBMBNotification>)createNextNotificationForSEL:(SEL)selector;

//以当前消息 创建 下一个消息
- (id <TBMBNotification>)createNextNotificationForSEL:(SEL)selector withBody:(id)body;

@end
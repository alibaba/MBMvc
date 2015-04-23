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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-2 下午10:46.
//


@protocol TBMBNotification;

@protocol TBMBCommandInvocation <NSObject>

- (Class)commandClass;

- (void)setCommandClass:(Class)commandClass;

- (id <TBMBNotification>)notification;

- (void)setNotification:(id <TBMBNotification>)notification;

//真正执行一个Command
- (id)invoke;

@end
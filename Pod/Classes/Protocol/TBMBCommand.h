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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-13 下午5:38.
//
//Command 用来接受消息并执行
@protocol TBMBCommand
//列出所有能处理的消息名,会以次消息名进行订阅
+ (NSSet */*NSString*/)listReceiveNotifications;

@end
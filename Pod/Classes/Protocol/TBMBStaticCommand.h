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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-13 下午3:38.
//


#import "TBMBNotification.h"
#import "TBMBCommand.h"

@protocol TBMBStaticCommand <TBMBCommand>
//静态类型的Command
+ (id)execute:(id <TBMBNotification>)notification;

@end
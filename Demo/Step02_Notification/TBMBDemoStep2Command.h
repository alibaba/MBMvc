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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 上午11:54.
//


#import <Foundation/Foundation.h>
#import "TBMBSimpleStaticCommand.h"

//这里用来处理业务逻辑哦
@interface TBMBDemoStep2Command : TBMBSimpleStaticCommand

//以$$开头的方法 会被自动注册为Notification,然后用  TBMBGlobalSendXXX 的方法发通知,这里就能被执行
//如果有相同的方法名的话,是都会被执行到的
+ (void)$$getDate:(id <TBMBNotification>)notification;
@end
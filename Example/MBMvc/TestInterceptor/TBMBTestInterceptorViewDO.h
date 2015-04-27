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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-17 上午9:36.
//


#import <Foundation/Foundation.h>
#import "TBMBDemoStep5Command.h"


@interface TBMBTestInterceptorViewDO : NSObject <TBMBDemoStep5CommandGetDateProtocol>
//记录需要被Alert的文字
@property(nonatomic, copy) NSString *alertText;
//用来触发showTime的操作
@property(nonatomic) BOOL showTime;
//记录log
@property(nonatomic, copy) NSString *log;
@end
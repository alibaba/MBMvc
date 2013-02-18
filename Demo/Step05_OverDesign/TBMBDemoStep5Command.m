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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 下午1:00.
//


#import "TBMBDemoStep5Command.h"


@implementation TBMBDemoStep5Command {

}
- (NSNumber *)getDate:(id <TBMBDemoStep5CommandGetDateProtocol>)obj {
    [obj setDate:[NSDate date]];
    return [NSNumber numberWithBool:YES]; //这行用来测试拦截器的
}


@end
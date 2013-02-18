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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 下午12:23.
//


#import "TBMBDemoStep3Command.h"


@implementation TBMBDemoStep3Command {

}
- (void)getData:(void (^)(NSDate *))result {
    if (result) {
        result([NSDate date]);
    }
}


@end
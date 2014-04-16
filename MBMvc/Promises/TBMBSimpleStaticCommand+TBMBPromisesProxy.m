/*
 * (C) 2007-2013 Alibaba Group Holding Limited
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 *
 *///
// Created by 文通 on 14-4-16 上午9:45.
//


#import "TBMBSimpleStaticCommand+TBMBPromisesProxy.h"
#import "TBMBPromisesProxy.h"


@implementation TBMBSimpleStaticCommand (TBMBPromisesProxy)
+ (id)deferredProxyObject {
    return [[TBMBPromisesProxy alloc]
                               initWithClass:self
                                      andKey:0];
}

@end
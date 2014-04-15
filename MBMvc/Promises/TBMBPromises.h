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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-2 下午11:12.
//

#import "OMPromise.h"
#import "OMDeferred.h"

typedef OMPromise TBMBPromise;
typedef OMDeferred TBMBDeferred;

extern TBMBDeferred *getTBMBDeferredFromThread();

extern void setTBMBDeferredToThread(TBMBDeferred *deferred);

extern void removeTBMBDeferredToThread();
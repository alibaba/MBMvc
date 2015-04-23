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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-3 下午5:48.
//


#import <pthread.h>
#import "TBMBSimpleSingletonCommand.h"

static NSMutableDictionary *_commandInstanceMap = nil;
static dispatch_once_t _oncePredicate_CommandInstanceMap;

static pthread_rwlock_t _lock;

@implementation TBMBSimpleSingletonCommand
+ (TBMBSimpleSingletonCommand *)instance {
    NSString *className = NSStringFromClass(self);
    dispatch_once(&_oncePredicate_CommandInstanceMap, ^{
        pthread_rwlock_init(&_lock, NULL);
        if (_commandInstanceMap == nil) {
            _commandInstanceMap = [[NSMutableDictionary alloc] init];
        }
    }
    );
    TBMBSimpleSingletonCommand *_instance = nil;
    pthread_rwlock_rdlock(&_lock);
    _instance = [_commandInstanceMap objectForKey:className];
    pthread_rwlock_unlock(&_lock);
    if (_instance) {
        return _instance;
    } else {
        pthread_rwlock_wrlock(&_lock);
        _instance = [_commandInstanceMap objectForKey:className];
        if (!_instance) {
            _instance = [[self alloc] init];
            [_commandInstanceMap setObject:_instance forKey:className];
        }
        pthread_rwlock_unlock(&_lock);
        return _instance;
    }
}
@end
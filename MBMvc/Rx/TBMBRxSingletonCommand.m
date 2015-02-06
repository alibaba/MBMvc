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
// Created by Wentong on 15/2/4.
//

#import <pthread.h>
#import "TBMBRxSingletonCommand.h"

static NSMutableDictionary *_commandInstanceMap = nil;
static dispatch_once_t _oncePredicate_CommandInstanceMap;

static pthread_rwlock_t _lock;

@implementation TBMBRxSingletonCommand {

}

+ (instancetype)command {
    NSString *className = NSStringFromClass(self);
    dispatch_once(&_oncePredicate_CommandInstanceMap, ^{
        pthread_rwlock_init(&_lock, NULL);
        if (_commandInstanceMap == nil) {
            _commandInstanceMap = [[NSMutableDictionary alloc] init];
        }
    }
    );
    TBMBRxSingletonCommand *_instance = nil;
    pthread_rwlock_rdlock(&_lock);
    _instance = _commandInstanceMap[className];
    pthread_rwlock_unlock(&_lock);
    if (_instance) {
        return _instance;
    } else {
        pthread_rwlock_wrlock(&_lock);
        _instance = _commandInstanceMap[className];
        if (!_instance) {
            _instance = [[self alloc] init];
            _commandInstanceMap[className] = _instance;
        }
        pthread_rwlock_unlock(&_lock);
        return _instance;
    }
}
@end
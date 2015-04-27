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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-2 下午10:52.
//


#import <objc/message.h>
#import "TBMBDefaultCommandInvocation.h"
#import "TBMBCommandInterceptor.h"
#import "TBMBUtil.h"
#import "TBMBStaticCommand.h"
#import "TBMBSingletonCommand.h"


@implementation TBMBDefaultCommandInvocation {

@private
    Class _commandClass;
    id <TBMBNotification> _notification;

    NSEnumerator *_interceptors;
}
@synthesize commandClass = _commandClass;
@synthesize notification = _notification;

- (id)initWithCommandClass:(Class)commandClass
              notification:(id <TBMBNotification>)notification
              interceptors:(NSArray *)interceptors {
    self = [super init];
    if (self) {
        _commandClass = commandClass;
        _notification = notification;
        if (interceptors) {
            _interceptors = [interceptors objectEnumerator];
        } else {
            _interceptors = nil;
        }
    }
    return self;
}

+ (id)objectWithCommandClass:(Class)commandClass
                notification:(id <TBMBNotification>)notification
                interceptors:(NSArray *)interceptors {
    return [[TBMBDefaultCommandInvocation alloc]
                                          initWithCommandClass:commandClass
                                                  notification:notification
                                                  interceptors:interceptors];
}


static inline id executeCommand(Class commandClass, id <TBMBNotification> notification) {
    id ret = nil;
    if (commandClass == nil || notification == nil) {
        return nil;
    }
    id (*objc_msgSendTypeAll)(id, SEL, id <TBMBNotification>) = (id (*)(id, SEL, id <TBMBNotification>)) objc_msgSend;
    if (TBMBClassHasProtocol(commandClass, @protocol(TBMBStaticCommand))) {
        ret = objc_msgSendTypeAll(commandClass, @selector(execute:), notification);
    } else if (TBMBClassHasProtocol(commandClass, @protocol(TBMBSingletonCommand))) {
        id <TBMBSingletonCommand> commandSingleton =
                ((id <TBMBSingletonCommand> (*)(id, SEL)) objc_msgSend)(commandClass, @selector(instance));
        if (commandSingleton) {
            ret = objc_msgSendTypeAll(commandSingleton, @selector(execute:), notification);
        }
    } else if (TBMBClassHasProtocol(commandClass, @protocol(TBMBInstanceCommand))) {
        ret = objc_msgSendTypeAll([[commandClass alloc] init], @selector(execute:), notification);
    } else {
        NSCAssert(NO, @"Unknown commandClass[%@] to invoke", commandClass);
    }
    return ret;
}


- (id)invoke {
    id <TBMBCommandInterceptor> interceptor = nil;
    if (_interceptors && (interceptor = [_interceptors nextObject])) {
        return [interceptor intercept:self];
    } else {
        return executeCommand(_commandClass, _notification);
    }
}

- (void)dealloc {
    TBMB_LOG(@"dealloc [%@]", self);
}


@end
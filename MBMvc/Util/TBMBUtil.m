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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午10:17.
//

#import <objc/runtime.h>
#import <objc/message.h>
#import "TBMBUtil.h"
#import "TBMBCommand.h"
#import "TBMBStaticCommand.h"
#import "TBMBMessageReceiver.h"
#import "TBMBOnlyProxy.h"
#import "TBMBBind.h"

inline BOOL TBMBClassHasProtocol(Class clazz, Protocol *protocol) {
    Class currentClass = clazz;
    while (!class_conformsToProtocol(currentClass, protocol)) {
        currentClass = class_getSuperclass(currentClass);
        if (currentClass == nil || currentClass == [NSObject class]) {
            return NO;
        }
    }
    return YES;
}

inline NSString *TBMBProxyHandlerName(NSUInteger key, Class clazz) {
    return [NSString stringWithFormat:(@"%@_%ld_%@"),
                     TBMB_PROXY_PREFIX,
                                      (unsigned long) key,
                                      clazz];
}

static inline NSSet *TBMBGetAllHandlerNameWithClass(Class clazz, BOOL isClassMethod, NSString *prefix) {
    NSMutableSet *names = [[NSMutableSet alloc] initWithCapacity:2];
    unsigned int methodCount;
    Method *methods = isClassMethod ?
            class_copyMethodList(object_getClass(clazz), &methodCount) :
            class_copyMethodList(clazz, &methodCount);
    if (methods && methodCount > 0) {
        for (unsigned int i = 0; i < methodCount; i++) {
            SEL selector = method_getName(methods[i]);
            NSString *selectorName = NSStringFromSelector(selector);
            if ([selectorName hasPrefix:prefix]) {
                [names addObject:selectorName];
            }
        }
    }
    if (methods) {
        free(methods);
    }
    return names;
}

inline NSMutableSet *TBMBGetAllReceiverHandlerName(Class currentClass, Class rootClass, NSString *prefix) {
    NSMutableSet *names = [[NSMutableSet alloc] initWithCapacity:3];
    rootClass = rootClass ?: [NSObject class];
    Class clazz = currentClass;
    while (clazz != nil && clazz != rootClass) {
        NSSet *nameWithClass = TBMBGetAllHandlerNameWithClass(clazz, NO, prefix);
        [names unionSet:nameWithClass];
        clazz = class_getSuperclass(clazz);
    }
    return names;
}


inline NSSet *TBMBInternalListAllReceiverHandlerName(id handler, id <TBMBMessageReceiver> receiver, Class rootClass) {
    if (TBMBClassHasProtocol([handler class], @protocol(TBMBOnlyProxy))) {
        return [NSSet setWithObject:TBMBProxyHandlerName(receiver.notificationKey, [handler class])];
    }
    NSMutableSet *handlerNames = TBMBGetAllReceiverHandlerName([handler class], rootClass,
            TBMB_DEFAULT_RECEIVE_HANDLER_NAME
    );
    [handlerNames addObject:TBMBProxyHandlerName(receiver.notificationKey, [handler class])];
    return handlerNames;
}


inline NSSet *TBMBListAllReceiverHandlerName(id <TBMBMessageReceiver> handler, Class rootClass) {
    return TBMBInternalListAllReceiverHandlerName(handler, handler, rootClass);
}

inline NSMutableSet *TBMBGetAllCommandHandlerName(Class commandClass, NSString *prefix) {
    NSMutableSet *names = [[NSMutableSet alloc] initWithCapacity:3];
    Class clazz = commandClass;
    while (clazz != nil && clazz != [NSObject class]) {
        NSSet *nameWithClass = TBMBGetAllHandlerNameWithClass(clazz, TBMBClassHasProtocol(commandClass, @protocol(TBMBStaticCommand)), prefix);
        [names unionSet:nameWithClass];
        clazz = class_getSuperclass(clazz);
    }
    return names;
}

inline id TBMBAutoHandlerNotification(id handler, id <TBMBNotification> notification) {
    SEL notifyHandler = NSSelectorFromString(notification.name);
    id ret = nil;
    if ([handler respondsToSelector:notifyHandler]) {
        BOOL hasIdReturn = NO;
        Class clazz = object_getClass(handler);
        Method method;
        if (class_isMetaClass(clazz)) {
            //handler本身是类
            method = class_getClassMethod(handler, notifyHandler);
        } else {
            //handler是一个实例
            method = class_getInstanceMethod(clazz, notifyHandler);
        }
        if (method) {
            char *type = method_copyReturnType(method);
            if (type) {
                if (type[0] == @encode(id)[0]) {
                    hasIdReturn = YES;
                }
                free(type);
            }
        }
        if (hasIdReturn) {
            ret = ((id (*)(id, SEL, id <TBMBNotification>, id, NSDictionary *)) objc_msgSend)
                    (handler, notifyHandler, notification, notification.body, notification.userInfo
                    );
        } else {
            ((void (*)(id, SEL, id <TBMBNotification>, id, NSDictionary *)) objc_msgSend)
                    (handler, notifyHandler, notification, notification.body, notification.userInfo
                    );
        }
    }
    return ret;
}

inline void TBMBInternalAutoHandlerReceiverNotification(id handler, id <TBMBMessageReceiver> receiver,
        id <TBMBNotification> notification) {
    if ([notification.name isEqualToString:TBMBProxyHandlerName(receiver.notificationKey, [handler class])]) {   //代理方法直接执行
        NSInvocation *invocation = notification.body;
        [invocation invokeWithTarget:handler];
        return;
    }
    TBMBAutoHandlerNotification(handler, notification);
}

inline void TBMBAutoHandlerReceiverNotification(id <TBMBMessageReceiver> handler, id <TBMBNotification> notification) {
    TBMBInternalAutoHandlerReceiverNotification(handler, handler, notification);
}

inline const NSUInteger TBMBGetDefaultNotificationKey(id o) {
    const void *ptr = (__bridge const void *) o;
    return (const NSUInteger) ptr;
}


inline BOOL TBMBIsNotificationProxy(id <TBMBNotification> notification) {
    return notification && [notification.name hasPrefix:TBMB_PROXY_PREFIX] && [notification.body
            isKindOfClass:[NSInvocation class]];
}

inline void TBMBAutoBindingKeyPath(id bindable) {
    NSMutableSet *names = [[NSMutableSet alloc] initWithCapacity:3];
    Class rootClass = [NSObject class];
    Class clazz = [bindable class];
    while (clazz != nil && clazz != rootClass) {
        unsigned int methodCount;
        Method *methods = class_copyMethodList(clazz, &methodCount);
        if (methods && methodCount > 0) {
            for (unsigned int i = 0; i < methodCount; i++) {
                SEL selector = method_getName(methods[i]);
                NSString *selectorName = NSStringFromSelector(selector);
                if ([selectorName hasPrefix:TBMB_KEY_PATH_CHANGE_PREFIX]) {
                    [names addObject:selectorName];      //为了去重
                }
            }
        }
        if (methods) {
            free(methods);
        }
        clazz = class_getSuperclass(clazz);
    }

    if (names.count > 0) {
        for (NSString *name in names) {
            SEL selector = NSSelectorFromString(name);
            NSString *keyPath = [name substringFromIndex:[TBMB_KEY_PATH_CHANGE_PREFIX length]];
            keyPath = [keyPath componentsSeparatedByString:@":"][0];
            keyPath = [[keyPath componentsSeparatedByString:__TBMBAutoKeyPathChangeMethodNameSEP_STR]
                                componentsJoinedByString:@"."];
            __block __unsafe_unretained id _bindable = bindable;
            TBMBBindObject(bindable, keyPath, ^(id old, id new) {
                void (*objc_msgSendTypeAll)(id, SEL, BOOL, id, id) = (void (*)(id, SEL, BOOL, id, id)) objc_msgSend;
                objc_msgSendTypeAll(_bindable, selector, [TBMBBindInitValue value] == old, old, new);
            }
            );
        }
    }
}
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
    return [NSString stringWithFormat:(@"__$$__ProxyHandler_%d_%@"), key, clazz];
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
    rootClass = rootClass ? : [NSObject class];
    Class clazz = currentClass;
    while (clazz != nil && clazz != rootClass) {
        NSSet *nameWithClass = TBMBGetAllHandlerNameWithClass(clazz, NO, prefix);
        [names unionSet:nameWithClass];
        clazz = class_getSuperclass(clazz);
    }
    return names;
}

inline NSSet *TBMBListAllReceiverHandlerName(id <TBMBMessageReceiver> handler, Class rootClass) {
    if (TBMBClassHasProtocol([handler class], @protocol(TBMBOnlyProxy))) {
        return [NSSet setWithObject:TBMBProxyHandlerName(handler.notificationKey, [handler class])];
    }
    NSMutableSet *handlerNames = TBMBGetAllReceiverHandlerName([handler class], rootClass,
            TBMB_DEFAULT_RECEIVE_HANDLER_NAME
    );
    [handlerNames addObject:TBMBProxyHandlerName(handler.notificationKey, [handler class])];
    return handlerNames;
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

inline void TBMBAutoHandlerNotification(id handler, id <TBMBNotification> notification) {
    SEL notifyHandler = NSSelectorFromString(notification.name);
    if ([handler respondsToSelector:notifyHandler]) {
        objc_msgSend(handler, notifyHandler, notification, notification.body, notification.userInfo);
    }
}

inline void TBMBAutoHandlerReceiverNotification(id <TBMBMessageReceiver> handler, id <TBMBNotification> notification) {
    if ([notification.name isEqualToString:TBMBProxyHandlerName(handler.notificationKey, [handler class])]) {   //代理方法直接执行
        NSInvocation *invocation = notification.body;
        [invocation invokeWithTarget:handler];
        return;
    }
    TBMBAutoHandlerNotification(handler, notification);
}

inline const NSUInteger getDefaultNotificationKey(id o) {
    const void *ptr = (__bridge const void *) o;
    return (const NSUInteger) ptr;
}
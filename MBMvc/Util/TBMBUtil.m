//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午10:17.
//

#import <objc/runtime.h>
#import <objc/message.h>
#import "TBMBUtil.h"
#import "TBMBCommand.h"
#import "TBMBStaticCommand.h"

BOOL TBMBClassHasProtocol(Class clazz, Protocol *protocol) {
    Class currentClass = clazz;
    while (!class_conformsToProtocol(currentClass, protocol)) {
        currentClass = class_getSuperclass(currentClass);
        if (currentClass == nil || currentClass == [NSObject class]) {
            return NO;
        }
    }
    return YES;
}

static NSSet *TBMBGetAllHandlerNameWithClass(Class clazz, BOOL isClassMethod, NSString *prefix) {
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

NSSet *TBMBGetAllUIViewControllerHandlerName(UIViewController *controller, NSString *prefix) {
    NSMutableSet *names = [[NSMutableSet alloc] initWithCapacity:3];
    Class clazz = [controller class];
    while (clazz != nil && clazz != [UIViewController class]) {
        NSSet *nameWithClass = TBMBGetAllHandlerNameWithClass(clazz, NO, prefix);
        [names unionSet:nameWithClass];
        clazz = class_getSuperclass(clazz);
    }
    return names;
}


NSSet *TBMBGetAllCommandHandlerName(Class commandClass, NSString *prefix) {
    NSMutableSet *names = [[NSMutableSet alloc] initWithCapacity:3];
    Class clazz = commandClass;
    while (clazz != nil && clazz != [NSObject class]) {
        NSSet *nameWithClass = TBMBGetAllHandlerNameWithClass(clazz, TBMBClassHasProtocol(commandClass, @protocol(TBMBStaticCommand)), prefix);
        [names unionSet:nameWithClass];
        clazz = class_getSuperclass(clazz);
    }
    return names;
}
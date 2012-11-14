//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午10:17.
//

#import <objc/runtime.h>
#import "TBMBProtocalUtil.h"

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
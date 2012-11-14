//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-13 下午5:45.
//


#import <objc/runtime.h>
#import <objc/message.h>
#import "TBMBDefaultObserver.h"
#import "TBMBFacade.h"
#import "TBMBStaticCommand.h"
#import "TBMBInstanceCommand.h"


@implementation TBMBDefaultObserver {
@private
    Class _commandClass;
}
- (id)initWithCommandClass:(Class)commandClass {
    self = [super init];
    if (self) {
        _commandClass = commandClass;
    }

    return self;
}

+ (id)objectWithCommandClass:(Class)commandClass {
    return [[TBMBDefaultObserver alloc] initWithCommandClass:commandClass];
}


- (void)handlerNotification:(id <TBMBNotification>)notification {
    if (class_conformsToProtocol(_commandClass, @protocol(TBMBStaticCommand))) {
        objc_msgSend(_commandClass, @selector(execute:), notification);
    } else if (class_conformsToProtocol(_commandClass, @protocol(TBMBInstanceCommand))) {
        objc_msgSend([[_commandClass alloc] init], @selector(execute:), notification);
    } else {
        NSAssert(NO, @"Unknown commandClass[%@] to invoke", _commandClass);
    }
}

- (NSArray *)listReceiveNotifications {
    return objc_msgSend(_commandClass, @selector(listReceiveNotifications));
}

@end
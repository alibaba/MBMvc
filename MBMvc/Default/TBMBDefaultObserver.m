//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-13 下午5:45.
//


#import <objc/message.h>
#import "TBMBDefaultObserver.h"
#import "TBMBFacade.h"
#import "TBMBStaticCommand.h"
#import "TBMBInstanceCommand.h"
#import "TBMBUtil.h"
#import "TBMBDefaultFacade.h"


@implementation TBMBDefaultObserver {
@private
    NSMutableDictionary *_nameMap;
}
+ (TBMBDefaultObserver *)instance {
    static TBMBDefaultObserver *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _nameMap = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return self;
}


- (void)registerCommand:(Class)commandClass {
    NSSet *names = objc_msgSend(commandClass, @selector(listReceiveNotifications));
    for (NSString *name in names) {
        NSMutableSet *commands;
        if (!(commands = [_nameMap objectForKey:name])) {
            commands = [[NSMutableSet alloc] initWithCapacity:1];
            [_nameMap setObject:commands forKey:name];
        }
        [commands addObject:commandClass];
    }
}

- (void)handlerSysNotification:(NSNotification *)notification {
    NSSet *commands;
    if ((commands = [_nameMap objectForKey:notification.name])) {
        for (Class commandClass in commands) {
            [self handlerDefaultNotification:[notification.userInfo objectForKey:TBMB_NOTIFICATION_KEY]
                                        with:commandClass];
        }
    }
}

- (void)handlerDefaultNotification:(id <TBMBNotification>)notification with:(Class)commandClass {
    if (TBMBClassHasProtocol(commandClass, @protocol(TBMBStaticCommand))) {
        objc_msgSend(commandClass, @selector(execute:), notification);
    } else if (TBMBClassHasProtocol(commandClass, @protocol(TBMBInstanceCommand))) {
        objc_msgSend([[commandClass alloc] init], @selector(execute:), notification);
    } else {
        NSAssert(NO, @"Unknown commandClass[%@] to invoke", commandClass);
    }
}

@end
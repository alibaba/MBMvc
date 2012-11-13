//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午4:25.
//


#import "TBMBDefaultFacade.h"
#import "TBMBDefaultNotification.h"


@implementation TBMBDefaultFacade {
@private
    NSNotificationCenter *_notificationCenter;
}
+ (TBMBDefaultFacade *)instance {
    static TBMBDefaultFacade *_instance = nil;

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
        _notificationCenter = [[NSNotificationCenter alloc] init];
    }
    return self;
}


- (void)subscribeNotification:(id <TBMBMessageReceiver>)receiver {
    if (!receiver) {
        return;
    }
    NSArray *notificationNames = receiver.listReceiveNotifications;
    if (notificationNames && notificationNames.count > 0) {
        for (NSString *name in notificationNames) {
            [_notificationCenter addObserver:receiver
                                    selector:@selector(handlerNotification:)
                                        name:name
                                      object:nil];
        }
    }
}

- (void)unsubscribeNotification:(id <TBMBMessageReceiver>)receiver {
    if (!receiver) {
        return;
    }
    [_notificationCenter removeObserver:receiver];
}


- (void)sendNotification:(NSString *)notificationName {
    [self sendTBMBNotification:[TBMBDefaultNotification objectWithName:notificationName]];
}

- (void)sendNotification:(NSString *)notificationName body:(id)body {
    [self sendTBMBNotification:[TBMBDefaultNotification objectWithName:notificationName body:body]];
}

- (void)sendTBMBNotification:(id <TBMBNotification>)notification {
    NSNotification *sysNotification = [NSNotification notificationWithName:notification.name
                                                                    object:nil
                                                                  userInfo:[NSDictionary dictionaryWithObject:notification
                                                                                                       forKey:TBMB_NOTIFICATION_KEY]];
    [_notificationCenter postNotification:sysNotification];
}


@end
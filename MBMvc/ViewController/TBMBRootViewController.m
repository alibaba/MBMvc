//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午3:57.
//


#import <objc/message.h>
#import "TBMBRootViewController.h"
#import "TBMBGlobalFacade.h"
#import "TBMBDefaultNotification.h"


@implementation TBMBRootViewController {
@private
    id <TBMBFacade> _tbmbFacade;
}

- (const NSUInteger)notificationKey {
    const void *selfPtr = (__bridge const void *) self;
    return (const NSUInteger) selfPtr;
}

- (id <TBMBFacade>)tbmbFacade {
    return _tbmbFacade ? : [TBMBGlobalFacade instance];
}


- (void)setTbmbFacade:(id <TBMBFacade>)tbmbFacade {
    if (self.tbmbFacade != tbmbFacade) {
        [self.tbmbFacade unsubscribeNotification:self];
        _tbmbFacade = tbmbFacade;
        [self.tbmbFacade subscribeNotification:self];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tbmbFacade subscribeNotification:self];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self.tbmbFacade subscribeNotification:self];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.tbmbFacade subscribeNotification:self];
    }
    return self;
}

- (id)initWithTBMBFacade:(id <TBMBFacade>)tbmbFacade {
    self = [super init];
    if (self) {
        _tbmbFacade = tbmbFacade ? : [TBMBGlobalFacade instance];
        [self.tbmbFacade subscribeNotification:self];
    }
    return self;
}

+ (id)objectWithTBMBFacade:(id <TBMBFacade>)tbmbFacade {
    return [[TBMBRootViewController alloc] initWithTBMBFacade:tbmbFacade];
}


- (void)dealloc {
    [self.tbmbFacade unsubscribeNotification:self];
}

#pragma mark  - receiver ,need Overwrite
//默认自动匹配方法
- (void)handlerNotification:(id <TBMBNotification>)notification {
    SEL notifyHandler = NSSelectorFromString([NSString stringWithFormat:@"%@Handler:isSendByMe:",
                                                                        [notification name]]
    );
    if ([self respondsToSelector:notifyHandler]) {
        objc_msgSend(self, notifyHandler, notification, notification.key == self.notificationKey);
    }
}

- (NSArray *)listReceiveNotifications {
    return nil;
}

#pragma mark  - sender
- (void)sendNotification:(NSString *)notificationName {
    [self.tbmbFacade sendTBMBNotification:[TBMBDefaultNotification objectWithName:notificationName
                                                                              key:self.notificationKey]];
}

- (void)sendNotification:(NSString *)notificationName body:(id)body {
    [self.tbmbFacade sendTBMBNotification:[TBMBDefaultNotification objectWithName:notificationName
                                                                              key:self.notificationKey
                                                                             body:body]];
}

- (void)sendTBMBNotification:(id <TBMBNotification>)notification {
    notification.key = self.notificationKey;
    [self.tbmbFacade sendTBMBNotification:notification];
}


@end
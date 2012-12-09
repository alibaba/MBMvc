//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午9:20.
//


#import "TBMBSimpleInstanceCommand.h"
#import "TBMBUtil.h"
#import "TBMBMessageReceiver.h"
#import "TBMBOnlyProxy.h"


@implementation TBMBSimpleInstanceCommand {

}
- (void)execute:(id <TBMBNotification>)notification {
    if ([notification.name isEqualToString:TBMBProxyHandlerName(0, [self class])]) {   //代理方法直接执行
        NSInvocation *invocation = notification.body;
        [invocation invokeWithTarget:self];
        return;
    }
    TBMBAutoHandlerNotification(self, notification);
}

+ (NSSet *)listReceiveNotifications {
    if (TBMBClassHasProtocol(self, @protocol(TBMBOnlyProxy))) {
        return [NSSet setWithObject:TBMBProxyHandlerName(0, self)];
    }
    NSMutableSet *handlerNames = TBMBGetAllCommandHandlerName(self, TBMB_DEFAULT_RECEIVE_HANDLER_NAME);
    [handlerNames addObject:TBMBProxyHandlerName(0, self)];
    return handlerNames;
}

@end
//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午9:07.
//


#import "TBMBSimpleStaticCommand.h"
#import "TBMBUtil.h"
#import "TBMBMessageReceiver.h"
#import "TBMBMessageProxy.h"


@implementation TBMBSimpleStaticCommand {

}
+ (void)execute:(id <TBMBNotification>)notification {
    if ([notification.name isEqualToString:TBMBProxyHandlerName(0, self)]) {   //代理方法直接执行
        NSInvocation *invocation = notification.body;
        [invocation invokeWithTarget:self];
        return;
    }
    TBMBAutoHandlerNotification(self, notification);
}

+ (NSSet *)listReceiveNotifications {
    NSMutableSet *handlerNames = TBMBGetAllCommandHandlerName(self, TBMB_DEFAULT_RECEIVE_HANDLER_NAME);
    [handlerNames addObject:TBMBProxyHandlerName(0, self)];
    return handlerNames;
}

+ (id)proxy {
    return [[TBMBMessageProxy alloc] initWithClass:self andKey:0];
}
@end
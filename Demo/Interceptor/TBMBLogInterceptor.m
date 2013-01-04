//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-2 下午11:12.
//


#import "TBMBLogInterceptor.h"
#import "TBMBCommandInvocation.h"
#import "TBMBGlobalFacade.h"
#import "TBMBUtil.h"


@implementation TBMBLogInterceptor {

}
- (id)intercept:(id <TBMBCommandInvocation>)invocation {
    NSLog(@"invocation: %@", invocation);
    id ret = [invocation invoke];
    NSLog(@"Return: %@", ret);

    if ([ret isKindOfClass:[NSNumber class]] && [ret boolValue]) {
        TBMBGlobalSendNotificationForSELWithBody((@selector($$receiveLog:)),
                [NSString stringWithFormat:@"[%@][%d] has log @ %@", invocation.commandClass,
                                           TBMBIsNotificationProxy(invocation.notification), [NSDate date]]
        );
    } else {
        TBMBGlobalSendNotificationForSEL((@selector($$receiveNonLog:)));
    }
    return ret;
}


@end
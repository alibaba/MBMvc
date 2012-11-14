//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午9:49.
//


#import "TBMBStaticHelloCommand.h"
#import "TBMBTestService.h"
#import "TBMBGlobalFacade.h"
#import "TBMBDefaultNotification.h"


@implementation TBMBStaticHelloCommand {

}
+ (NSArray *)listReceiveNotifications {
    return [NSArray arrayWithObject:@"staticHello"];
}

+ (void)staticHelloHandler:(id <TBMBNotification>)notification {
    [TBMBTestService helloWorld:notification.body result:^(NSString *ret) {
        id <TBMBNotification> retNotification = [TBMBDefaultNotification objectWithName:@"receiveStaticHello"];
        retNotification.lastNotification = notification;
        retNotification.body = ret;
        retNotification.key = notification.key;
        [[TBMBGlobalFacade instance] sendTBMBNotification:retNotification];
    }];
}

@end
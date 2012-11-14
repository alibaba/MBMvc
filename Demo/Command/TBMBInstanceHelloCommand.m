//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 下午1:53.
//


#import "TBMBInstanceHelloCommand.h"
#import "TBMBTestService.h"
#import "TBMBDefaultNotification.h"
#import "TBMBMessageSender.h"
#import "TBMBGlobalFacade.h"


@implementation TBMBInstanceHelloCommand {

}

- (void)instanceHelloHandler:(id <TBMBNotification>)notification {
    [TBMBTestService helloWorld:notification.body result:^(NSString *ret) {
        id <TBMBNotification> retNotification = [TBMBDefaultNotification objectWithName:@"receiveInstanceHello"];
        retNotification.lastNotification = notification;
        retNotification.body = ret;
        retNotification.key = notification.key;
        [[TBMBGlobalFacade instance] sendTBMBNotification:retNotification];
    }];
}


@end
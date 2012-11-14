//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午9:49.
//


#import "TBMBStaticHelloCommand.h"
#import "TBMBTestService.h"
#import "TBMBGlobalFacade.h"
#import "TBMBDefaultNotification.h"


@implementation TBMBStaticHelloCommand

+ (void)staticHelloHandler:(id <TBMBNotification>)notification {
    [TBMBTestService helloWorld:notification.body result:^(NSString *ret) {
        [[TBMBGlobalFacade instance] sendTBMBNotification:[notification createNextNotification:@"receiveStaticHello"
                                                                                      withBody:ret]];
    }];
}

@end
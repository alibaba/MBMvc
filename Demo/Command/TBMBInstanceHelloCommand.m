//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 下午1:53.
//


#import "TBMBInstanceHelloCommand.h"
#import "TBMBTestService.h"
#import "TBMBMessageSender.h"
#import "TBMBGlobalFacade.h"


@implementation TBMBInstanceHelloCommand {

}

- (void)$$instanceHello:(id <TBMBNotification>)notification {
    NSLog(@"command Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    [TBMBTestService helloWorld:notification.body result:^(NSString *ret) {
        NSLog(@"command Callback Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
        TBMBGlobalSendNotificationForSELWithBody(@selector($$receiveInstanceHello:), ret);
    }];
}

- (void)sayHello:(NSString *)name result:(void (^)(NSString *ret))result {
    NSLog(@"command Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    [TBMBTestService helloWorld:name result:^(NSString *ret) {
        NSLog(@"command Callback Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
        if (result) {
            result(ret);
        }
    }];

}

- (void)dealloc {
    NSLog(@"%@ dealloc:%@", NSStringFromClass([self class]), self);
}


@end
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

- (NSNumber *)sayHello:(NSString *)name Age:(NSUInteger)age result:(void (^)(NSString *ret))result {
    NSLog(@"command Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    NSLog(@"run %p", result);
    [TBMBTestService helloWorld:name result:^(NSString *ret) {
        NSLog(@"command Callback Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
        if (result) {
            result([NSString stringWithFormat:@"%@_%d", ret, age]);
        }
    }];

    return [[NSNumber alloc] initWithBool:YES];

}

- (void)dealloc {
    NSLog(@"%@ dealloc:%@", NSStringFromClass([self class]), self);
}


@end
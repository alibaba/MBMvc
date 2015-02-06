//
// Created by Wentong on 15/2/6.
//

#import "TBMBDemoStep7RxCommand.h"
#import "RACDisposable.h"
#import "RACSubscriber.h"
#import "RACScheduler.h"


@implementation TBMBDemoStep7RxCommand {

}
- (RACDisposable *)observe:(id)parameter andSubscribe:(id <RACSubscriber>)subscriber {
    [subscriber sendNext:[NSDate date]];
    return nil;
}

- (RACScheduler *)runQueue {
    return [RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault];
}


@end
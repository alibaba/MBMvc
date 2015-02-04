//
// Created by Wentong on 15/2/4.
//

#import "TBMBTestRxCommand.h"
#import "RACDisposable.h"


@implementation TBMBTestRxCommand {

}
- (RACDisposable *)observe:(id)parameter andSubscribe:(id <RACSubscriber>)subscriber {
    NSLog(@"%@", [NSThread currentThread]);
    return nil;
}

@end
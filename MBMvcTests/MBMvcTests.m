//
//  MBMvcTests.m
//  MBMvcTests
//
//  Created by Wentong on 15/2/3.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TBMBTestRxCommand.h"
#import "RACSignal.h"
#import "RACScheduler.h"
#import "RACSubject.h"

@interface MBMvcTests : XCTestCase

@end

@implementation MBMvcTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testSignal {
    NSRunLoop *theRL = [NSRunLoop mainRunLoop];
    __block NSNumber *shouldKeepRunning = @YES;


    [[RACScheduler schedulerWithPriority:RACSchedulerPriorityLow
                                    name:@"Run"] schedule:^{
        sleep(1);
        TBMBTestRxCommand *command = [TBMBTestRxCommand command];
        [[command createSignal:@"1"] subscribeNext:^(id x) {
            NSLog(@"Subscribe %@", [RACScheduler currentScheduler]);
            shouldKeepRunning = @NO;
        }];
    }];

    while ([shouldKeepRunning boolValue] && [theRL runMode:NSDefaultRunLoopMode
                                                beforeDate:[NSDate distantFuture]]);
    XCTAssert(YES, @"Pass");
}


- (void)testSubject {
    NSRunLoop *theRL = [NSRunLoop mainRunLoop];
    __block NSNumber *shouldKeepRunning = @YES;


    [[RACScheduler schedulerWithPriority:RACSchedulerPriorityLow
                                    name:@"Run"] schedule:^{
        sleep(1);
        RACSubject *subject = [RACSubject subject];
        [subject subscribeNext:^(id x) {
            NSLog(@"Subscribe %@", [RACScheduler currentScheduler]);
            shouldKeepRunning = @NO;
        }];
        [[TBMBTestRxCommand command]
                            executeSubject:@1
                                andSubject:subject];
    }];

    while ([shouldKeepRunning boolValue] && [theRL runMode:NSDefaultRunLoopMode
                                                beforeDate:[NSDate distantFuture]]);
    XCTAssert(YES, @"Pass");

}


@end

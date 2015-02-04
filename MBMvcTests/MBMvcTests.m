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

- (void)testExample {
    // This is an example of a functional test case.

    TBMBTestRxCommand *command = [[TBMBTestRxCommand alloc] init];
    [[command createSignal:@"1"] subscribeNext:^(id x) {
        NSLog(@"%@", [NSThread currentThread]);
    }];
    XCTAssert(YES, @"Pass");

}


@end

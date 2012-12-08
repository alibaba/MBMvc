//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 下午1:53.
//


#import <Foundation/Foundation.h>
#import "TBMBSimpleInstanceCommand.h"
#import "TBMBSimpleSingletonCommand.h"
#import "TBMBTestDO.h"


@interface TBMBInstanceHelloCommand : TBMBSimpleSingletonCommand

- (void)sayHello:(TBMBTestDO *)name result:(void(^)(NSString *ret))result;
@end
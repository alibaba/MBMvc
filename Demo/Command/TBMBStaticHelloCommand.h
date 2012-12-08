//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午9:49.
//


#import <Foundation/Foundation.h>
#import "TBMBSimpleStaticCommand.h"
#import "TBMBTestDO.h"

@interface TBMBStaticHelloCommand : TBMBSimpleStaticCommand

+ (void)sayNo:(TBMBTestDO *)name result:(void (^)(NSString *ret))result;
@end
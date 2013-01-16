//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 下午1:53.
//


#import <Foundation/Foundation.h>
#import "TBMBSimpleInstanceCommand.h"
#import "TBMBSimpleSingletonCommand.h"
#import "TBMBOnlyProxy.h"


@interface TBMBSingletonHelloCommand : TBMBSimpleSingletonCommand <TBMBOnlyProxy>

- (NSNumber *)sayHello:(NSString *)name Age:(NSUInteger)age result:(void (^)(NSString *ret))result;
@end
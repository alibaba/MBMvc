//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午9:41.
//


#import <Foundation/Foundation.h>


@interface TBMBTestService : NSObject

+ (void)helloWorld:(NSString *)name result:(void (^)(NSString *ret))result;

+ (void)noWorld:(NSString *)name result:(void (^)(NSString *ret))result;
@end
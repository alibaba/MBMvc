//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午9:41.
//


#import "TBMBTestService.h"


@implementation TBMBTestService {

}
+ (void)helloWorld:(NSString *)name result:(void (^)(NSString *))result {
    if (result) {
        result([NSString stringWithFormat:@"hello,%@!", name]);
    }
}

+ (void)noWorld:(NSString *)name result:(void (^)(NSString *))result {
    if (result) {
        result([NSString stringWithFormat:@"no,%@!", name]);
    }
}


@end
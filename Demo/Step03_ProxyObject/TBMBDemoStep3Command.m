//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 下午12:23.
//


#import "TBMBDemoStep3Command.h"


@implementation TBMBDemoStep3Command {

}
- (void)getData:(void (^)(NSDate *))result {
    if (result) {
        result([NSDate date]);
    }
}


@end
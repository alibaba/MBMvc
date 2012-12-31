//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-31 上午9:12.
//


#import "TBMBTestCommand.h"


@implementation TBMBTestCommand {

}
- (void)justTest:(void (^)())done {
    if (done) {
        done();
    }
}
@end
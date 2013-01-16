//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-31 上午9:12.
//


#import "TBMBInstanceTestCommand.h"
#import "TBMBViewDO.h"


@implementation TBMBInstanceTestCommand {

}
- (void)justTest:(void (^)())done {
    if (done) {
        done();
    }
}

- (void)changeViewDOText:(id <TBMBViewDOProtocol>)viewDO {
    [viewDO setText:@"It is run in TBMBInstanceTestCommand!"];
}

@end
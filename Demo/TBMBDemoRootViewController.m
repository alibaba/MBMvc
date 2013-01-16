//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 上午11:09.
//


#import "TBMBDemoRootViewController.h"


@implementation TBMBDemoRootViewController {

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

- (void)dealloc {
    NSLog(@"dealloc %@", self);

}
@end
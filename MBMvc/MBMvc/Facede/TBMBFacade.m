//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午3:32.
//


#import "TBMBFacade.h"


@implementation TBMBFacade {

}
+ (TBMBFacade *)instance {
    static TBMBFacade *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

@end
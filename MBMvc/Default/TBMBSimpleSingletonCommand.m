//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-3 下午5:48.
//


#import "TBMBSimpleSingletonCommand.h"


@implementation TBMBSimpleSingletonCommand
+ (TBMBSimpleSingletonCommand *)instance {
    static TBMBSimpleSingletonCommand *_instance = nil;
    static dispatch_once_t _oncePredicate_TBMBSimpleSingletonCommand;

    dispatch_once(&_oncePredicate_TBMBSimpleSingletonCommand, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    );

    return _instance;
}
@end
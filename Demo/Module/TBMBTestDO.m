//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-8 下午10:16.
//


#import "TBMBTestDO.h"


@implementation TBMBTestDO {

@private
    NSString *_name;
}
@synthesize name = _name;

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }

    return self;
}

+ (id)objectWithName:(NSString *)name {
    return [[TBMBTestDO alloc] initWithName:name];
}

- (void)dealloc {
    NSLog(@"%@ delloc:%@", [self class], self);
}


@end
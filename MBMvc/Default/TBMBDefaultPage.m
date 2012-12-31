//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-31 下午4:58.
//


#import <objc/message.h>
#import "TBMBDefaultPage.h"


@implementation TBMBDefaultPage {
@protected
    id _viewDO;
}
@synthesize viewDO = _viewDO;

- (id)initWithFrame:(CGRect)frame withViewDO:(id)viewDO {
    self = [self initWithFrame:frame];
    if (self) {
        self.viewDO = viewDO;
        SEL selector = @selector(setViewVO:);
        if ([self respondsToSelector:selector]) {
            objc_msgSend(self, selector, viewDO);
        }
    }
    return self;
}


@end
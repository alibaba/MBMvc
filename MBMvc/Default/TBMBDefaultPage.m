//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-31 下午4:58.
//


#import <objc/message.h>
#import "TBMBDefaultPage.h"
#import "TBMBUtil.h"


@implementation TBMBDefaultPage

- (id)initWithFrame:(CGRect)frame withViewDO:(id)viewDO {
    self = [self initWithFrame:frame];
    if (self) {
        SEL selector = @selector(setViewDO:);
        if ([self respondsToSelector:selector]) {
            objc_msgSend(self, selector, viewDO);
        }
        [self loadView];
        [self autoBindingKeyPath];
    }
    return self;
}

- (void)loadView {

}

//自动扫描keyBinding
- (void)autoBindingKeyPath {
    TBMBAutoBindingKeyPath(self);
}


@end
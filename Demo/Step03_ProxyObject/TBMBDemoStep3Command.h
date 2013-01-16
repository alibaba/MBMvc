//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 下午12:23.
//


#import <Foundation/Foundation.h>
#import "TBMBSimpleInstanceCommand.h"


@interface TBMBDemoStep3Command : TBMBSimpleInstanceCommand
- (void)getData:(void (^)(NSDate *date))result;
@end
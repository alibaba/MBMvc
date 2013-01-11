//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-31 上午9:12.
//


#import <Foundation/Foundation.h>
#import "TBMBSimpleInstanceCommand.h"

@class TBMBViewDO;


@interface TBMBTestCommand : TBMBSimpleInstanceCommand

- (void)justTest:(void (^)())done;

- (void)changeViewDOText:(TBMBViewDO *)viewDO;
@end
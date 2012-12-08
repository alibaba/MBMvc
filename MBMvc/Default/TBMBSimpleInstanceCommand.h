//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午9:20.
//


#import <Foundation/Foundation.h>
#import "TBMBInstanceCommand.h"


@interface TBMBSimpleInstanceCommand : NSObject <TBMBInstanceCommand>
+ (id)proxy;
@end
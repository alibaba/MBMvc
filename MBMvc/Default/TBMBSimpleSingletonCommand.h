//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-3 下午5:48.
//


#import <Foundation/Foundation.h>
#import "TBMBInstanceCommand.h"
#import "TBMBSimpleInstanceCommand.h"
#import "TBMBSingletonCommand.h"


@interface TBMBSimpleSingletonCommand : TBMBSimpleInstanceCommand <TBMBSingletonCommand>
+ (TBMBSimpleSingletonCommand *)instance;

@end
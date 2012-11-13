//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-13 下午1:18.
//


#import <Foundation/Foundation.h>
#import "TBMBFacade.h"

@interface TBMBGlobalFacade : NSObject <TBMBFacade>
+ (BOOL)setDefaultFacade:(Class)facadeClass;

+ (TBMBGlobalFacade *)instance;
@end
//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 下午1:00.
//


#import <Foundation/Foundation.h>
#import "TBMBSimpleSingletonCommand.h"

@protocol TBMBDemoStep5ViewAlertShowProtocol;


@interface TBMBDemoStep5Command : TBMBSimpleSingletonCommand
- (NSNumber *)getDate:(id <TBMBDemoStep5ViewAlertShowProtocol>)obj;
@end
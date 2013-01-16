//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 下午1:00.
//


#import "TBMBDemoStep5Command.h"
#import "TBMBDemoStep5ViewDO.h"


@implementation TBMBDemoStep5Command {

}
- (NSNumber *)getDate:(id <TBMBDemoStep5ViewAlertShowProtocol>)obj {
    [obj setAlertText:[NSString stringWithFormat:@"现在时间:%@", [NSDate date]]];
    return [NSNumber numberWithBool:YES];
}


@end
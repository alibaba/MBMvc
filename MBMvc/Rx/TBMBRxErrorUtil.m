//
// Created by Wentong on 15/2/3.
//

#import "TBMBRxErrorUtil.h"

NSString *const NSRxErrorDomain = @"TBMB_RX_ERROR";

NSInteger NSRxErrorCode = 400;

@implementation TBMBRxErrorUtil {

}


+ (NSError *)convertNSException:(NSException *)exception {
    return [[NSError alloc]
                     initWithDomain:NSRxErrorDomain
                               code:NSRxErrorCode
                           userInfo:@{@"EXCEPTION" : exception}];
}

@end
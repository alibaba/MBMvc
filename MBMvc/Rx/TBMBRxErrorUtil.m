//
// Created by Wentong on 15/2/3.
//

#import "TBMBRxErrorUtil.h"

NSString *const NSRxErrorDomain = @"TBMB_RX_ERROR";

NSString *const NSRxExceptionKey = @"TBMB_RX_Exception_Key";

const NSInteger NSRxErrorCode = 400;

@implementation TBMBRxErrorUtil {

}


+ (NSError *)convertNSException:(NSException *)exception {
    return [[NSError alloc]
                     initWithDomain:NSRxErrorDomain
                               code:NSRxErrorCode
                           userInfo:@{NSRxExceptionKey : exception}];
}

@end
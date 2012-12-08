//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-8 下午1:46.
//


#import <Foundation/Foundation.h>

typedef enum {
    TBMB_CHAR, TBMB_UNSIGNED_CHAR, TBMB_C_BOOL, TBMB_DOUBLE, TBMB_INT, TBMB_FLOAT, TBMB_LONG, TBMB_UNSIGNED_LONG,
    TBMB_LONG_LONG, TBMB_UNSIGNED_LONG_LONG, TBMB_SHORT, TBMB_UNSIGNED_SHORT, TBMB_STRUCT, TBMB_UNSIGNED,
    TBMB_VOID_P, TBMB_CHAR_P, TBMB_ID, TBMB_CLASS, TBMB_SELECTOR, TBMB_NIL
} TBMBTypeOfProperty;

@interface TBMBSelectorParameter : NSObject

- (void)setTypeEncoding:(const char *)typeEncoding;
@end
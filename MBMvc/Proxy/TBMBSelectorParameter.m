//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-8 下午1:46.
//


#import "TBMBSelectorParameter.h"


@implementation TBMBSelectorParameter {
@private
    TBMBTypeOfProperty _type;
}
- (void)setTypeEncoding:(char const *)typeEncoding {
    switch (typeEncoding[0]) {
        case ('c'):
            _type = TBMB_CHAR;
            break;
        case ('C'):
            _type = TBMB_UNSIGNED_CHAR;
            break;
        case ('B'):
            _type = TBMB_C_BOOL;
            break;
        case ('d'):
            _type = TBMB_DOUBLE;
            break;
        case ('i'):
            _type = TBMB_INT;
            break;
        case ('f'):
            _type = TBMB_FLOAT;
            break;
        case ('l'):
            _type = TBMB_LONG;
            break;
        case ('L'):
            _type = TBMB_UNSIGNED_LONG;
            break;
        case ('q'):
            _type = TBMB_LONG_LONG;
            break;
        case ('Q'):
            _type = TBMB_UNSIGNED_LONG_LONG;
            break;
        case ('s'):
            _type = TBMB_SHORT;
            break;
        case ('S'):
            _type = TBMB_UNSIGNED_SHORT;
            break;
        case ('{'):
            _type = TBMB_STRUCT;
            break;
        case ('I'):
            _type = TBMB_UNSIGNED;
            break;
        case ('^'):
            _type = TBMB_VOID_P;
            break;
        case ('@'):
            _type = TBMB_ID;
            break;
        case ('*'):
            _type = TBMB_CHAR_P;
            break;
        case ('#'):
            _type = TBMB_CLASS;
            break;
        case (':'):
            _type = TBMB_SELECTOR;
            break;
        default:
            _type = TBMB_NIL;
            break;
    }
}


@end
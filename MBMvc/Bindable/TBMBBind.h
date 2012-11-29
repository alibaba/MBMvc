//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-29 上午9:03.
//


#import <Foundation/Foundation.h>


typedef void (^TBMB_CHANGE_BLOCK)(id old, id new);


@interface TBMBBind : NSObject
+ (void)bindObject:(id)bindable forKeyPath:(NSString *)keyPath withChange:(TBMB_CHANGE_BLOCK)changeBlock;
@end

extern inline void TBMBBindObject(id bindable, NSString *keyPath, TBMB_CHANGE_BLOCK changeBlock);
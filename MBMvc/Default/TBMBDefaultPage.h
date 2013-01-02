//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-31 下午4:58.
//


#import <Foundation/Foundation.h>
#import "TBMBPage.h"


@interface TBMBDefaultPage : UIView <TBMBPage>

//初始化一个page
- (id)initWithFrame:(CGRect)frame withViewDO:(id)viewDO;

@end
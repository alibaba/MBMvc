//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-21 上午8:17.
//


#import "TBMBAutoNilDelegateViewController.h"
#import "TBMBAutoNilDelegateViewDO.h"
#import "TBMBAutoNilDelegateView.h"

@interface TBMBAutoNilDelegateViewController ()
@property(nonatomic, strong) TBMBAutoNilDelegateViewDO *viewDO;
@end

@implementation TBMBAutoNilDelegateViewController {

}


- (void)loadView {
    [super loadView];
    if (!self.viewDO) {
        self.viewDO = [[TBMBAutoNilDelegateViewDO alloc] init];
        self.viewDO.tableData = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",
                                                          @"11", @"12", nil];
    }

    TBMBAutoNilDelegateView *view = [[TBMBAutoNilDelegateView alloc]
                                                              initWithFrame:self.view.bounds withViewDO:self.viewDO];
    [self.view addSubview:view];

}

@end
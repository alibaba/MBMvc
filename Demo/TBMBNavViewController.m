//
//  TBMBNavViewController.m
//  MBMvc
//
//  Created by 黄 若慧 on 11/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TBMBNavViewController.h"
#import "TBMBBind.h"
#import "TBMBNavViewDO.h"
#import "TBMBNavView.h"


@interface TBMBNavViewController ()
@property(nonatomic, strong) TBMBNavViewDO *viewDO;
@end

@implementation TBMBNavViewController

//当self.viewDO.demoStep的值改变时 触发的操作
TBMBWhenThisKeyPathChange(viewDO, demoStep)
{
    if (!isInit && new) {   //当初始化和new没有值时不响应
        TBMBDemoStep
                step = (TBMBDemoStep)
                [new intValue];
        switch (step) {
                //FIXME
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.viewDO = [[TBMBNavViewDO alloc] init];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    TBMBNavView *navView = [[TBMBNavView alloc] initWithFrame:self.view.frame withViewDO:self.viewDO];
    [self.view addSubview:navView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

- (void)dealloc {
    NSLog(@"dealloc %@", self);

}
@end
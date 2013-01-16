//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 上午10:55.
//


#import "TBMBDemoStep1View.h"


@implementation TBMBDemoStep1View {

}

- (void)loadView {
    [super loadView];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 40, 200, 30)];
    [button addTarget:self action:@selector(showTime) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"Show Time" forState:UIControlStateNormal];
    [self addSubview:button];

    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(50, 80, 200, 30)];
    [button2 addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    button2.backgroundColor = [UIColor blueColor];
    [button2 setTitle:@"Goto Next Page" forState:UIControlStateNormal];
    [self addSubview:button2];
}

- (void)nextPage {
    [self.delegate pushNewPage];
}

- (void)showTime {
    [self.delegate showTime];
}

- (void)alert:(NSString *)text {
    [[[UIAlertView alloc]
                   initWithTitle:@"title"
                         message:text
                        delegate:nil cancelButtonTitle:@"关闭"
               otherButtonTitles:nil] show];

}


@end
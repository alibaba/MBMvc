//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 上午11:48.
//


#import "TBMBDemoStep2View.h"


@implementation TBMBDemoStep2View {

}

- (void)loadView {
    [super loadView];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 40, 200, 30)];
    [button addTarget:self action:@selector(showTime) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"Show Time" forState:UIControlStateNormal];
    [self addSubview:button];
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
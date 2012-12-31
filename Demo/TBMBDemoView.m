//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-8 下午3:48.
//


#import "TBMBDemoView.h"
#import "TBMBBind.h"
#import "TBMBViewController.h"


@implementation TBMBDemoView {
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 40, 200, 30)];
        [button setTitle:@"请求" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(requestStatic:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor redColor];
        button.tag = 1;
        [self addSubview:button];

        UIButton *buttonTwo = [[UIButton alloc] initWithFrame:CGRectMake(50, 80, 200, 30)];
        [buttonTwo setTitle:@"请求" forState:UIControlStateNormal];
        [buttonTwo addTarget:self action:@selector(requestInstance:) forControlEvents:UIControlEventTouchUpInside];
        buttonTwo.backgroundColor = [UIColor redColor];
        buttonTwo.tag = 2;
        [self addSubview:buttonTwo];

        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 120, 200, 30)];
        textField.backgroundColor = [UIColor redColor];
        textField.tag = 3;
        textField.text = @"test";
        [self addSubview:textField];

        UIButton *buttonNav = [[UIButton alloc] initWithFrame:CGRectMake(50, 160, 200, 30)];
        [buttonNav setTitle:@"下一个" forState:UIControlStateNormal];
        [buttonNav addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        buttonNav.backgroundColor = [UIColor redColor];
        buttonNav.tag = 4;
        [self addSubview:buttonNav];

        UIButton *buttonPrev = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 200, 30)];
        [buttonPrev setTitle:@"上一个" forState:UIControlStateNormal];
        [buttonPrev addTarget:self action:@selector(prev:) forControlEvents:UIControlEventTouchUpInside];
        buttonPrev.backgroundColor = [UIColor redColor];
        buttonPrev.tag = 5;


        UITextField *textFieldSync = [[UITextField alloc] initWithFrame:CGRectMake(50, 240, 200, 30)];
        textFieldSync.backgroundColor = [UIColor blueColor];
        textFieldSync.tag = 6;
        [self addSubview:textFieldSync];

        TBMBBindPropertyWeak(textField, text, UITextField *, textFieldSync, text);
        textField.text = @"testl123345";
        [self addSubview:buttonPrev];
    }

    return self;
}

- (void)prev:(id)prev {
    [self.viewDO setClickPrev :YES];
}

- (void)next:(id)next {
    [self.viewDO setClickNext :YES];
}

- (void)requestInstance:(id)requestInstance {
    [self.viewDO setRequestInstance :YES];
}

- (void)requestStatic:(id)requestStatic {
    [self.viewDO setRequestStatic :YES];
}

@end
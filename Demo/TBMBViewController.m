//
//  TBMBViewController.m
//  MBMvc
//
//  Created by 黄 若慧 on 11/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TBMBViewController.h"

@interface TBMBViewController ()

@end

@implementation TBMBViewController


- (void)loadView {
    [super loadView];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 40, 100, 30)];
    [button setTitle:@"请求" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(requestStatic:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    button.tag = 1;
    [self.view addSubview:button];

    UIButton *buttonTwo = [[UIButton alloc] initWithFrame:CGRectMake(50, 80, 100, 30)];
    [buttonTwo setTitle:@"请求" forState:UIControlStateNormal];
    [buttonTwo addTarget:self action:@selector(requestInstance:) forControlEvents:UIControlEventTouchUpInside];
    buttonTwo.backgroundColor = [UIColor redColor];
    buttonTwo.tag = 2;
    [self.view addSubview:buttonTwo];

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 120, 200, 30)];
    textField.backgroundColor = [UIColor redColor];
    textField.tag = 3;
    textField.text = @"test";
    [self.view addSubview:textField];
}

- (void)requestStatic:(UIButton *)sender {
    NSLog(@"Send Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    UITextField *view = (UITextField *) [self.view viewWithTag:3];
    [self sendNotification:NSStringFromSelector(@selector($$staticHello:)) body:view.text];
}

- (void)requestInstance:(UIButton *)sender {
    NSLog(@"Send Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    UITextField *view = (UITextField *) [self.view viewWithTag:3];
    [self sendNotification:NSStringFromSelector(@selector($$instanceHello:)) body:view.text];
}


- (void)$$receiveStaticHello:(id <TBMBNotification>)notification {
    NSLog(@"Receive Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    NSLog(@"isSendByMe:%d", notification.key == self.notificationKey);
    UIButton *view = (UIButton *) [self.view viewWithTag:1];
    [view setTitle:notification.body forState:UIControlStateNormal];
}

- (void)$$receiveInstanceHello:(id <TBMBNotification>)notification {
    NSLog(@"Receive Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    NSLog(@"isSendByMe:%d", notification.key == self.notificationKey);
    UIButton *view = (UIButton *) [self.view viewWithTag:2];
    [view setTitle:notification.body forState:UIControlStateNormal];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
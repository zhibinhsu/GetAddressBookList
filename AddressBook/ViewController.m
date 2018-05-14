//
//  ViewController.m
//  AddressBook
//
//  Created by Admin on 2018/5/14.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import "ViewController.h"
#import "GetAddressBook.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GetAddressBook getAddressBookAction];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

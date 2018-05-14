//
//  GetAddressBook.m
//  AddressBook
//
//  Created by Admin on 2018/5/14.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import "GetAddressBook.h"

#import <AddressBook/AddressBook.h>

@implementation GetAddressBook

+ (void)getAddressBookAction {
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    // 用户授权
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) { // 首次访问通讯录
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            
            if (!error) {
                
                if (granted) { // 允许
                    
                    NSArray *contacts = [GetAddressBook fetchContactWithAddressBook:addressBook];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSLog(@"contacts:%@", contacts);
                    });
                } else { // 拒绝
                    
                    NSLog(@"拒绝");
                }
            } else {
                
                NSLog(@"错误!");
            }
        });
    } else { // 非首次访问通讯录
        
        NSArray *contacts = [GetAddressBook fetchContactWithAddressBook:addressBook];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"contacts:%@", contacts);
        });
    }
}

+ (NSMutableArray *)fetchContactWithAddressBook:(ABAddressBookRef)addressBook{
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) { // 有权限访问
        // 获取联系人数组
        NSArray *array = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSMutableArray *contacts = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            
            // 获取联系人
            ABRecordRef people = CFArrayGetValueAtIndex((__bridge ABRecordRef)array, i);
            // 获取联系人详细信息,如:姓名,电话,住址等信息
            NSString *firstName = (__bridge NSString *)ABRecordCopyValue(people, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty);
            
            // 判断姓名null
            NSString *allName;
            if (lastName.length > 0 || firstName.length > 0) {
                
                allName = [NSString stringWithFormat:@"%@%@", lastName, firstName];
            } else {
                
                allName = @"";
            }
            
            ABMutableMultiValueRef phoneNumRef = ABRecordCopyValue(people, kABPersonPhoneProperty);
            NSString *phoneNumber =  ((__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneNumRef)).lastObject;
            // 判断手机号null
            NSString *phone;
            if (phoneNumber.length > 0) {
                
                phone = phoneNumber;
            }else{
                
                phone = @"";
            }
            
            // 如果不加上面的判断，这里加入数组的时候会出错，不会判断(null)这个东西，所以要先排除
            [contacts addObject:@{@"name": allName, @"phoneNumber": phone}];
            
        }
        return contacts;
        
    } else { // 无权限访问
        
        // 提示授权
//        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\n设置-隐私-通讯录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alart show];
        
        return nil;
    }
}


@end

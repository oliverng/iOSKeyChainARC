//
//  ViewController.m
//  iOSKeyChainARC
//
//  Created by Oliver Ng on 30/5/15.
//  Copyright (c) 2015 Security Compass. All rights reserved.
//  http://www.securitycompass.com
//

#import "ViewController.h"
#import <Security/Security.h>



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}



- (IBAction)saveButton:(id)sender
{
  //Let's create an empty mutable dictionary:
  NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
  
  NSString *username = self.usernameTxtFld.text;
  NSString *token = self.passwordTxtFld.text;
  
  keychainItem[(__bridge id<NSCopying>)(kSecClass)] = (__bridge id)(kSecClassGenericPassword);
  keychainItem[(__bridge id<NSCopying>)(kSecAttrAccessible)] = (__bridge id)(kSecAttrAccessibleWhenUnlocked);
  
  // need to check against unique value which is username
  keychainItem[(__bridge id<NSCopying>)(kSecAttrAccount)] = username;
  
  //Check if username item already exists.
  if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)  {
  
    [self updateKeychain:username withToken:token withKeychain:keychainItem];
    
  } else {

    // add data to the keychain
    keychainItem[(__bridge id)kSecValueData] = [token dataUsingEncoding:NSUTF8StringEncoding];
    
    // add to keychain
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
    NSLog(@"Add Status Code: %d", (int)status);
  }
}



- (void)updateKeychain:(NSString *)username withToken:(NSString *)token withKeychain:(NSMutableDictionary *)keychainItem{
  //Let's create an empty mutable dictionary:
  NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
  attributesToUpdate[(__bridge id)kSecValueData] = [token dataUsingEncoding:NSUTF8StringEncoding];
  
  // add data to the keychain
  attributesToUpdate[(__bridge id<NSCopying>)(kSecAttrAccount)] = username;
  attributesToUpdate[(__bridge id)kSecValueData] = [token dataUsingEncoding:NSUTF8StringEncoding];
  
  // update keychain with dictionary attributes
  OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)keychainItem, (__bridge CFDictionaryRef)attributesToUpdate);
  NSLog(@"Update Status Code: %d", (int)status);

}


- (IBAction)getTokenButton:(id)sender
{
  NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
  
  NSString *username = self.usernameTxtFld.text;
  
  keychainItem[(__bridge id<NSCopying>)(kSecClass)] = (__bridge id)(kSecClassGenericPassword);
  keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
  keychainItem[(__bridge id)kSecAttrAccount] = username;

  //Check if this keychain item already exists.
  keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
  keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
  
  CFDictionaryRef result = nil;
  OSStatus sts = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
  
  NSLog(@"Get Token Status Code: %d", (int)sts);
  
  if (sts == noErr) {
    NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
    NSData *result = resultDict[(__bridge id)kSecValueData];
    NSString *token = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    
    self.storedTxtFld.text = token;
    
  } else {
    // send alert message
    [self createAlert:@"No keychain item for this key found" ];
  }
}


- (IBAction)deleteButton:(id)sender
{
  NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
  
  NSString *username = self.usernameTxtFld.text;
  keychainItem[(__bridge id<NSCopying>)(kSecClass)] = (__bridge id)(kSecClassGenericPassword);
  keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
  
  keychainItem[(__bridge id)kSecAttrAccount] = username;
  
  //Check if this keychain item already exists.
  if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr) {
    OSStatus sts = SecItemDelete((__bridge CFDictionaryRef)keychainItem);
    NSLog(@"Error Code: %d", (int)sts);
    
    //clear field
    self.storedTxtFld.text = @"";
    
  } else {
    // send alert message
    [self createAlert:@"No keychain item for this key found" ];
  }
}


- (void)createAlert:(NSString *)message {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops", nil)
                                                  message:NSLocalizedString(message, nil)
                                                 delegate:nil
                                        cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                        otherButtonTitles:nil];
  [alert show];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end

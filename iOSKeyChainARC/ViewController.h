//
//  ViewController.h
//  iOSKeyChainARC
//
//  Created by Oliver Ng on 30/5/15.
//  Copyright (c) 2015 Security Compass. All rights reserved.
//  http://www.securitycompass.com
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *storedTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *usernameTxtFld;

- (IBAction)saveButton:(id)sender;
- (IBAction)getTokenButton:(id)sender;
- (IBAction)deleteButton:(id)sender;


@end


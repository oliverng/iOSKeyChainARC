//
//  ViewController.h
//  iOSKeyChainARC
//
//  Created by Oliver and Vienne Ng on 1/4/15.
//  Copyright (c) 2015 ONG. All rights reserved.
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


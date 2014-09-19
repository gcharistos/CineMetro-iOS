//
//  LoginViewController.h
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property int loginStatus;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)loginButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *okbutton;

@end

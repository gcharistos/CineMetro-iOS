//
//  CreateNewAccountViewController.h
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNewAccountViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UIScrollView *scroller;

}
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)createButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *passwordValTextField;

@end

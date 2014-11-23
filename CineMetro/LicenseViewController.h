//
//  LicenseViewController.h
//  CineMetro
//
//  Created by George Haristos on 17/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LicenseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *popUpView;
- (void)showInView:(UIView *)aView  withController:(UIViewController *)controller  withText:(NSString *)text  withColor:(UIColor *)color withTextColor:(UIColor *)textColor animated:(BOOL)animated;
- (IBAction)closeButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@end

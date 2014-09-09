//
//  ShowImageViewController.h
//  CineMetro
//
//  Created by George Haristos on 9/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface ShowImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

- (void)showInView:(UIView *)aView withImage:(NSString *)Image withController:(UIViewController *)controller animated:(BOOL)animated;

@end

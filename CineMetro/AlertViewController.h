//
//  AlertViewController.h
//  CineMetro
//
//  Created by George Haristos on 21/10/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UILabel *alert;

- (void)showInView:(UIView *)aView  withMessage:(NSString *)message  animated:(BOOL)animated;

@end

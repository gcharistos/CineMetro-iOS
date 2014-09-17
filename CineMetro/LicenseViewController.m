//
//  LicenseViewController.m
//  CineMetro
//
//  Created by George Haristos on 17/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "LicenseViewController.h"

@interface LicenseViewController ()

@end

@implementation LicenseViewController
@synthesize textview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)showInView:(UIView *)aView  withController:(UIViewController *)controller  withText:(NSString *)text animated:(BOOL)animated{
    dispatch_async(dispatch_get_main_queue(), ^{
        // viewController = (GreenDetailsViewController *)controller;
        [aView addSubview:self.view];
        textview.text = text;
        if (animated) {
            [self showAnimate];
        }
    });

}

- (IBAction)closeButtonPressed:(id)sender {
    [self removeAnimate];
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

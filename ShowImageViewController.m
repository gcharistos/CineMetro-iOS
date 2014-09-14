//
//  ShowImageViewController.m
//  CineMetro
//
//  Created by George Haristos on 9/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "ShowImageViewController.h"
#import "PageContentViewController.h"

@interface ShowImageViewController ()

@end

@implementation ShowImageViewController
@synthesize imageview;
 PageContentViewController *viewController;


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
  //  self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    self.popUpView.layer.shadowOpacity = 0.8;
    self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognized:)];
    [self.view addGestureRecognizer:tapGesture];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)showInView:(UIView *)aView withImage:(NSString *)Image withController:(UIViewController *)controller animated:(BOOL)animated{

    dispatch_async(dispatch_get_main_queue(), ^{
        viewController = (PageContentViewController *)controller;
        [aView addSubview:self.view];
        imageview.image = [UIImage imageNamed:Image];

        if (animated) {
            [self showAnimate];
        }
    });

    
}

- (IBAction)closeView:(id)sender {
    [self removeAnimate];

}

-(void)tapGestureRecognized:(UIGestureRecognizer *)sender{
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
- (IBAction)closePopup:(id)sender {
    [self removeAnimate];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

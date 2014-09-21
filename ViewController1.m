//
//  ViewController1.m
//  CineMetro
//
//  Created by George Haristos on 4/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "ViewController1.h"
#import <MapKit/MapKit.h>
#import "MapViewController.h"

@interface ViewController1 ()

@end

@implementation ViewController1
@synthesize cancelbutton;
@synthesize locationbutton;
@synthesize directionsbutton;
MKPointAnnotation *currentAnnotation;
MapViewController *viewController;

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
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    self.popUpView.layer.cornerRadius = 5;
    self.popUpView.layer.shadowOpacity = 0.8;
    self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognized:)];
//    [self.view addGestureRecognizer:tapGesture];
   [cancelbutton setTitle:NSLocalizedString(@"cancel",@"word") forState:UIControlStateNormal];
    [directionsbutton setTitle:NSLocalizedString(@"directions",@"word") forState:UIControlStateNormal];
    [locationbutton setTitle:NSLocalizedString(@"userlocation",@"word") forState:UIControlStateNormal];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

-(IBAction)directions:(id)sender{
    MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:currentAnnotation.coordinate addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc]initWithPlacemark:placemark];
    destination.name = currentAnnotation.title;
    [destination openInMapsWithLaunchOptions:nil];
    [self removeAnimate];

}

-(IBAction)userLocation:(id)sender{
    [self removeAnimate];
    [viewController showUserLocation];

}

- (void)showInView:(UIView *)aView withAnnotation:(MKPointAnnotation *)annotation withController:(UIViewController *)controller animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        currentAnnotation = annotation;
        viewController = (MapViewController *)controller;
    [aView addSubview:self.view];
    if (animated) {
        [self showAnimate];
    }
    });
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

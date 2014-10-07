//
//  MapSettingsViewController.h
//  CineMetro
//
//  Created by George Haristos on 7/10/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import <MapKit/MapKit.h>

@interface MapSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIButton *directionsbutton;
@property (weak, nonatomic) IBOutlet UIButton *locationbutton;
@property (weak, nonatomic) IBOutlet UIButton *cancelbutton;


- (void)showInView:(UIView *)aView withAnnotation:(MKPointAnnotation *)annotation withController:(UIViewController *)controller animated:(BOOL)animated;
@end

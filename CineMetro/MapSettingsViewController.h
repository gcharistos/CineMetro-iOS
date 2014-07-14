//
//  MapSettingsViewController.h
//  CineMetro
//
//  Created by George Haristos on 7/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapSettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *stationSwitch;
- (IBAction)stationSwitchChanged:(UISwitch *)sender;
- (IBAction)redSwitchChanged:(UISwitch *)sender;
- (IBAction)blueSwitchChanged:(UISwitch *)sender;
- (IBAction)greenSwitchChanged:(UISwitch *)sender;
- (IBAction)orangeSwitchChanged:(UISwitch *)sender;
- (IBAction)purpleSwitchChanged:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;

@property (weak, nonatomic) IBOutlet UILabel *blueLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *orangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *purpleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *redSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *blueSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *greenSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *orangeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *purpleSwitch;
@end

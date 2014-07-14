//
//  MapSettingsViewController.m
//  CineMetro
//
//  Created by George Haristos on 7/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "MapSettingsViewController.h"

@interface MapSettingsViewController ()

@end

@implementation MapSettingsViewController
@synthesize stationSwitch;
@synthesize redLabel;
@synthesize blueLabel;
@synthesize greenLabel;
@synthesize orangeLabel;
@synthesize purpleLabel;
@synthesize redSwitch;
@synthesize blueSwitch;
@synthesize greenSwitch;
@synthesize orangeSwitch;
@synthesize purpleSwitch;

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"stationSwitch"]){
        stationSwitch.on = [defaults boolForKey:@"stationSwitch"];
    }
    if([defaults objectForKey:@"redLabel"]){
        redLabel.hidden = [defaults boolForKey:@"redLabel"];
    }
    if([defaults objectForKey:@"blueLabel"]){
        blueLabel.hidden = [defaults boolForKey:@"blueLabel"];
    }
    if([defaults objectForKey:@"greenLabel"]){
        greenLabel.hidden = [defaults boolForKey:@"greenLabel"];
    }
    if([defaults objectForKey:@"orangeLabel"]){
        orangeLabel.hidden = [defaults boolForKey:@"orangeLabel"];
    }
    if([defaults objectForKey:@"purpleLabel"]){
        purpleLabel.hidden = [defaults boolForKey:@"purpleLabel"];
    }
    if([defaults objectForKey:@"redSwitch"]){
        redSwitch.hidden = [defaults boolForKey:@"redSwitch"];
    }
    if([defaults objectForKey:@"blueSwitch"]){
        blueSwitch.hidden = [defaults boolForKey:@"blueSwitch"];
    }
    if([defaults objectForKey:@"greenSwitch"]){
        greenSwitch.hidden = [defaults boolForKey:@"greenSwitch"];
    }
    if([defaults objectForKey:@"orangeSwitch"]){
        orangeSwitch.hidden = [defaults boolForKey:@"orangeSwitch"];
    }
    if([defaults objectForKey:@"purpleSwitch"]){
        purpleSwitch.hidden = [defaults boolForKey:@"purpleSwitch"];
    }
    if([defaults objectForKey:@"redSwitchState"]){
        redSwitch.on = [defaults boolForKey:@"redSwitchState"];
    }
    if([defaults objectForKey:@"blueSwitchState"]){
        blueSwitch.on = [defaults boolForKey:@"blueSwitchState"];
    }
    if([defaults objectForKey:@"greenSwitchState"]){
        greenSwitch.on = [defaults boolForKey:@"greenSwitchState"];
    }
    if([defaults objectForKey:@"orangeSwitchState"]){
        orangeSwitch.on = [defaults boolForKey:@"orangeSwitchState"];
    }
    if([defaults objectForKey:@"purpleSwitchState"]){
        purpleSwitch.on = [defaults boolForKey:@"purpleSwitchState"];
    }





    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//  CHANGED STATE OF STATIONS SWITCH
- (IBAction)stationSwitchChanged:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(sender.isOn){ // switch is on . reveal other switches
        [defaults setBool:YES forKey:@"stationSwitch"];
        redLabel.hidden = NO;
        [defaults setBool:NO forKey:@"redLabel"];
        blueLabel.hidden = NO;
        [defaults setBool:NO forKey:@"blueLabel"];
        greenLabel.hidden = NO;
        [defaults setBool:NO forKey:@"greenLabel"];
        orangeLabel.hidden = NO;
        [defaults setBool:NO forKey:@"orangeLabel"];
        purpleLabel.hidden = NO;
        [defaults setBool:NO forKey:@"purpleLabel"];
        redSwitch.hidden = NO;
        [defaults setBool:NO forKey:@"redSwitch"];
        blueSwitch.hidden = NO;
        [defaults setBool:NO forKey:@"blueSwitch"];
        greenSwitch.hidden = NO;
        [defaults setBool:NO forKey:@"greenSwitch"];
        orangeSwitch.hidden = NO;
        [defaults setBool:NO forKey:@"orangeSwitch"];
        purpleSwitch.hidden = NO;
        [defaults setBool:NO forKey:@"purpleSwitch"];
    }
    else{ // switch is off . hide other  switches
        [defaults setBool:NO forKey:@"stationSwitch"];
        redLabel.hidden = YES;
        [defaults setBool:YES forKey:@"redLabel"];
        blueLabel.hidden = YES;
        [defaults setBool:YES forKey:@"blueLabel"];
        greenLabel.hidden = YES;
        [defaults setBool:YES forKey:@"greenLabel"];

        orangeLabel.hidden = YES;
        [defaults setBool:YES forKey:@"orangeLabel"];
        purpleLabel.hidden = YES;
        [defaults setBool:YES forKey:@"purpleLabel"];
        redSwitch.hidden = YES;
        [defaults setBool:YES forKey:@"redSwitch"];
        blueSwitch.hidden = YES;
        [defaults setBool:YES forKey:@"blueSwitch"];
        greenSwitch.hidden = YES;
        [defaults setBool:YES forKey:@"greenSwitch"];
        orangeSwitch.hidden = YES;
        [defaults setBool:YES forKey:@"orangeSwitch"];
        purpleSwitch.hidden = YES;
        [defaults setBool:YES forKey:@"purpleSwitch"];
    }
}

- (IBAction)redSwitchChanged:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(sender.isOn){
        [defaults setBool:YES forKey:@"redSwitchState"];
    }
    else{
        [defaults setBool:NO forKey:@"redSwitchState"];

    }
}

- (IBAction)blueSwitchChanged:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(sender.isOn){
        [defaults setBool:YES forKey:@"blueSwitchState"];
    }
    else{
        [defaults setBool:NO forKey:@"blueSwitchState"];
        
    }

}

- (IBAction)greenSwitchChanged:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(sender.isOn){
        [defaults setBool:YES forKey:@"greenSwitchState"];
    }
    else{
        [defaults setBool:NO forKey:@"greenSwitchState"];
        
    }

}

- (IBAction)orangeSwitchChanged:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(sender.isOn){
        [defaults setBool:YES forKey:@"orangeSwitchState"];
    }
    else{
        [defaults setBool:NO forKey:@"orangeSwitchState"];
        
    }

}

- (IBAction)purpleSwitchChanged:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(sender.isOn){
        [defaults setBool:YES forKey:@"purpleSwitchState"];
    }
    else{
        [defaults setBool:NO forKey:@"purpleSwitchState"];
        
    }

}
@end

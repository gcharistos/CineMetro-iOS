//
//  FilmFestivalViewController.m
//  CineMetro
//
//  Created by George Haristos on 14/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "FilmFestivalViewController.h"

@interface FilmFestivalViewController ()

@end

@implementation FilmFestivalViewController
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
    textview.text = NSLocalizedString(@"filmFestival",@"word");
    [textview setTextColor:[UIColor orangeColor]];
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

@end

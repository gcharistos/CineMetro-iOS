//
//  TutorialContentViewController.m
//  CineMetro
//
//  Created by George Haristos on 5/12/15.
//  Copyright (c) 2015 George Haristos. All rights reserved.
//

#import "TutorialContentViewController.h"

@interface TutorialContentViewController ()

@end


@implementation TutorialContentViewController

@synthesize image;
@synthesize gtext;

- (void)viewDidLoad {
    [super viewDidLoad];
    gtext.text = self.tutorText;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end

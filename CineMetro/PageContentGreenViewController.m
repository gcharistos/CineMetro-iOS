//
//  PageContentBlueViewController.m
//  CineMetro
//
//  Created by George Haristos on 2/10/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "PageContentGreenViewController.h"
#import <POP.h>

@interface PageContentGreenViewController ()

@end

@implementation PageContentGreenViewController
@synthesize pageIndex;
@synthesize parent;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    self.textview.text = self.desc;
    [self.textview setFont:[UIFont systemFontOfSize:15]];
  //  self.textview.textColor = [UIColor whiteColor];


    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedImage:)];
    gesture.delegate = self;
    [self.backgroundImageView  addGestureRecognizer:gesture];
}

-(void)viewWillAppear:(BOOL)animated{
    self.parent.currentYear.text = self.year;
    self.parent.previousYear.text = self.previousyear;
    if([self.previousyear isEqualToString:@""]){
        self.parent.backButton.enabled = NO;
    }
    else {
        self.parent.backButton.enabled = YES;
    }
    self.parent.previousYear.enabled = NO;
    self.parent.nextYear.text = self.nextyear;
    if([self.nextyear isEqualToString:@""]){
        self.parent.forwardButton.enabled = NO;
    }
    else{
        self.parent.forwardButton.enabled = YES;

    }
    self.parent.nextYear.enabled = NO;

}



-(void)tappedImage:(UITapGestureRecognizer *)sender{
    self.popViewController = [[ShowImageViewController alloc] initWithNibName:@"ShowImageViewController" bundle:nil];
    
    [self.popViewController showInView:self.parentViewController.parentViewController.navigationController.view withImage:self.imageFile withController:self animated:YES];
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


- (IBAction)mapPressed:(id)sender {
    NSLog(@"pressed !!!!!!!");
}
@end

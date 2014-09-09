//
//  PageContentViewController.m
//  CineMetro
//
//  Created by George Haristos on 8/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "PageContentViewController.h"
#import "ShowImageViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

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
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedImage:)];
    [self.view addGestureRecognizer:gesture];
    // Do any additional setup after loading the view.
}

-(void)tappedImage:(UITapGestureRecognizer *)sender{
    NSLog(@"tAPPED %@",self.imageFile);
    self.popViewController = [[ShowImageViewController alloc] initWithNibName:@"ShowImageViewController" bundle:nil];
    
    [self.popViewController showInView:self.parentViewController.parentViewController.navigationController.view withImage:self.imageFile withController:self animated:YES];
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

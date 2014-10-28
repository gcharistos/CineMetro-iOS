//
//  PageContentBlueViewController.h
//  CineMetro
//
//  Created by George Haristos on 2/10/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowImageViewController.h"
#import "GreenDetailsViewController.h"

@interface PageContentGreenViewController : UIViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property NSUInteger pageIndex;
@property (strong,nonatomic) NSString *desc;
@property NSString *imageFile;
@property NSString *year;
@property NSString *nextyear;
@property NSString *previousyear;
@property (strong,nonatomic) ShowImageViewController *popViewController;
@property GreenDetailsViewController *parent;
@property (weak, nonatomic) IBOutlet UITextView *textview;
- (IBAction)mapPressed:(id)sender;
@end

//
//  RatingViewController.h
//  CineMetro
//
//  Created by George Haristos on 12/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;

@property (weak, nonatomic) IBOutlet UIImageView *star5;

- (void)showInView:(UIView *)aView  withController:(UIViewController *)controller animated:(BOOL)animated;
- (IBAction)okButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *stars;
- (IBAction)cancelButtonPressed:(id)sender;

@end

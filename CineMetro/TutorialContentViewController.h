//
//  TutorialContentViewController.h
//  CineMetro
//
//  Created by George Haristos on 5/12/15.
//  Copyright (c) 2015 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *gtext;
@property NSUInteger pageIndex;
@property NSString *imageFile;
@property NSString *tutorText;
@end

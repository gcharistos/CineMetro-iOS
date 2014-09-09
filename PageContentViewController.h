//
//  PageContentViewController.h
//  CineMetro
//
//  Created by George Haristos on 8/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowImageViewController.h"

@interface PageContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property NSUInteger pageIndex;
@property (strong,nonatomic) ShowImageViewController *popViewController;
@property NSString *imageFile;
@end

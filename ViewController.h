//
//  ViewController.h
//  CineMetro
//
//  Created by George Haristos on 8/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"


@interface ViewController : UIViewController<UIPageViewControllerDataSource>
- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;

@end

//
//  TutorialPageViewController.h
//  CineMetro
//
//  Created by George Haristos on 5/12/15.
//  Copyright (c) 2015 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialPageViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pages;
@end

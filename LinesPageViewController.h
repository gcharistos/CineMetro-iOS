//
//  LinesPageViewController.h
//  CineMetro
//
//  Created by George Haristos on 29/11/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinesPageViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;
-(void)setStationAndIndex:(NSInteger) index : (NSArray *)array;
@end

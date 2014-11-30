//
//  AboutPageViewController.m
//  CineMetro
//
//  Created by George Haristos on 29/11/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "AboutPageViewController.h"
#import "AboutContentViewController.h"

@interface AboutPageViewController ()

@end

@implementation AboutPageViewController
NSUInteger currentIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    currentIndex = 0;
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewControllerTimeline"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    AboutContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:_pageViewController.view];
    // Do any additional setup after loading the view.
}

//Creates page view
- (AboutContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if ((index  == -1) || (index >= 3)) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    AboutContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutContentViewController"];
    pageContentViewController.pageIndex = index;
    pageContentViewController.imageFile = [NSString stringWithFormat:@"logo.png"];
    if(index == 0){
        pageContentViewController.text = NSLocalizedString(@"about1",@"word");
    }
    else if(index == 1){
        pageContentViewController.text = NSLocalizedString(@"about2",@"word");
    }
    else if(index == 2){
        pageContentViewController.text = NSLocalizedString(@"about3",@"word");
    }
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source
//method for previous page view
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    currentIndex = [((AboutContentViewController*) viewController) pageIndex];
    
    if (currentIndex == 0) {
        return nil;
    }
    currentIndex--;
    
    return [self viewControllerAtIndex:currentIndex];
}


//method for next page view
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    currentIndex = [((AboutContentViewController*) viewController) pageIndex];
    currentIndex++;
    if (currentIndex == 3) {
        return nil;
    }
    
    
    
    return [self viewControllerAtIndex:currentIndex];
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

//
//  ContainerBlueViewController.m
//  CineMetro
//
//  Created by George Haristos on 2/10/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "ContainerBlueViewController.h"
#import "PageContentBlueViewController.h"

@interface ContainerBlueViewController ()

@end

@implementation ContainerBlueViewController
@synthesize parentController;
NSUInteger currentIndex;
int flag;
- (void)viewDidLoad {
    [super viewDidLoad];
    currentIndex = 0;
    flag = -1;
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    PageContentBlueViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

    // Do any additional setup after loading the view.
}
- (void)goToNextView{
    flag++;
    if(flag == [self.pageImages count]){
        return;
    }
    PageContentBlueViewController *startingViewController = [self viewControllerAtIndex:flag];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

-(void)goToPreviousView{
    if(flag == 0){
        return;
    }
    flag--;
    PageContentBlueViewController *startingViewController = [self viewControllerAtIndex:flag];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (PageContentBlueViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageImages count] == 0) || (index >= [self.pageImages count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    PageContentBlueViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentBlueViewController"];
    pageContentViewController.imageFile = [self.pageImages[index]objectForKey:@"Image"];
    pageContentViewController.desc = [self.pageImages[index]objectForKey:@"text"];
    pageContentViewController.year = [self.pageImages[index]objectForKey:@"year"];
    pageContentViewController.parent = parentController;
    if((index+1) != [self.pageImages count]){
        pageContentViewController.nextyear = [self.pageImages[index+1]objectForKey:@"year"];
    }
    else {
        pageContentViewController.nextyear = @"";
        
    }
    if(index != 0){
        pageContentViewController.previousyear = [self.pageImages[index-1]objectForKey:@"year"];
    }
    else{
        pageContentViewController.previousyear = @"";
    }
    flag = index;
    pageContentViewController.pageIndex = index;

        return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [((PageContentBlueViewController*) viewController) pageIndex];
    if (index == 0) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [((PageContentBlueViewController*) viewController) pageIndex];
    
    index++;
    
    if (index == [self.pageImages count]) {
        return nil;
    }
    

    return [self viewControllerAtIndex:index];
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

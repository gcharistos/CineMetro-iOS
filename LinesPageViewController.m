//
//  LinesPageViewController.m
//  CineMetro
//
//  Created by George Haristos on 29/11/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "LinesPageViewController.h"
#import "LinesCollectionViewController.h"
#import "RedDetailsViewController.h"
#import "BlueDetailsViewController.h"
#import "GreenDetailsViewController.h"





@interface LinesPageViewController ()
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation LinesPageViewController
NSUInteger currentIndex;
NSInteger  selectedIndex ;
NSArray *station;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

  
       // Do any additional setup after loading the view.
}

//Method goes to next page view
- (void)goToNextView{
    currentIndex = [[self.pageViewController.viewControllers lastObject] pageIndex];
    currentIndex++;
    if(currentIndex == [self.pageImages count]){
        return;
    }
    LinesCollectionViewController *startingViewController = [self viewControllerAtIndex:currentIndex];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

-(void)initializeView{
    currentIndex = 0;
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewControllerTimeline"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    LinesCollectionViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:_pageViewController.view];
}
//Method goes to previous page view
-(void)goToPreviousView{
    
    currentIndex = [[self.pageViewController.viewControllers lastObject] pageIndex];
    if(currentIndex == 0){
        return;
    }
    currentIndex--;
    LinesCollectionViewController *startingViewController = [self viewControllerAtIndex:currentIndex];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

-(void)setStationAndIndex:(NSInteger) index : (NSArray *)array{
    selectedIndex = index;
    station = array;
}


//Creates page view
- (LinesCollectionViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if ((index  == -1) || (index >= 3)) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    LinesCollectionViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LinesCollectionViewController"];
    pageContentViewController.pageIndex = index;
    pageContentViewController.parentcontroller = self;
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source
//method for previous page view
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    currentIndex = [((LinesCollectionViewController*) viewController) pageIndex];
    if (currentIndex == 0) {
        return nil;
    }
    currentIndex--;

    return [self viewControllerAtIndex:currentIndex];
}


//method for next page view
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    currentIndex = [((LinesCollectionViewController*) viewController) pageIndex];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"detailSegue3"]){
        RedDetailsViewController *dest = segue.destinationViewController;
        dest.station =[[NSDictionary alloc]initWithDictionary:[station objectAtIndex:selectedIndex]];
        dest.indexPath = selectedIndex;
    }
    else if([segue.identifier isEqualToString:@"detailSegue4"]){
        BlueDetailsViewController *dest = segue.destinationViewController;
        dest.position = selectedIndex;
        
    }
    else if([segue.identifier isEqualToString:@"detailSegue5"]){
        GreenDetailsViewController *dest = segue.destinationViewController;
        dest.station = [station objectAtIndex:selectedIndex];
        dest.indexPath = selectedIndex;
    }

}


@end

//
//  TutorialPageViewController.m
//  CineMetro
//
//  Created by George Haristos on 5/12/15.
//  Copyright (c) 2015 George Haristos. All rights reserved.
//

#import "TutorialPageViewController.h"
#import "TutorialContentViewController.h"

@interface TutorialPageViewController ()

@end
NSUInteger currentIndex;

@implementation TutorialPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentIndex = 0;
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewControllerTutorial"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    TutorialContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    [self.view addSubview:self.pageViewController.view];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Creates page view
- (TutorialContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if ((index  == -1) || (index >= 3)) {
               return nil;
    }
    // Create a new view controller and pass suitable data.
    TutorialContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialContentViewController"];
    pageContentViewController.pageIndex = index;
    pageContentViewController.imageFile = [NSString stringWithFormat:@"logo.png"];
    if(index == 0){
        pageContentViewController.tutorText =[NSString stringWithFormat:@"%@ \n\n %@",NSLocalizedString(@"navigationTitle",@"word"),NSLocalizedString(@"tapGestureMap",@"word")];
    }
    else if(index == 1){
        pageContentViewController.tutorText = [NSString stringWithFormat:@"%@ \n\n %@",NSLocalizedString(@"linesTitle",@"word"),NSLocalizedString(@"swipeLines",@"word")];
    }
    else if(index == 2){
        pageContentViewController.tutorText = [NSString stringWithFormat:@"** END OF TUTORIAL **"];
               

    }
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source
//method for previous page view
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    currentIndex = [((TutorialContentViewController*) viewController) pageIndex];
    
    if (currentIndex == 0) {
        return nil;
    }
    currentIndex--;
    
    return [self viewControllerAtIndex:currentIndex];
}


//method for next page view
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    currentIndex = [((TutorialContentViewController*) viewController) pageIndex];
    currentIndex++;
    if (currentIndex == 3) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"exitTutorial",@"word") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"yes",@"word") otherButtonTitles:NSLocalizedString(@"no",@"word"), nil];
        [alert performSelector:@selector(show) withObject:nil afterDelay:0];
        return nil;
    }
    
    
    
    return [self viewControllerAtIndex:currentIndex];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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

//
//  ContainerViewController.m
//  Perimeter
//
//  Created by Mark Suman on 4/6/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    self.dashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    self.checkpointsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckpointsViewController"];
    
    [self.pageViewController setViewControllers:@[self.dashboardViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
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

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index >= 2) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    UIViewController *viewController = nil;
    if (index == 0) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    }
    else if (index == 1) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckpointsViewController"];
    }
//    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
//    pageContentViewController.imageFile = self.pageImages[index];
//    pageContentViewController.titleText = self.pageTitles[index];
//    pageContentViewController.pageIndex = index;
    
    return viewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    return viewController == self.checkpointsViewController ? self.dashboardViewController : nil;
    
//    NSUInteger index = ((UIViewController *) viewController).pageIndex;
//    
//    if ((index == 0) || (index == NSNotFound)) {
//        return nil;
//    }
//    
//    index--;
//    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    return viewController == self.dashboardViewController ? self.checkpointsViewController : nil;

//    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
//    
//    if (index == NSNotFound) {
//        return nil;
//    }
//    
//    index++;
//    if (index == 2) {
//        return nil;
//    }
//    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end

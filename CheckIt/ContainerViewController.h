//
//  ContainerViewController.h
//  Perimeter
//
//  Created by Mark Suman on 4/6/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardViewController.h"

@interface ContainerViewController : UIViewController <UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) DashboardViewController *dashboardViewController;
@property (nonatomic, strong) UICollectionViewController *checkpointsViewController;

@end

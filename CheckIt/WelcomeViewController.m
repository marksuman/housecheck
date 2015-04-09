//
//  WelcomeViewController.m
//  Perimeter
//
//  Created by Mark Suman on 4/9/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:0.0 constant:0.0]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidLayoutSubviews {
//    CGRect frame = self.contentView.frame;
//    self.scrollView.contentSize = frame.size;
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    CGRect frame = self.contentView.frame;
//    self.scrollView.contentSize = frame.size;
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect frame = self.contentView.frame;
    self.scrollView.contentSize = frame.size;
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

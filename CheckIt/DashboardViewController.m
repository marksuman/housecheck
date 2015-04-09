//
//  DashboardViewController.m
//  Perimeter
//
//  Created by Mark Suman on 4/6/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import "DashboardViewController.h"
#import "CheckpointManager.h"
#import "WelcomeViewController.h"

@interface DashboardViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *statusImage;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.statusImage.image = [UIImage imageNamed:[self houseImageNameForPercentage:[[CheckpointManager defaultManager] percentageComplete]]];
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //    self.presentingViewController.providesPresentationContextTransitionStyle = YES;
    //    self.presentingViewController.definesPresentationContext = YES;
    //    self.presentedViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    WelcomeViewController *welcomeScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"WelcomeScreen"];
    [self presentViewController:welcomeScreen animated:NO completion:^{
        //
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSString *)houseImageNameForPercentage:(NSInteger)percentage {
    NSString *imageNameSuffix = @"0";
    if (percentage > 94	 && percentage <= 100) {
        imageNameSuffix = @"100";
    }
    else if (percentage > 81 && percentage <= 94) {
        imageNameSuffix = @"88";
    }
    else if (percentage > 69 && percentage <= 81) {
        imageNameSuffix = @"75";
    }
    else if (percentage > 56 && percentage <= 69) {
        imageNameSuffix = @"63";
    }
    else if (percentage > 44 && percentage <= 56) {
        imageNameSuffix = @"50";
    }
    else if (percentage > 31 && percentage <= 44) {
        imageNameSuffix = @"38";
    }
    else if (percentage > 18 && percentage <= 31) {
        imageNameSuffix = @"25";
    }
    else if (percentage > 0 && percentage <= 18) {
        imageNameSuffix = @"13";
    }
    else {
        imageNameSuffix = @"0";
    }
    
    return [NSString stringWithFormat:@"house-status-big-%@",imageNameSuffix];
}

@end

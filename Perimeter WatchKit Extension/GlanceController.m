//
//  GlanceController.m
//  Perimeter WatchKit Extension
//
//  Created by Mark Suman on 2/16/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import "GlanceController.h"
#import "CheckpointManager.h"

@interface GlanceController()

@property (nonatomic, weak) IBOutlet WKInterfaceGroup *bottomGroup;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *secondLabel;

@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    
    [CheckpointManager defaultManager];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    CheckpointManager *checkpointManager = [CheckpointManager defaultManager];
    
    UIImage *summaryImage = nil;
    NSString *summaryString = nil;
    NSString *timestampString = nil;
    
    NSInteger positiveCount = [checkpointManager countOfPositiveCheckpoints];
    
    if (checkpointManager.checkpoints.count > 0) {
        if ([checkpointManager isAllChecked]) {
            summaryImage = [UIImage imageNamed:@"house16"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = NSDateFormatterNoStyle;
            dateFormatter.timeStyle = NSDateFormatterShortStyle;
            timestampString = [NSString stringWithFormat:@"Checked: %@",[dateFormatter stringFromDate:[[CheckpointManager defaultManager] checkedDate]]];
        }
        else {
            summaryImage = [UIImage imageNamed:@"house1"];
            summaryString = [NSString stringWithFormat:@"%ld/%ld",positiveCount,
                             checkpointManager.checkpoints.count];
        }
    }
    else {
        // There are no checkpoints. Set it to first-run state
        summaryImage = [UIImage imageNamed:@"house1"];
        timestampString = @"Press to Start";
    }
    
    [self.bottomGroup setBackgroundImage:summaryImage];
    [self.secondLabel setText:summaryString];
//    [self.timestampLabel setText:timestampString];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end




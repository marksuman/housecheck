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
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *firstLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *secondLabel;

@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    
    // Doing this causes the checkpoints to be loaded
    [CheckpointManager defaultManager];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    CheckpointManager *checkpointManager = [CheckpointManager defaultManager];
    
    UIImage *summaryImage = nil;
    NSString *firstString = nil;
    NSString *secondString = nil;
    
    NSInteger positiveCount = [checkpointManager countOfPositiveCheckpoints];
    
    if (checkpointManager.checkpoints.count > 0) {
        if ([checkpointManager isAllChecked]) {
            summaryImage = [UIImage imageNamed:@"house-status-100"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = NSDateFormatterNoStyle;
            dateFormatter.timeStyle = NSDateFormatterShortStyle;
            firstString = @"Checked:";
            secondString = [dateFormatter stringFromDate:[[CheckpointManager defaultManager] checkedDate]];
        }
        else {
            summaryImage = [UIImage imageNamed:@"house-status-0"];
            secondString = [NSString stringWithFormat:@"%ld/%ld",positiveCount,
                             checkpointManager.checkpoints.count];
            firstString = @"House Status";
        }
    }
    else {
        // There are no checkpoints. Set it to first-run state
        summaryImage = [UIImage imageNamed:@"house-status-0"];
        firstString = @"House Status";
        secondString = @"Tap to get started";
    }
    
    [self.bottomGroup setBackgroundImage:summaryImage];
    [self.firstLabel setText:firstString];
    [self.secondLabel setText:secondString];
//    [self.timestampLabel setText:timestampString];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end




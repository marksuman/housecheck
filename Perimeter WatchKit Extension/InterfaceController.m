//
//  InterfaceController.m
//  Perimeter WatchKit Extension
//
//  Created by Mark Suman on 2/16/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import "InterfaceController.h"
#import "CheckpointInterfaceController.h"
#import "CheckpointManager.h"

@interface InterfaceController()

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *summaryLabel;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    if ([[context objectForKey:@"skipReload"] boolValue]) {
        // We reloaded the order of the pages already and this is just being displayed for reals now
        // Go ahead and set it up
        
        [self setTitle:@"Sleep Safe"];
        [self updateInterfaceElements];
    }
    else {
        NSMutableArray *rootControllerNames = [NSMutableArray array];
        NSMutableArray *contexts = [NSMutableArray array];
        
        // Add the Dashboard controller
        [rootControllerNames addObject:@"Dashboard"];
        [contexts addObject:@{@"skipReload":[NSNumber numberWithBool:YES]}];
        
        for (Checkpoint *checkpoint in [[CheckpointManager defaultManager] checkpoints]) {
                // Add a Checkpoint interface with the index appended to it
            [rootControllerNames addObject:[NSString stringWithFormat:@"Checkpoint"]];
            [contexts addObject:checkpoint];
        }
        // This is the first run. We want to set up the correct order of the pages
        [WKInterfaceController reloadRootControllersWithNames:rootControllerNames contexts:contexts];
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self updateInterfaceElements];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)updateInterfaceElements {
    CheckpointManager *checkpointManager = [CheckpointManager defaultManager];
    
    [self.summaryLabel setText:[NSString stringWithFormat:@"%ld/%ld",[checkpointManager countOfPositiveCheckpoints],checkpointManager.checkpoints.count]];
}

- (IBAction)addCheckpointMenuItemTapped:(id)sender {
    
}

@end




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

@property (nonatomic, weak) IBOutlet WKInterfaceImage *summaryImage;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *summaryLabel;
@property (nonatomic, strong) NSMutableArray *rootControllerNames;
@property (nonatomic, strong) NSMutableArray *rootControllerContexts;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    if ([[context objectForKey:@"skipReload"] boolValue]) {
        // We reloaded the order of the pages already and this is just being displayed for reals now
        // Go ahead and set it up
        
        self.rootControllerNames = [context objectForKey:@"rootControllerNames"];
        self.rootControllerContexts = [context objectForKey:@"rootControllerContexts"];
        
        [self setTitle:@"HomeCheck"];
        [self updateInterfaceElements];
    }
    else {
        self.rootControllerNames = [NSMutableArray array];
        self.rootControllerContexts = [NSMutableArray array];
        
        // Add the Dashboard controller
        [self.rootControllerNames addObject:@"Dashboard"];
        [self.rootControllerContexts addObject:@{@"skipReload":[NSNumber numberWithBool:YES],@"rootControllerNames":self.rootControllerNames,@"rootControllerContexts":self.rootControllerContexts}];
        
        for (Checkpoint *checkpoint in [[CheckpointManager defaultManager] checkpoints]) {
                // Add a Checkpoint interface with the index appended to it
            [self addInterfaceForCheckpoint:checkpoint];
        }
        // This is the first run. We want to set up the correct order of the pages
        [WKInterfaceController reloadRootControllersWithNames:self.rootControllerNames contexts:self.rootControllerContexts];
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
    
    // Check if there are more checkpoints than there are checkpoint interfaces. If so, add new interfaces for the checkpoints.
    // Subtract 1 because the first context is for the Dashboard, which throws off the count here.
    BOOL shouldReloadInterfaceControllers = NO;
    if (self.rootControllerContexts.count - 1 < checkpointManager.checkpoints.count) {
        for (Checkpoint *checkpoint in checkpointManager.checkpoints) {
            // Build a temporary array of the checkpoints that created the interface controllers
            NSMutableArray *rootControllerCheckpoints = [NSMutableArray arrayWithCapacity:self.rootControllerContexts.count -1];
            for (NSInteger i=1; i<self.rootControllerContexts.count; i++ ) {
                NSMutableDictionary *context = [self.rootControllerContexts objectAtIndex:i];
                [rootControllerCheckpoints addObject:[context objectForKey:@"checkpoint"]];
                
                // Clear out any stale becomeCurrent flags
                if ([[context objectForKey:@"becomeCurrent"] boolValue]) {
                    [context removeObjectForKey:@"becomeCurrent"];
                }
            }
            
            // Use that temporary array and check if it containts the checkpoint in question
            if ([rootControllerCheckpoints containsObject:checkpoint] == NO) {
                // This one is new. Add it to the rootController arrays. Flag for reload.
                [self addInterfaceForCheckpoint:checkpoint];
                shouldReloadInterfaceControllers = YES;
                
                // We only allow for adding one at a time right now, so go ahead and break the loop
                // (Currently this should already be the last item in the array, so this break isn't totally necessary.)
                break;
            }
            else {
                continue;
            }
        }
    }
    
    // If we have added something new, reload the root controllers
    if (shouldReloadInterfaceControllers) {
        [self reloadRootInterfaceControllers];
    }
    else {
        // Nothing was new, so go ahead and update the current screen
        
        UIImage *summaryImage = nil;
        NSString *summaryString = nil;
        NSInteger positiveCount = [checkpointManager countOfPositiveCheckpoints];
        if (positiveCount == checkpointManager.checkpoints.count) {
            summaryImage = [UIImage imageNamed:@"House-Checked"];
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = NSDateFormatterNoStyle;
            dateFormatter.timeStyle = NSDateFormatterShortStyle;
#warning This date should be changed to show the timestamp of when the checkpoints were completed
            summaryString = [NSString stringWithFormat:@"Checked: %@",[dateFormatter stringFromDate:[NSDate date]]];
        }
        else {
            summaryImage = [UIImage imageNamed:@"House"];
            summaryString = [NSString stringWithFormat:@"%ld/%ld",positiveCount,
                             checkpointManager.checkpoints.count];
        }
        
        [self.summaryImage setImage:summaryImage];
        [self.summaryLabel setText:summaryString];
    }
}

- (void)addInterfaceForCheckpoint:(Checkpoint *)checkpoint {
    [self.rootControllerNames addObject:[NSString stringWithFormat:@"Checkpoint"]];
    void (^deleteAndReloadInterfaceBlock)() = ^() {
        [self deleteInterfaceForCheckpoint:checkpoint];
        [self reloadRootInterfaceControllers];
    };
    NSMutableDictionary *contextDictionary = [NSMutableDictionary dictionaryWithObjects:@[checkpoint,deleteAndReloadInterfaceBlock] forKeys:@[@"checkpoint",@"deleteAndReloadInterfaceBlock"]];
    [self.rootControllerContexts addObject:contextDictionary];
}

- (IBAction)addCheckpointMenuItemTapped:(id)sender {
    [self presentControllerWithNames:@[@"AddCheckpoint",@"AddCheckpoint"] contexts:@[@{@"type":CheckpointTypeDoor},@{@"type":CheckpointTypeLight}]];
}

- (void)reloadRootInterfaceControllers {
    [WKInterfaceController reloadRootControllersWithNames:self.rootControllerNames contexts:self.rootControllerContexts];
}

- (void)deleteInterfaceForCheckpoint:(Checkpoint *)checkpoint {
    // Find the CheckpointInterfaceController with this checkpoint
    // Using that index, remove the interface controller name
    // and the interface controller context from the arrays
    
    // We can use 0 as an index because that is the dashboard index
    NSInteger deletionIndex = 0;
    
    for (NSInteger i=1; i<self.rootControllerContexts.count; i++ ) {
        NSMutableDictionary *context = [self.rootControllerContexts objectAtIndex:i];
        if (checkpoint == [context objectForKey:@"checkpoint"]) {
            deletionIndex = i;
            break;
        }
    }
    
    // Delete that index from the arrays
    if (deletionIndex > 0) {
        [self.rootControllerNames removeObjectAtIndex:deletionIndex];
        [self.rootControllerContexts removeObjectAtIndex:deletionIndex];
    }
}

@end




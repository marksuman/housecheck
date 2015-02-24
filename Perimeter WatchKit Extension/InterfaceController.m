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
        
        [self setTitle:@"Sleep Safe"];
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
            [self.rootControllerNames addObject:[NSString stringWithFormat:@"Checkpoint"]];
            [self.rootControllerContexts addObject:@{@"checkpoint":checkpoint}];
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
    
    BOOL shouldReloadInterfaceControllers = NO;
    // Check if there are more checkpoints than there are checkpoint interfaces. If so, add new interfaces for the checkpoints.
    // Subtract 1 because the first context is for the Dashboard, which throws off the count here.
    if (self.rootControllerContexts.count - 1 < checkpointManager.checkpoints.count) {
        for (Checkpoint *checkpoint in checkpointManager.checkpoints) {
            NSMutableArray *rootControllerCheckpoints = [NSMutableArray arrayWithCapacity:self.rootControllerContexts.count -1];
            for (NSInteger i=1; i<self.rootControllerContexts.count; i++ ) {
                [rootControllerCheckpoints addObject:[[self.rootControllerContexts objectAtIndex:i] objectForKey:@"checkpoint"]];
            }
            
            if ([rootControllerCheckpoints containsObject:checkpoint] == NO) {
                // This one is new. Add it to the rootController arrays. Flag for reload.
                [self.rootControllerNames addObject:@"Checkpoint"];
                [self.rootControllerContexts addObject:@{@"checkpoint":checkpoint,@"becomeCurrent":[NSNumber numberWithBool:YES]}];
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
        [WKInterfaceController reloadRootControllersWithNames:self.rootControllerNames contexts:self.rootControllerContexts];
    }
    else {
        // Nothing was new, so go ahead and update the current screen
        [self.summaryLabel setText:[NSString stringWithFormat:@"%ld/%ld",[checkpointManager countOfPositiveCheckpoints],
                                    checkpointManager.checkpoints.count]];
    }
}

- (IBAction)addCheckpointMenuItemTapped:(id)sender {
    [self presentControllerWithNames:@[@"AddBeginning",@"AddCheckpoint"] contexts:@[@"",@{@"type":CheckpointTypeDoor}]];
}

@end




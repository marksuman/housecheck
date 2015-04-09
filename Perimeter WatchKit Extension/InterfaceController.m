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

//@property (nonatomic, weak) IBOutlet WKInterfaceImage *summaryImage;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *summaryLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *timestampLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceGroup *summaryGroup;

@property (nonatomic, strong) id dashboardContext;
@property (nonatomic, strong) NSMutableArray *checkpointRootControllerContexts;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    if ([[context objectForKey:@"skipReload"] boolValue]) {
        // We reloaded the order of the pages already and this is just being displayed for reals now
        // Go ahead and set it up
        
        self.dashboardContext = context;
        self.checkpointRootControllerContexts = [context objectForKey:@"checkpointRootControllerContexts"];
        
        [self setTitle:@"HouseCheck"];
        [self updateInterfaceElements];
    }
    else {
        self.checkpointRootControllerContexts = [NSMutableArray array];
        
        // Set the dashboardContext so it is available when we reload the interface controllers
        self.dashboardContext = @{@"skipReload":[NSNumber numberWithBool:YES],@"checkpointRootControllerContexts":self.checkpointRootControllerContexts};
        
        for (Checkpoint *checkpoint in [[CheckpointManager defaultManager] checkpoints]) {
                // Add a Checkpoint interface for each checkpoint
            [self addInterfaceForCheckpoint:checkpoint];
        }
        // This is the first run. We want to set up the correct order of the pages
        [self reloadRootInterfaceControllers];
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

- (void)handleUserActivity:(NSDictionary *)userInfo {
    NSString *userActivityAction = [userInfo objectForKey:@"action"];
    if ([userActivityAction isEqualToString:@"setup"]) {
        // Take them to the Add Checkpoint screen
        [self displayAddCheckpointScreensSetup:YES];
    }
}

- (NSArray *)rootControllerNamesArray {
    // Build the names array. Add a Checkpoint interface identifier for each checkpoint
    NSMutableArray *names = [NSMutableArray array];
    [names addObject:@"Dashboard"];
    for (NSInteger i=0; i < self.checkpointRootControllerContexts.count; i++) {
        [names addObject:@"Checkpoint"];
    }
    
    // Due to a bug in iOS 8.2 Beta 5, we need to add a dummy page if there are no checkpoint pages
    // See https://devforums.apple.com/message/1098680#1098680
    // and see rdar://19695492
    if (names.count < 2) {
//        [names addObject:@"Radar"];
    }
    return names;
}

- (NSArray *)rootControllerContextsArray {
    // Build the contexts array. Insert the dashboard context first, then add one for each checkpoint
    NSMutableArray *contexts = [NSMutableArray array];
    [contexts addObject:self.dashboardContext];
    [contexts addObjectsFromArray:self.checkpointRootControllerContexts];
    return contexts;
}

- (void)updateInterfaceElements {
    CheckpointManager *checkpointManager = [CheckpointManager defaultManager];
    
    // Check if there are more checkpoints than there are checkpoint interfaces. If so, add new interfaces for the checkpoints.
    BOOL shouldReloadInterfaceControllers = NO;
    if (self.checkpointRootControllerContexts.count < checkpointManager.checkpoints.count) {
        for (Checkpoint *checkpoint in checkpointManager.checkpoints) {
            // Build a temporary array of the checkpoints that created the interface controllers
            NSMutableArray *rootControllerCheckpoints = [NSMutableArray arrayWithCapacity:self.checkpointRootControllerContexts.count];
            for (NSInteger i=0; i<self.checkpointRootControllerContexts.count; i++ ) {
                NSMutableDictionary *context = [self.checkpointRootControllerContexts objectAtIndex:i];
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
        NSString *timestampString = @" ";
        
        NSInteger positiveCount = [checkpointManager countOfPositiveCheckpoints];
        
        if (checkpointManager.checkpoints.count > 0) {
            if ([checkpointManager isAllChecked]) {
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateStyle = NSDateFormatterNoStyle;
                dateFormatter.timeStyle = NSDateFormatterShortStyle;
                timestampString = [NSString stringWithFormat:@"Checked: %@",[dateFormatter stringFromDate:[[CheckpointManager defaultManager] checkedDate]]];
            }
            else {
                summaryString = [NSString stringWithFormat:@"%ld/%ld",positiveCount,
                                 checkpointManager.checkpoints.count];
            }
        }
        else {
            // There are no checkpoints. Set it to first-run state
            timestampString = @"Press to Start";
        }
        
        NSString *houseStatusImageName = [self houseImageNameForPercentage:[[CheckpointManager defaultManager] percentageComplete]];
        summaryImage = [UIImage imageNamed:houseStatusImageName];
        
        [self.summaryGroup setBackgroundImage:summaryImage];
        [self.summaryLabel setText:summaryString];
        [self.timestampLabel setText:timestampString];
    }
}

- (void)addInterfaceForCheckpoint:(Checkpoint *)checkpoint {
    void (^deleteAndReloadInterfaceBlock)() = ^() {
        [self deleteInterfaceForCheckpoint:checkpoint];
        [self reloadRootInterfaceControllers];
    };
    NSMutableDictionary *contextDictionary = [NSMutableDictionary dictionaryWithObjects:@[checkpoint,deleteAndReloadInterfaceBlock] forKeys:@[@"checkpoint",@"deleteAndReloadInterfaceBlock"]];
    [self.checkpointRootControllerContexts addObject:contextDictionary];
}

- (IBAction)addCheckpointMenuItemTapped:(id)sender {
    [self displayAddCheckpointScreensSetup:NO];
}

- (void)reloadRootInterfaceControllers {
    [WKInterfaceController reloadRootControllersWithNames:[self rootControllerNamesArray] contexts:[self rootControllerContextsArray]];
}

- (void)deleteInterfaceForCheckpoint:(Checkpoint *)checkpoint {
    // Find the CheckpointInterfaceController with this checkpoint
    // Remove the interface controller name
    // and the interface controller context from the arrays
    
    for (NSInteger i=0; i<self.checkpointRootControllerContexts.count; i++ ) {
        NSMutableDictionary *context = [self.checkpointRootControllerContexts objectAtIndex:i];
        if (checkpoint == [context objectForKey:@"checkpoint"]) {
            [self.checkpointRootControllerContexts removeObjectAtIndex:i];
            break;
        }
    }
}

- (void)displayAddCheckpointScreensSetup:(BOOL)setup {
    if (setup) {
        [self presentControllerWithNames:@[@"Setup",@"AddCheckpoint",@"AddCheckpoint",@"AddCheckpoint",@"AddCheckpoint",@"AddCheckpoint",@"AddCheckpoint",@"AddCheckpoint"] contexts:@[@{@"type":@"setup"},@{@"type":CheckpointTypeDoor},@{@"type":CheckpointTypeLight},@{@"type":CheckpointTypeWindow},@{@"type":CheckpointTypeAppliance},@{@"type":CheckpointTypeFamily},@{@"type":CheckpointTypePet},@{@"type":CheckpointTypeUnknown}]];
    }
    else {
        [self presentControllerWithNames:@[@"AddCheckpoint",@"AddCheckpoint",@"AddCheckpoint",@"AddCheckpoint",@"AddCheckpoint",@"AddCheckpoint",@"AddCheckpoint"] contexts:@[@{@"type":CheckpointTypeDoor},@{@"type":CheckpointTypeLight},@{@"type":CheckpointTypeWindow},@{@"type":CheckpointTypeAppliance},@{@"type":CheckpointTypeFamily},@{@"type":CheckpointTypePet},@{@"type":CheckpointTypeUnknown}]];
    }
}

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
    
    return [NSString stringWithFormat:@"house-status-%@",imageNameSuffix];
}

@end




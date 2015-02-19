//
//  InterfaceController.m
//  Perimeter WatchKit Extension
//
//  Created by Mark Suman on 2/16/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import "InterfaceController.h"
#import "CheckpointInterfaceController.h"

@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    Checkpoint *frontDoor = [[Checkpoint alloc] init];
    frontDoor.name = @"Front Door";
    frontDoor.type = CheckpointTypeDoor;
    
    Checkpoint *garageDoor = [[Checkpoint alloc] init];
    garageDoor.name = @"Garage Door";
    garageDoor.type = CheckpointTypeDoor;
    
    Checkpoint *porchLights = [[Checkpoint alloc] init];
    porchLights.name = @"Porch Lights";
    porchLights.type = CheckpointTypeLight;

    // Configure interface objects here.
    if ([[context objectForKey:@"skipReload"] boolValue]) {
        // We reloaded the order of the pages already and this is just being displayed for reals now
    }
    else {
        // This is the first run. We want to set up the correct order of the pages
        [WKInterfaceController reloadRootControllersWithNames:@[@"Home",@"Checkpoint1",@"Checkpoint2",@"Checkpoint3"] contexts:@[@{@"skipReload":[NSNumber numberWithBool:YES]},frontDoor,porchLights,garageDoor]];
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end




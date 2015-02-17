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
    frontDoor.info = [NSMutableDictionary dictionaryWithDictionary:@{@"name":@"Front Door"}];

    // Configure interface objects here.
    [WKInterfaceController reloadRootControllersWithNames:@[@"door1"] contexts:@[frontDoor]]
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




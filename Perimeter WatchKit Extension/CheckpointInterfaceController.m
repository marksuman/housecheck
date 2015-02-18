//
//  CheckpointInterfaceController.m
//  CheckIt
//
//  Created by Mark Suman on 2/17/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import "CheckpointInterfaceController.h"


@interface CheckpointInterfaceController()

@end


@implementation CheckpointInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    
    self.checkpoint = (Checkpoint *)context;
    
    if (self.checkpoint) {
        [self setTitle:[self.checkpoint.info objectForKey:@"name"]];
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




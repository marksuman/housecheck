//
//  CheckpointInterfaceController.m
//  CheckIt
//
//  Created by Mark Suman on 2/17/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import "CheckpointInterfaceController.h"


@interface CheckpointInterfaceController()

@property (nonatomic, weak) IBOutlet WKInterfaceImage *typeImage;
@property (nonatomic, weak) IBOutlet WKInterfaceImage *statusImage;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *statusLabel;

@end


@implementation CheckpointInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    
    self.checkpoint = (Checkpoint *)context;
    
    if (self.checkpoint) {
        [self updateInterfaceElements];
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

- (void)updateInterfaceElements {
    [self setTitle:self.checkpoint.statusString];
    [self.typeImage setImage:[UIImage imageNamed:[Checkpoint imageNameForCheckpointType:self.checkpoint.type]]];
    [self.statusImage setImage:[UIImage imageNamed:[self statusImageNameForCheckpoint:self.checkpoint]]];
    [self.statusLabel setText:self.checkpoint.name];
}

- (IBAction)buttonAction:(id)sender {
    [self.checkpoint toggleStatus];
    [self updateInterfaceElements];
}

- (NSString *)statusImageNameForCheckpoint:(Checkpoint *)checkpoint {
    if (checkpoint.isStatusPositive) {
        return [self positiveStatusImageNameForCheckpoint:checkpoint];
    }
    else if (checkpoint.isStatusNegative) {
        return [self negativeStatusImageNameForCheckpoint:checkpoint];
    }
    else {
        return @"circle-questionmark";
    }
}

- (NSString *)positiveStatusImageNameForCheckpoint:(Checkpoint *)checkpoint {
    // If we want, we could customize the positive image based on checkpoint type
    // For now we'll just show a default
    return @"19-circle-check";
}

- (NSString *)negativeStatusImageNameForCheckpoint:(Checkpoint *)checkpoint {
    // If we want, we could customize the negative image based on checkpoint type
    // For now we'll just show a default
    return @"circle-x";
}

@end




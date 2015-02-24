//
//  AddCheckpointInterfaceController.m
//  CheckIt
//
//  Created by Mark Suman on 2/21/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import "AddCheckpointInterfaceController.h"
#import "CheckpointManager.h"

@interface AddCheckpointInterfaceController()

@property (nonatomic, weak) IBOutlet WKInterfaceImage *typeImage;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *typeLabel;
@property (nonatomic, weak) NSString *type;

@end


@implementation AddCheckpointInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    self.type = [context objectForKey:@"type"];
    [self.typeImage setImage:[UIImage imageNamed:[Checkpoint imageNameForCheckpointType:self.type]]];
    [self.typeLabel setText:@"Door"];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)tappedInterface:(id)sender {
    Checkpoint *checkpoint = [[Checkpoint alloc] init];
    checkpoint.name = @"My Door";
    checkpoint.type = self.type;
    
    [[CheckpointManager defaultManager] addCheckpoint:checkpoint];
    [self dismissController];
}

@end




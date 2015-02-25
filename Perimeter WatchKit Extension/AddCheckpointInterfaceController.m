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
    [self.typeLabel setText:[Checkpoint typeStringForCheckpointType:self.type]];
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
    // Prompt the user to pick a name for the checkpoint
    [self presentTextInputControllerWithSuggestions:[Checkpoint nameSuggestionsForCheckpointType:self.type] allowedInputMode:WKTextInputModePlain completion:^(NSArray *results) {
        
        // If there is a name, create a checkpoint and dismiss the modal
        if (results && results.count > 0) {
            Checkpoint *checkpoint = [[Checkpoint alloc] init];
            checkpoint.name = [results objectAtIndex:0];
            checkpoint.type = self.type;
            
            [[CheckpointManager defaultManager] addCheckpoint:checkpoint];
            [self dismissController];
        }
        
        // The user canceled the text input, so do nothing
    }];
}

@end




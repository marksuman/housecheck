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
@property (nonatomic) BOOL becomeCurrent;

@end


@implementation CheckpointInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    
    self.checkpoint = (Checkpoint *)[context objectForKey:@"checkpoint"];
    self.becomeCurrent = [[context objectForKey:@"becomeCurrent"] boolValue];
    
    if (self.checkpoint) {
        [self updateInterfaceElements];
        if (self.becomeCurrent) {
            [self becomeCurrentPage];
            self.becomeCurrent = NO;
        }
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
    [self setTitle:self.checkpoint.statusString];
    [self.typeImage setImage:[UIImage imageNamed:[Checkpoint imageNameForCheckpointType:self.checkpoint.type]]];
    [self.statusImage setImage:[UIImage imageNamed:[self statusImageNameForCheckpoint:self.checkpoint]]];
    [self.statusLabel setText:self.checkpoint.name];
}

#pragma mark - IBAction

- (IBAction)buttonAction:(id)sender {
    [self.checkpoint toggleStatus];
    [self updateInterfaceElements];
}

- (IBAction)renameMenuItemTapped:(id)sender {
    // Prompt the user to pick a name for the checkpoint
    [self presentTextInputControllerWithSuggestions:[Checkpoint nameSuggestionsForCheckpointType:self.checkpoint.type] allowedInputMode:WKTextInputModePlain completion:^(NSArray *results) {
        
        // If there is a name, create a checkpoint and dismiss the modal
        if (results && results.count > 0) {
            self.checkpoint.name = [results objectAtIndex:0];
            
            [self updateInterfaceElements];
        }
        
        // The user canceled the text input, so do nothing
    }];
}

- (IBAction)deleteMenuItemTapped:(id)sender {
    
}


#pragma mark - Interface methods

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




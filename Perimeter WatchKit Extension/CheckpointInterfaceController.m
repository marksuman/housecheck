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
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *statusLabel;

@end


@implementation CheckpointInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    
    self.checkpoint = (Checkpoint *)context;
    
    if (self.checkpoint) {
        [self setTitle:self.checkpoint.name];
        [self.typeImage setImage:[self image]];
        [self.statusLabel setText:self.checkpoint.statusString];
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

- (UIImage *)image {
    NSParameterAssert(self.checkpoint);
    
    UIImage *image = nil;
    if ([self.checkpoint.type isEqualToString:CheckpointTypeDoor]) {
        image = [UIImage imageNamed:@"179-notepad"];
    }
    else if ([self.checkpoint.type isEqualToString:CheckpointTypeLight]) {
        image = [UIImage imageNamed:@"84-lightbulb"];
    }
    
    return image;
}

@end




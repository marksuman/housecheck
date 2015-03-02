//
//  Checkpoint.m
//  CheckIt
//
//  Created by Mark Suman on 2/17/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import "Checkpoint.h"
#import "CheckpointManager.h"

@implementation Checkpoint

// Type constants
NSString * const CheckpointTypeUnknown = @"unknown";
NSString * const CheckpointTypeDoor = @"door";
NSString * const CheckpointTypeLight = @"light";

// Status constants
NSString * const CheckpointStatusUnknown = @"unknown";
NSString * const CheckpointStatusPositive = @"positive";
NSString * const CheckpointStatusNegative = @"negative";

- (id)init {
    self = [super init];
    
    if (self) {
        self.type = CheckpointTypeUnknown;
        self.status = CheckpointStatusUnknown;
        self.lastStatusDate = nil;
    }
    
    return self;
}

- (NSString *)status {
    // The status is self-healing
    // It checks to see if it is stale. If it is, it resets itself and sends you the reset status
    if (self.lastStatusDate) {
        NSTimeInterval statusLife = [[NSDate date] timeIntervalSinceDate:self.lastStatusDate];
        if (statusLife >= [[CheckpointManager defaultManager] eventTTL]) {
            [self resetStatus];
        }
    }
    
    return _status;
}

- (BOOL)isTypeDoor {
    return [self.type isEqualToString:CheckpointTypeDoor];
}

- (BOOL)isTypeLight {
    return [self.type isEqualToString:CheckpointTypeLight];
}

- (BOOL)isStatusPositive {
    return [self.status isEqualToString:CheckpointStatusPositive];
}

- (BOOL)isStatusNegative {
    return [self.status isEqualToString:CheckpointStatusNegative];
}


- (NSString *)statusString {
    // This should be overriden by subclass
    NSString *statusString = @"Not Checked";
    
    if ([self.status isEqualToString:CheckpointStatusPositive]) {
        if ([self.type isEqualToString:CheckpointTypeDoor]) {
            statusString = @"Locked";
        }
        else if ([self.type isEqualToString:CheckpointTypeLight]) {
            statusString = @"Light Off";
        }
        else {
            statusString = @"Good";
        }
    }
    else if ([self.status isEqualToString:CheckpointStatusNegative]) {
        if ([self.type isEqualToString:CheckpointTypeDoor]) {
            statusString = @"Unlocked";
        }
        else if ([self.type isEqualToString:CheckpointTypeLight]) {
            statusString = @"Light On";
        }
        else {
            statusString = @"Bad";
        }
    }
    return statusString;
}

- (void)toggleStatus {
    // Move the status to the next one
    // Unknown -> Positive -> Negative
    if (self.isStatusPositive) {
        self.status = CheckpointStatusNegative;
    }
    else if (self.isStatusNegative) {
        self.status = CheckpointStatusUnknown;
    }
    else {
        // The status is currently unknown
        self.status = CheckpointStatusPositive;
    }
    
    // Update the lastStatusDate
    self.lastStatusDate = [NSDate date];
}

- (void)resetStatus {
    // This method should usually be called when a status is read and it has passed the eventTTL
    
    // Reset the status and the lastStatusDate
    self.status = CheckpointStatusUnknown;
    self.lastStatusDate = nil;
}


#pragma mark - Interface Variants
+ (NSString *)imageNameForCheckpointType:(NSString *)checkpointType {
    if ([checkpointType isEqualToString:CheckpointTypeDoor]) {
        return @"179-notepad";
    }
    else if ([checkpointType isEqualToString:CheckpointTypeLight]) {
        return @"84-lightbulb";
    }
    
    return nil;
}

+ (NSString *)typeStringForCheckpointType:(NSString *)checkpointType {
    if ([checkpointType isEqualToString:CheckpointTypeDoor]) {
        return @"Door";
    }
    else if ([checkpointType isEqualToString:CheckpointTypeLight]) {
        return @"Light";
    }
    
    return @"Other";
}

+ (NSArray *)nameSuggestionsForCheckpointType:(NSString *)checkpointType {
    NSArray *nameArray = @[];
    if ([checkpointType isEqualToString:CheckpointTypeDoor]) {
        nameArray = @[@"Front Door",@"Back Door",@"Garage Door",@"Side Door",@"Pet Door"];
    }
    else if ([checkpointType isEqualToString:CheckpointTypeLight]) {
        nameArray = @[@"Front Porch",@"Back Porch",@"Front Yard",@"Backyard",@"Downstairs",@"Upstairs"];
    }
    
    return nameArray;
}

@end

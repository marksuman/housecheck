//
//  Checkpoint.m
//  CheckIt
//
//  Created by Mark Suman on 2/17/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import "Checkpoint.h"

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
    }
    
    return self;
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
    NSString *statusString = @"---";
    
    if ([self.status isEqualToString:CheckpointStatusPositive]) {
        statusString = @"Good";
    }
    else if ([self.status isEqualToString:CheckpointStatusNegative]) {
        statusString = @"Bad";
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
}

@end

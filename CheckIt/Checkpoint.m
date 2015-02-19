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

- (NSString *)statusString {
    // This should be overriden by subclass
    NSString *statusString = @"Unchecked";
    
    if ([self.status isEqualToString:CheckpointStatusPositive]) {
        statusString = @"Positive";
    }
    else if ([self.status isEqualToString:CheckpointStatusNegative]) {
        statusString = @"Negative";
    }
    return statusString;
}

@end

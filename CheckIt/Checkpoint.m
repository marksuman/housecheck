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
NSString * const CheckpointTypeWindow = @"window";
NSString * const CheckpointTypeAppliance = @"appliance";
NSString * const CheckpointTypeFamily = @"family";
NSString * const CheckpointTypePet = @"pet";

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

- (id)initWithInfo:(NSDictionary *)info {
    self = [super init];
    
    if (self) {
        self.name = [info objectForKey:@"name"];
        self.type = [info objectForKey:@"type"];
        self.status = [info objectForKey:@"status"];
        self.lastStatusDate = [info objectForKey:@"lastStatusDate"];
    }
    
    return self;
}

- (NSDictionary *)dictionaryVersion {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if (self.name) {
        [dictionary setObject:self.name forKey:@"name"];
    }
    
    [dictionary setObject:self.type forKey:@"type"];
    [dictionary setObject:self.status forKey:@"status"];
    
    if (self.lastStatusDate) {
        [dictionary setObject:self.lastStatusDate forKey:@"lastStatusDate"];
    }
    
    return dictionary;
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
        else if ([self.type isEqualToString:CheckpointTypeWindow]) {
            statusString = @"Closed";
        }
        else if ([self.type isEqualToString:CheckpointTypeAppliance]) {
            statusString = @"Off";
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
        else if ([self.type isEqualToString:CheckpointTypeWindow]) {
            statusString = @"Open";
        }
        else if ([self.type isEqualToString:CheckpointTypeAppliance]) {
            statusString = @"On";
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
        return @"add-door";
    }
    else if ([checkpointType isEqualToString:CheckpointTypeLight]) {
        return @"add-light";
    }
    else if ([checkpointType isEqualToString:CheckpointTypeWindow]) {
        return @"add-window";
    }
    else if ([checkpointType isEqualToString:CheckpointTypeAppliance]) {
        return @"add-appliance";
    }
    else if ([checkpointType isEqualToString:CheckpointTypeFamily]) {
        return @"add-family";
    }
    else if ([checkpointType isEqualToString:CheckpointTypePet]) {
        return @"add-pet1";
    }
    
    return @"Other";
}

+ (NSString *)typeStringForCheckpointType:(NSString *)checkpointType {
    if ([checkpointType isEqualToString:CheckpointTypeDoor]) {
        return @"Door";
    }
    else if ([checkpointType isEqualToString:CheckpointTypeLight]) {
        return @"Light";
    }
    else if ([checkpointType isEqualToString:CheckpointTypeWindow]) {
        return @"Window";
    }
    else if ([checkpointType isEqualToString:CheckpointTypeAppliance]) {
        return @"Appliance";
    }
    else if ([checkpointType isEqualToString:CheckpointTypeFamily]) {
        return @"Family";
    }
    else if ([checkpointType isEqualToString:CheckpointTypePet]) {
        return @"Pet";
    }
    
    return @"Other";
}

+ (NSArray *)nameSuggestionsForCheckpointType:(NSString *)checkpointType {
    NSArray *nameArray = @[];
    if ([checkpointType isEqualToString:CheckpointTypeDoor]) {
        nameArray = @[@"Front Door",@"Back Door",@"Garage Door",@"Side Door",@"Pet Door",@"Gate"];
    }
    else if ([checkpointType isEqualToString:CheckpointTypeLight]) {
        nameArray = @[@"Front Porch",@"Back Porch",@"Front Yard",@"Backyard",@"Downstairs",@"Upstairs"];
    }
    else if ([checkpointType isEqualToString:CheckpointTypeWindow]) {
        nameArray = @[@"Front",@"Back",@"Bedroom",@"Downstairs",@"Upstairs",@"Basement"];
    }
    else if ([checkpointType isEqualToString:CheckpointTypeAppliance]) {
        nameArray = @[@"Oven",@"Stove",@"Space Heater",@"Grill",@"Fireplace",@"Coffee Maker"];
    }
    else if ([checkpointType isEqualToString:CheckpointTypeFamily]) {
        nameArray = @[@"Baby",@"Daughter",@"Son",@"Parent"];
    }
    else if ([checkpointType isEqualToString:CheckpointTypePet]) {
        nameArray = @[@"Cat",@"Dog",@"Hamster",@"Free-tailed Bat",@"Chinchilla"];
    }
    else {
        nameArray = @[@"Security System",@"Thermostat",@"Alarm Clock",@"Flat Iron",@"Curling Iron"];
    }
    
    return nameArray;
}

@end

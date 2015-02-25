//
//  CheckpointManager.m
//  CheckIt
//
//  Created by Mark Suman on 2/21/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import "CheckpointManager.h"

static CheckpointManager *defaultManager;

@implementation CheckpointManager

+ (CheckpointManager *)defaultManager {
    if (defaultManager == nil) {
        defaultManager = [[CheckpointManager alloc] init];
    }
    
    return defaultManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.checkpoints = [NSMutableArray array];
        [self loadCheckpoints];
    }
    
    return self;
}

- (void)loadCheckpoints {
    
    // ---------
    // TEST DATA
    // ---------
    Checkpoint *frontDoor = [[Checkpoint alloc] init];
    frontDoor.name = @"Front Door";
    frontDoor.type = CheckpointTypeDoor;
    
    Checkpoint *garageDoor = [[Checkpoint alloc] init];
    garageDoor.name = @"Garage Door";
    garageDoor.type = CheckpointTypeDoor;
    
    Checkpoint *porchLights = [[Checkpoint alloc] init];
    porchLights.name = @"Porch Lights";
    porchLights.type = CheckpointTypeLight;
    
    [self.checkpoints addObject:frontDoor];
    [self.checkpoints addObject:garageDoor];
    [self.checkpoints addObject:porchLights];
}

#pragma mark - Updates

- (void)addCheckpoint:(Checkpoint *)checkpoint {
    @synchronized (self.checkpoints) {
        [self.checkpoints addObject:checkpoint];
    }
}

- (void)removeCheckpoint:(Checkpoint *)checkpoint {
    @synchronized (self.checkpoints) {
        [self.checkpoints removeObject:checkpoint];
    }
}

#pragma mark - Queries

- (NSInteger)countOfPositiveCheckpoints {
    NSInteger count = 0;
    for (Checkpoint *checkpoint in self.checkpoints) {
        count += checkpoint.isStatusPositive ? 1 : 0;
    }
    return count;
}

@end

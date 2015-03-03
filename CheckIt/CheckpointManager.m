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

- (NSURL *)dataURL {
    return [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.marksuman.Perimeter"] URLByAppendingPathComponent:@"checkpointData.plist"];
}

- (void)loadCheckpoints {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[self dataURL] path]]) {
        NSDictionary *dataInfo = [NSDictionary dictionaryWithContentsOfURL:[self dataURL]];
        NSLog(@"Data Loaded: %@",dataInfo);
        
        for (NSDictionary *checkpointInfo in [dataInfo objectForKey:@"checkpoints"]) {
            [self addCheckpoint:[[Checkpoint alloc] initWithInfo:checkpointInfo]];
        }
        
        // This is probably backwards. Maybe we check for existence and load the info if it exists. If not, don't worry about creating a save file yet.
        
//        NSDictionary *dataDictionary = @{@"schemaVersion":[NSNumber numberWithInteger:1],@"checkpoints":@[]};
//        [[self dataDictionary] writeToURL:[self dataURL] atomically:YES];
    }
    
    // ---------
    // TEST DATA
    // ---------
//    Checkpoint *frontDoor = [[Checkpoint alloc] init];
//    frontDoor.name = @"Front Door";
//    frontDoor.type = CheckpointTypeDoor;
//    
//    Checkpoint *garageDoor = [[Checkpoint alloc] init];
//    garageDoor.name = @"Garage Door";
//    garageDoor.type = CheckpointTypeDoor;
//    
//    Checkpoint *porchLights = [[Checkpoint alloc] init];
//    porchLights.name = @"Porch Lights";
//    porchLights.type = CheckpointTypeLight;
//    
//    [self.checkpoints addObject:frontDoor];
//    [self.checkpoints addObject:garageDoor];
//    [self.checkpoints addObject:porchLights];
}

- (NSTimeInterval)eventTTL {
    // This is the amount of time that may pass until a checkpoint resets its status to unknown
    
    // 10 hours
    return 36000.0;
    
    // Test value
//    return 10.0;
}

- (NSDictionary *)dataDictionary {
    NSInteger schemaVersion = 1;
    NSMutableArray *checkpointsInfoArray = [NSMutableArray arrayWithCapacity:self.checkpoints.count];
    for (Checkpoint *checkpoint in self.checkpoints) {
        [checkpointsInfoArray addObject:[checkpoint dictionaryVersion]];
    }
    
    return @{@"schemaVersion":[NSNumber numberWithInteger:schemaVersion],@"checkpoints":checkpointsInfoArray};
}

- (BOOL)save {
    return [[self dataDictionary] writeToURL:[self dataURL] atomically:YES];
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

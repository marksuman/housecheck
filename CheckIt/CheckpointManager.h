//
//  CheckpointManager.h
//  CheckIt
//
//  Created by Mark Suman on 2/21/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Checkpoint.h"

@interface CheckpointManager : NSObject

@property (nonatomic, strong) NSMutableArray *checkpoints;
@property (nonatomic) NSTimeInterval eventTTL;

+ (CheckpointManager *)defaultManager;
//- (NSURL *)dataURL;
- (BOOL)save;

// Updates
- (void)addCheckpoint:(Checkpoint *)checkpoint;
- (void)removeCheckpoint:(Checkpoint *)checkpoint;


// Queries
- (NSInteger)countOfPositiveCheckpoints;

@end

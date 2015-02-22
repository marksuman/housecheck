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

+ (CheckpointManager *)defaultManager;

// Queries
- (NSInteger)countOfPositiveCheckpoints;

@end

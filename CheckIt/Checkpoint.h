//
//  Checkpoint.h
//  CheckIt
//
//  Created by Mark Suman on 2/17/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CheckpointType) {
    CheckpointTypeUnknown = 0,
    CheckpointTypeDoor,
    CheckpointTypeLight,
};

typedef NS_ENUM(NSUInteger, CheckpointStatus) {
    CheckpointStatusUnknown = 0,
    CheckpointStatusSecure,
    CheckpointStatusUnsecure,
};

@interface Checkpoint : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) CheckpointType type;
@property (nonatomic) CheckpointStatus status;

// Temp property
@property (nonatomic, strong) NSMutableDictionary *info;

@end

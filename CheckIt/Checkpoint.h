//
//  Checkpoint.h
//  CheckIt
//
//  Created by Mark Suman on 2/17/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSUInteger, CheckpointType) {
//    CheckpointTypeUnknown = 0,
//    CheckpointTypeDoor,
//    CheckpointTypeLight,
//};

//typedef NS_ENUM(NSUInteger, CheckpointStatus) {
//    CheckpointStatusUnknown = 0,
//    CheckpointStatusPositive,
//    CheckpointStatusNegative,
//};

// Type constants
extern NSString * const CheckpointTypeUnknown;
extern NSString * const CheckpointTypeDoor;
extern NSString * const CheckpointTypeLight;

// Status constants
extern NSString * const CheckpointStatusUnknown;
extern NSString * const CheckpointStatusPositive;
extern NSString * const CheckpointStatusNegative;

@interface Checkpoint : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *status;
@property (nonatomic, strong) NSDate *lastStatusDate;

// Type BOOLs
@property (nonatomic, readonly) BOOL isTypeDoor;
@property (nonatomic, readonly) BOOL isTypeLight;

// Status BOOLs
@property (nonatomic, readonly) BOOL isStatusPositive;
@property (nonatomic, readonly) BOOL isStatusNegative;

// Temp property
@property (nonatomic, strong) NSMutableDictionary *info;

- (NSString *)statusString;
- (void)toggleStatus;
- (void)resetStatus;

// Interface Variants
+ (NSString *)imageNameForCheckpointType:(NSString *)checkpointType;
+ (NSString *)typeStringForCheckpointType:(NSString *)checkpointType;
+ (NSArray *)nameSuggestionsForCheckpointType:(NSString *)checkpointType;

@end

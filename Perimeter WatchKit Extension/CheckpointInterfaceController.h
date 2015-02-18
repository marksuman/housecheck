//
//  CheckpointInterfaceController.h
//  CheckIt
//
//  Created by Mark Suman on 2/17/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "Checkpoint.h"

@interface CheckpointInterfaceController : WKInterfaceController

@property (nonatomic, strong) Checkpoint *checkpoint;

@end

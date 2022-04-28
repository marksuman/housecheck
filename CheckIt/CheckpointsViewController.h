//
//  CheckpointsViewController.h
//  Perimeter
//
//  Created by Mark Suman on 4/6/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckpointsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

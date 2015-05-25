//
//  CheckpointCollectionViewCell.h
//  Perimeter
//
//  Created by Mark Suman on 4/7/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckpointCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *typeImageView;
@property (nonatomic, weak) IBOutlet UIImageView *statusImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *whiteAddImageView;
@property (nonatomic, weak) IBOutlet UILabel *whiteAddLabel;

@end

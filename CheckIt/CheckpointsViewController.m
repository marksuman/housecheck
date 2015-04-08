//
//  CheckpointsViewController.m
//  Perimeter
//
//  Created by Mark Suman on 4/6/15.
//  Copyright (c) 2015 Sub-Saharan. All rights reserved.
//

#import "CheckpointsViewController.h"
#import "CheckpointManager.h"
#import "CheckpointCollectionViewCell.h"

@interface CheckpointsViewController ()

@end

@implementation CheckpointsViewController

static NSString * const reuseIdentifier = @"CheckpointCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[CheckpointCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Methods

- (NSString *)statusImageNameForCheckpoint:(Checkpoint *)checkpoint {
    if (checkpoint.isStatusPositive) {
        return [self positiveStatusImageNameForCheckpoint:checkpoint];
    }
    else if (checkpoint.isStatusNegative) {
        return [self negativeStatusImageNameForCheckpoint:checkpoint];
    }
    else {
        return [self unknownStatusImageNameForCheckpoint:checkpoint];
    }
}

- (NSString *)positiveStatusImageNameForCheckpoint:(Checkpoint *)checkpoint {
    // If we want, we could customize the positive image based on checkpoint type
    // For now we'll just show a default
    return @"state-check";
}

- (NSString *)negativeStatusImageNameForCheckpoint:(Checkpoint *)checkpoint {
    // If we want, we could customize the negative image based on checkpoint type
    // For now we'll just show a default
    return @"state-x";
}

- (NSString *)unknownStatusImageNameForCheckpoint:(Checkpoint *)checkpoint {
    // If we want, we could customize the unknown image based on checkpoint type
    // For now we'll just show a default
    return @"state-question";
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[CheckpointManager defaultManager] checkpoints] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CheckpointCollectionViewCell *cell = (CheckpointCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSArray *checkpoints = [[CheckpointManager defaultManager] checkpoints];
    
    // Configure the cell
    Checkpoint *checkpoint = [checkpoints objectAtIndex:[indexPath row]];
    cell.nameLabel.text = checkpoint.name;
    cell.typeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"white-%@",[Checkpoint imageRootForCheckpointType:checkpoint.type]]];
    cell.statusImageView.image = [UIImage imageNamed:[self statusImageNameForCheckpoint:checkpoint]];
    
    cell.layer.cornerRadius = 5.0f;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end

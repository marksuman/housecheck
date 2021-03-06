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

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

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
//    self.automaticallyAdjustsScrollViewInsets = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
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

- (UIColor *)colorForCheckpointType:(NSString *)checkpointType {
    if ([checkpointType isEqualToString:CheckpointTypeDoor]) {
        return [UIColor colorWithRed:92.0f/255.0f green:221.0f/255.0f blue:67.0f/255.0f alpha:0.8f];
    }
    else if ([checkpointType isEqualToString:CheckpointTypeLight]) {
        return [UIColor colorWithRed:0.0f/255.0f green:199.0f/255.0f blue:255.0f/255.0f alpha:0.8f];
    }
    else if ([checkpointType isEqualToString:CheckpointTypeWindow]) {
        return [UIColor colorWithRed:236.0f/255.0f green:0.0f/255.0f blue:140.0f/255.0f alpha:0.8f];
    }
    else if ([checkpointType isEqualToString:CheckpointTypeAppliance]) {
        return [UIColor colorWithRed:255.0f/255.0f green:101.0f/255.0f blue:41.0f/255.0f alpha:0.8f];
    }
    else if ([checkpointType isEqualToString:CheckpointTypeFamily]) {
        return [UIColor colorWithRed:203.0f/255.0f green:39.0f/255.0f blue:255.0f/255.0f alpha:0.8f];
    }
    else if ([checkpointType isEqualToString:CheckpointTypePet]) {
        return [UIColor colorWithRed:203.0f/255.0f green:39.0f/255.0f blue:255.0f/255.0f alpha:0.8f];
    }
    
    return [UIColor colorWithRed:237.0f/255.0f green:28.0f/255.0f blue:36.0f/255.0f alpha:0.8f];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[CheckpointManager defaultManager] checkpoints] count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CheckpointCollectionViewCell *cell = (CheckpointCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSArray *checkpoints = [[CheckpointManager defaultManager] checkpoints];
    
    // Configure the cell
    if ([indexPath row] == checkpoints.count) {
        // We are at the last cell. This is the "Add a Checkpoint" cell.
        
        cell.nameLabel.hidden = YES;
        cell.statusImageView.hidden = YES;
        cell.typeImageView.hidden = YES;
        cell.whiteAddImageView.hidden = NO;
        cell.whiteAddLabel.hidden = NO;
        return cell;
    }
    
    Checkpoint *checkpoint = [checkpoints objectAtIndex:[indexPath row]];
    cell.nameLabel.text = checkpoint.name;
    cell.typeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"white-collection-%@",[Checkpoint imageRootForCheckpointType:checkpoint.type]]];
    cell.statusImageView.image = [UIImage imageNamed:[self statusImageNameForCheckpoint:checkpoint]];
    cell.statusImageView.layer.borderColor = [[UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:180.0f/255.0f alpha:0.5f] CGColor];
    cell.statusImageView.layer.borderWidth = 1.0f;
    cell.statusImageView.layer.cornerRadius = 18.0f;

    cell.backgroundColor = [self colorForCheckpointType:checkpoint.type];
//    cell.layer.borderColor = [[self colorForCheckpointType:checkpoint] CGColor];
//    cell.layer.borderWidth = 4.0f;
    cell.layer.cornerRadius = 10.0f;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *checkpoints = [[CheckpointManager defaultManager] checkpoints];
    
    if ([indexPath row] == checkpoints.count) {
        // User tapped the New Checkpoint cell
        NSLog(@"Display the new checkpoint interface");
    }
    else {
        Checkpoint *checkpoint = [checkpoints objectAtIndex:[indexPath row]];
        [checkpoint toggleStatus];
        
        CheckpointCollectionViewCell *cell = (CheckpointCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.statusImageView.image = [UIImage imageNamed:[self statusImageNameForCheckpoint:checkpoint]];
        
        [[CheckpointManager defaultManager] save];
    }
}

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

//
//  DONCollectionViewController.m
//  DonateApp
//
//  Created by Guang on 11/17/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONCollectionViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "DONFakeThing.h"

#import "QueryCell.h"

@interface DONCollectionViewController ()

@property(strong,nonatomic)NSMutableArray * fakeData;

@end

@implementation DONCollectionViewController

static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getFakeData];
    [self activeXibCell];
    
    NSLog(@"Is there a count: %ld", self.fakeData.count);
   //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"Number of items getting called.");

    return self.fakeData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*subclass
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                           forIndexPath:indexPath];

     */
    
    NSLog(@"creating cells!");
    
    QueryCell * cell = (QueryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"qCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRandomFlatColorOfShadeStyle:UIShadeStyleLight];
    cell.thing = [[DONFakeThing alloc] initWithName:@"hello" image:@""];
    
    //UILabel *title = (UILabel *)[cell viewWithTag:50];
    //cell.cellTitle.text = @"HELLO"; //self.fakeData[indexPath.row];
    NSLog(@"title is %@",self.fakeData[indexPath.row]);
    return cell;
}

#pragma mark fake data

-(void)getFakeData{
    self.fakeData = [NSMutableArray new];
    for (int i=0; i<50; i++) {
        [self.fakeData addObject:[NSString stringWithFormat:@"cell %d", i]];
    }
}
#pragma mark xibCell

-(void)activeXibCell{
    
    
    /* not subclass
    UINib *cellNib = [UINib nibWithNibName:@"xibCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    */
    
    //[self.collectionView registerClass:[QueryCell class] forCellWithReuseIdentifier:@"cell"]; // subcläss. no need for storyboard

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(200 , 200);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // add vertical
    self.collectionView.collectionViewLayout = flowLayout;
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


/*
 NSlog each session the cell was made, but I did not assign anything stuff in it so .. it is black, but nothing is wrong !!! 
 */

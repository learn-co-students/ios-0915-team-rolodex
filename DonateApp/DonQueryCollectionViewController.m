//
//  DonQueryCollectionViewController.m
//  DonateApp
//
//  Created by Guang on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DonQueryCollectionViewController.h"
#import "QueryCell.h"

#import <ChameleonFramework/Chameleon.h>


@interface DonQueryCollectionViewController ()

@property(strong,nonatomic)NSMutableArray * fakeData;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *searchCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

//@property (weak, nonatomic) IBOutlet UIImageView *searchIcon;


@end

@implementation DonQueryCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.searchCollectionView.delegate = self;
    self.searchCollectionView.dataSource = self;
    
    [self getFakeData];
    [self activeXibCell];
    [self searchBarCellStyle];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger numberOfItems = collectionView == self.collectionView ? self.fakeData.count : 6;
    
    return numberOfItems;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // delegate gave the thing also ...
    if (collectionView == self.collectionView) {
        
        QueryCell * cell = (QueryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"qCell" forIndexPath:indexPath];
        //cell.backgroundColor = ComplementaryFlatColor([UIColor redColor]); [UIColor colorWithGradientStyle:(UIGradientStyle)gradientStyle withFrame:(CGRect)frame andColors:(NSArray<UIColor *> *)colors];
        [self setupTheQueryCell:cell atIndexPath:indexPath];
        
        return cell;

    }
    
    if (collectionView == self.searchCollectionView) {
        
        UICollectionViewCell * sCell = [self.searchCollectionView dequeueReusableCellWithReuseIdentifier:@"searchCell" forIndexPath:indexPath];
        
        UIColor * one = [UIColor yellowColor];
        UIColor * two = [UIColor blueColor];
        NSArray * x = @[one,two];
        sCell.backgroundColor = GradientColor(UIGradientStyleRadial,sCell.frame,x);
        //sCell.backgroundView = [UIImage imageNamed:@"music-record.png"];
        
        //UIImageView * xxx = [UIImageView alloc]
        return sCell;
    }
    
    return nil;
}

- (void)setupTheQueryCell:(QueryCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = RandomFlatColorWithShade(UIShadeStyleLight);
    cell.thing = [[DONFakeThing alloc] initWithName:@"hello" image:@""];
    //UILabel *title = (UILabel *)[cell viewWithTag:50];
    //cell.cellTitle.text = @"HELLO"; //self.fakeData[indexPath.row];
    NSLog(@"title is %@",self.fakeData[indexPath.row]);
}

-(void)getFakeData{
    self.fakeData = [NSMutableArray new];
    for (int i=0; i<50; i++) {
        [self.fakeData addObject:[NSString stringWithFormat:@"cell %d", i]];
    }
}

-(void)activeXibCell{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(110, 110);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // add vertical
    self.collectionView.collectionViewLayout = flowLayout;
}

-(void)searchBarCellStyle{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(60, 60);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // add vertical
    self.searchCollectionView.collectionViewLayout = flowLayout;
}

-(void)searchAction{
}
@end

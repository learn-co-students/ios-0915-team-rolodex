//
//  DonQueryCollectionViewController.m
//  DonateApp
//
//  Created by Guang on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DonQueryCollectionViewController.h"
#import "DONUser.h"
#import "DONItem.h"

#import "QueryCell.h"
#import "SearchCell.h"
#import  <Parse/Parse.h>

#import <ChameleonFramework/Chameleon.h>


@interface DonQueryCollectionViewController ()

@property(strong,nonatomic)NSMutableArray * fakeData;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *searchCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *greeting;


@property (strong, nonatomic) NSString * userOnPage;
@property (strong, nonatomic) NSArray * items;

@end

@implementation DonQueryCollectionViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.searchCollectionView.delegate = self;
    self.searchCollectionView.dataSource = self;
    
    [self getAllPdata]; // do you set this as a main Queae ?
    

    //[self getFakeData];
    [self activeXibCell];
    [self searchBarCellStyle];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  delegate 

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger numberOfItems = collectionView == self.collectionView ? self.items.count : [self iconImages].count;
    return numberOfItems;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // delegate gave the thing also ...in this case it gives you collectionView / indexPath
    if (collectionView == self.collectionView) {

        QueryCell * cell = (QueryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"qCell" forIndexPath:indexPath];
        DONItem * item = self.items[indexPath.row];
        cell.cellTitle.text = item.name;
        cell.image.file = item.imageFile;
        [cell.image loadInBackground];
        
        /*
         PFImageView *view = [[PFImageView alloc] initWithImage:kPlaceholderImage];

         */

        [self setupTheQueryCell:cell atIndexPath:indexPath];

        return cell;
    }
    
    
    if (collectionView == self.searchCollectionView) {
        
        SearchCell * sCell = [self.searchCollectionView dequeueReusableCellWithReuseIdentifier:@"searchCell" forIndexPath:indexPath];
        sCell.imageView.image = self.iconImages[indexPath.row];
        return sCell;
    }
    return nil;
}

#pragma mark  cell style

- (void)setupTheQueryCell:(QueryCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = RandomFlatColorWithShade(UIShadeStyleLight);
    UIColor * one = RandomFlatColorWithShade(UIShadeStyleLight);
    UIColor * two = RandomFlatColorWithShade(UIShadeStyleLight);
    NSArray * x = @[one,two];
    cell.backgroundColor = GradientColor(UIGradientStyleRadial,cell.frame,x);
    //cell.thing = [[DONFakeThing alloc] initWithName:@"hello" image:@""];
   // NSLog(@"title is %@",self.fakeData[indexPath.row]);
}


-(void)activeXibCell{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(113, 115);
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

#pragma mark  data

-(void)getAllPdata{
        
    [self getdataFromParseWithBlock:^(BOOL success)
     {
         if (success)
         {
             NSLog(@"Get the info %@ with the stuffff %@",self.userOnPage,self.items);
             self.greeting.text = [NSString stringWithFormat:@" ☞ "];
         } else{
         }
     }];
}

-(NSMutableArray *)testingData:(NSArray *) realData{

    NSMutableArray * testData = [NSMutableArray new];
    for (int i = 0 ; i < 30 ; i++)
    {
        [testData addObject:realData[0]];
        [testData addObject:realData[1]];
        [testData addObject:realData[2]];
    }
    
    return testData;
}

-(void)getdataFromParseWithBlock:(void (^)(BOOL success))completationBlock{
//    __block NSString * userName;
//    __block NSArray * allItems;
    [DONUser testUserWithCompletion:^(DONUser *user, NSError *error) {
        if (!error) {
            //userName = user.username;
            self.userOnPage = user.username;
            [DONUser allItemsForCurrentUserWithCompletion:^(NSArray *items, BOOL success){
                if (success == YES)
                {
                    //self.items = items;// add here
                    
                    self.items = [self testingData:items];
                    [self.collectionView reloadData];
                    completationBlock(YES);
                    NSLog(@"get Items");
                }
            }];
        } else
        {
            NSLog(@"Error: %@-%@", error, error.userInfo);
        }
    }];
}

-(NSArray *)iconImages{
    NSArray *icons = [NSArray arrayWithObjects:
                      [UIImage imageNamed:@"music-record.png"],
                      [UIImage imageNamed:@"book.png"],
                      [UIImage imageNamed:@"suitcase.png"],
                      [UIImage imageNamed:@"tree.png"],
                      [UIImage imageNamed:@"desk.png"],
                      [UIImage imageNamed:@"clothing.png"],
                      nil ];
    return icons;
}

@end

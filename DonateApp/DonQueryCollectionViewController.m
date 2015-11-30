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
#import "DONCategory.h"
#import "QueryCell.h"
#import "SearchCell.h"

#import <ChameleonFramework/Chameleon.h>
#import "DonGoogleMapViewController.h"

// Drawer menu code
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

#import "DONItemViewController.h"

@interface DonQueryCollectionViewController ()

@property(strong,nonatomic)NSMutableArray * fakeData;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *searchCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *greeting;
@property (weak, nonatomic) IBOutlet UILabel *searchSelectionLabel;
@property (weak, nonatomic) IBOutlet UIStackView *stackedViewLables;


@property (strong, nonatomic) NSString * userOnPage;
@property (strong, nonatomic) NSArray * items;
@property (strong, nonatomic) NSMutableArray * allCategory;

@end

@implementation DonQueryCollectionViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.searchCollectionView.delegate = self;
    self.searchCollectionView.dataSource = self;

    //moved data loading to viewWillAppear
    
    // Remove "Back" nav bar text next to back arrow
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
 
    [self activeXibCell];
    [self searchBarCellStyle];
    [self getCategoryWithBlock:^(BOOL success) {
        NSLog(@"get the catoory");
    }];

    // Drawer menu code
    [self setupLeftMenuButton];


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getAllPdata]; // do you set this as a main Queae ?

}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Drawer menu code

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    leftDrawerButton.tintColor = [UIColor blackColor];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark collectionView delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger numberOfItems = collectionView == self.collectionView ? self.items.count : self.allCategory.count;
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
        DONCategory * category = self.allCategory[indexPath.row];
        //sCell.searchLabel.text = category.name;
        sCell.imageView.file = category.imageFile;
        [sCell.imageView loadInBackground];
        [self makeTheStackOfcats];
        return sCell;
    }
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    if (collectionView == self.collectionView) {

        DONItem *item = self.items[indexPath.row];
        DONItemViewController *itemViewController =[[DONItemViewController alloc] initWithItem:item];
        [self.navigationController pushViewController:itemViewController animated:YES];
        
    }
    if (collectionView == self.searchCollectionView) {
        NSLog(@"I tapped searchCollectionView");
        self.searchSelectionLabel.text = [self.allCategory[indexPath.row] name];
        
        UILabel * selectedlabel = [ UILabel new ];
        selectedlabel = self.stackedViewLables.arrangedSubviews[indexPath.row];
        selectedlabel.hidden = ! selectedlabel.hidden;
    }
}

#pragma mark stackView methods

-(void)makeTheStackOfcats{
    self.stackedViewLables.backgroundColor = [UIColor blackColor];
    for (DONCategory * eachCat in self.allCategory) {
        UILabel * catLabel = [[UILabel alloc] init];
        catLabel.text = eachCat.name;
        catLabel.textColor = [UIColor whiteColor];
        catLabel.backgroundColor = [UIColor blackColor];
        catLabel.hidden = YES;
        [self.stackedViewLables addArrangedSubview:catLabel];
    }
}

#pragma mark  cell style

-(void)setupTheQueryCell:(QueryCell *)cell atIndexPath:(NSIndexPath *)indexPath {
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
    //flowLayout.itemSize = CGSizeMake(113, 115);
    flowLayout.itemSize = CGSizeMake((self.view.frame.size.width/2), (self.view.frame.size.height/4));
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.headerReferenceSize = CGSizeZero;

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
             //NSLog(@"Get the info %@ with the stuffff %@",self.userOnPage,self.items);
             self.greeting.text = [NSString stringWithFormat:@" ☞ "];
         } else{
         }
     }];
}

-(NSMutableArray *)testingData:(NSArray *) realData{

    NSMutableArray * testData = [NSMutableArray new];
    for (int i = 0 ; i < 10 ; i++)
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


-(void)getCategoryWithBlock:(void (^)(BOOL success))completationBlock{
    
    [DONCategory allCategoriesWithCompletion:^(BOOL success, NSArray *categories){
        if (success){
            self.allCategory = [NSMutableArray new];
            self.allCategory = categories.mutableCopy;
            NSLog(@"self.allCategory %@",self.allCategory);
            [self.searchCollectionView reloadData];
        }
    }];
}

#pragma mark location

- (IBAction)goTomap:(id)sender {
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DonGoogleMapViewController * mapView = [DonGoogleMapViewController new];
    mapView = segue.destinationViewController;
}

-(void)locationStuff{
    
    //+ (void)geoPointForCurrentLocationInBackground:(void ( ^ ) ( PFGeoPoint *geoPoint , NSError *error ))geoPointHandler
    //[PFQuery whereKey:nearGeoPoint:]
}

//-(void)queryLocation{
//    
//
//    NSLog(@"HELLO locations");
//    
//    [DONItem fetchItemWithItemId:@"fumHFXNnw8" withCompletion:^(DONItem *item, NSError *error) {
//        PFGeoPoint * point = [PFGeoPoint geoPointWithLatitude:40.705329 longitude:-74.0161583];
//        [item setObject:point forKey:@"location"];
//        [item saveInBackground];
//    }];
// 
//   
//    
//    
//}

-(void)geoPointForCurrentLocationInBackground:(void ( ^ ) ( PFGeoPoint *geoPoint , NSError *error ))geoPointHandler{
    
}



@end

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
#import "OpenInGoogleMapsController.h"

#import <ChameleonFramework/Chameleon.h>
#import "DonGoogleMapViewController.h"

#import "DonContainerViewController.h"

@interface DonQueryCollectionViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *searchCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *searchSelectionLabel;
@property (weak, nonatomic) IBOutlet UIStackView *stackedViewLables;

@property (weak, nonatomic) DonContainerViewController * containerViewController;

@property (strong, nonatomic) NSString * userOnPage;
@property (strong, nonatomic) NSArray * items;
@property (strong, nonatomic) NSMutableArray * allCategory;

@end

@implementation DonQueryCollectionViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchCollectionView.delegate = self;
    self.searchCollectionView.dataSource = self;

    [self searchBarCellStyle];
    [self getCategoryWithBlock:^(BOOL success) {
        NSLog(@"get the catoory");
    }];

}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark collectionView delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger numberOfItems = self.allCategory.count;
    return numberOfItems;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    
    if (collectionView == self.searchCollectionView) {
        NSLog(@"I tapped searchCollectionView");
        self.searchSelectionLabel.text = [self.allCategory[indexPath.row] name];
        
        UILabel * selectedlabel = [ UILabel new ];
        selectedlabel = self.stackedViewLables.arrangedSubviews[indexPath.row];
        selectedlabel.hidden = ! selectedlabel.hidden;
    }
}

  #pragma mark stackView methods
//for the search feature when tap icon the names shows up under

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
//style for the old collection.  we are not using it this method anymore, but keep it for now :)
-(void)setupTheQueryCell:(QueryCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = RandomFlatColorWithShade(UIShadeStyleLight);
    UIColor * one = RandomFlatColorWithShade(UIShadeStyleLight);
    UIColor * two = RandomFlatColorWithShade(UIShadeStyleLight);
    NSArray * x = @[one,two];
    cell.backgroundColor = GradientColor(UIGradientStyleRadial,cell.frame,x);

}
// style for the category style
-(void)searchBarCellStyle{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(60, 60);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // add vertical
    self.searchCollectionView.collectionViewLayout = flowLayout;
}

  #pragma mark  data

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

  #pragma mark container vew
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}

-(IBAction)goTomap:(id)sender {
    [self.containerViewController swapViewControllers];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"embedContainer"])
    {
        self.containerViewController = segue.destinationViewController;
    }
}



@end

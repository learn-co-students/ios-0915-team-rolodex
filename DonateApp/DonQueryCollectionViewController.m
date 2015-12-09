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
#import "SearchCell.h"

#import <ChameleonFramework/Chameleon.h>
#import "DonGoogleMapViewController.h"
#import "DonContainerViewController.h"
// Drawer menu code
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

#import "DONItemViewController.h"
#import "DONCollectionViewDataModel.h"
#import "DONLocationController.h"

@interface DonQueryCollectionViewController ()

// Guang
@property (weak, nonatomic) IBOutlet UICollectionView *searchCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *searchSelectionLabel;
@property (weak, nonatomic) IBOutlet UIStackView *stackedViewLables;
@property (weak, nonatomic) DonContainerViewController * containerViewController;

@property (strong, nonatomic) NSString * userOnPage;
@property (strong, nonatomic) NSArray * items;
@property (strong, nonatomic) NSArray * allCategory;

// Jon
@property (nonatomic, strong) DONCollectionViewDataModel *dataModel;
@property (nonatomic, strong) UIButton *mapButton;
@property (nonatomic, strong) UIColor *mapButtonColor;
@end

@implementation DonQueryCollectionViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchCollectionView.delegate = self;
    self.searchCollectionView.dataSource = self;

    //moved data loading to viewWillAppear
    
    // Remove "Back" nav bar text next to back arrow
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
 
    [self searchBarCellStyle];
    
    // Data model
    [self setupNotifications];
    self.dataModel = [DONCollectionViewDataModel sharedInstance];

    // Drawer menu code
    [self setupNavigationBar];
    
    [[DONLocationController sharedInstance] getCurrentUserLocationWithCompletion:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Navigation Bar Setup
// Drawer menu code

-(void)setupNavigationBar {
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    leftDrawerButton.tintColor = [UIColor blackColor];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)setupRightMenuButton {
    self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mapButton.frame = CGRectMake(0, 0, 22, 22);
    UIImage *locationIcon = [[UIImage imageNamed:@"Location Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.mapButton setImage:locationIcon forState:UIControlStateNormal];
    self.mapButtonColor = [UIColor grayColor];
    [self.mapButton.imageView setTintColor:self.mapButtonColor];
    self.mapButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.mapButton.imageView.frame = CGRectMake(0, 0, 22, 22);
    [self.mapButton addTarget:self action:@selector(goTomap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.mapButton];
    [self.navigationItem setRightBarButtonItem:item animated:YES];
    
}

#pragma mark Notifications
-(void)setupNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updatedCategories) name:kDidUpdateCategoriesNotification object:nil];
    [center addObserver:self selector:@selector(updatingItems) name:kWillUpdateItemsNotification object:nil];
    [center addObserver:self selector:@selector(updatedItems) name:kDidUpdateItemsNotification object:nil];
}

-(void)updatedCategories
{
    // Reload the collection view
    
    self.allCategory = self.dataModel.allCategories;
    [self.searchCollectionView reloadData];
}

-(void)updatingItems
{
    // Turn the userinteraction OFF
    self.searchCollectionView.userInteractionEnabled = NO;
}

-(void)updatedItems
{
    // turn the UserInteraction back ON
    self.searchCollectionView.userInteractionEnabled = YES;
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
//        sCell.imageView.file = category.imageFile;
//        [sCell.imageView loadInBackground];
        NSString *categoryName = category.name;
        UIImage *image = [[UIImage imageNamed:categoryName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        sCell.imageView.image = image;
    
        
        if (!category.selected) {
            sCell.imageView.alpha = 0.6f;

            sCell.imageView.tintColor = [UIColor blackColor];
        } else {
            sCell.imageView.alpha = 1.0f;
            
            sCell.imageView.tintColor =  [UIColor colorWithRed:33.0/255.0 green:192.0/255.0 blue:100.0/255.0 alpha:1];            
        }

        return sCell;
    }
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    

    if (collectionView == self.searchCollectionView) {
        DONCategory *category = self.allCategory[indexPath.row];
        [self.dataModel toggleCategory:category];
        
        self.searchSelectionLabel.text = [self.allCategory[indexPath.row] name];

        [self makeTheStackOfcats];
        UILabel * selectedlabel = [ UILabel new ];
        selectedlabel = self.stackedViewLables.arrangedSubviews[indexPath.row];
        selectedlabel.hidden = !category.selected;
        
    }
}

#pragma mark stackView methods
//for the search feature when tap icon the names shows up under

-(void)makeTheStackOfcats{
    self.stackedViewLables.backgroundColor = [UIColor blackColor];
    for (DONCategory * eachCat in self.allCategory) {
        UILabel * catLabel = [[UILabel alloc] init];
        //catLabel.text = eachCat.name;
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:eachCat.name];
        [attributeString addAttribute:NSUnderlineStyleAttributeName
                                value:[NSNumber numberWithInt:2]
                                range:(NSRange){0,[attributeString length]}];
        catLabel.attributedText = attributeString;
        catLabel.textColor = [UIColor blackColor];
        catLabel.backgroundColor = [UIColor clearColor];
        catLabel.hidden = YES;
        //catLabel.frame = UIEdgeInsetsInsetRect(catLabel.frame, UIEdgeInsetsMake(0, 25, 25, 0));
        [self.stackedViewLables addArrangedSubview:catLabel];
    }
}

  #pragma mark  cell style
-(void)searchBarCellStyle{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(65, 65);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // add vertical
    self.searchCollectionView.collectionViewLayout = flowLayout;
}

  #pragma mark container vew
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}

-(IBAction)goTomap:(id)sender {
    [self.containerViewController swapViewControllers];
    
    if (self.mapButtonColor == [UIColor grayColor]) {
        self.mapButtonColor = [UIColor blackColor];
    } else {
        self.mapButtonColor = [UIColor grayColor];
    }
    
    [self.mapButton.imageView setTintColor:self.mapButtonColor];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"embedContainer"])
    {
        self.containerViewController = segue.destinationViewController;
    }
}

#pragma view style things 

-(UIImage *)imageByDrawingWhiteCircleBehindImage:(UIImage *)image andResizingToSize:(CGSize)size withColor:(UIColor*)color
{
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    circlePath.lineWidth = 1;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    [circlePath fill];
    
       // [[UIColor colorWithWhite:0.2 alpha:1] setStroke];
    [[UIColor blueColor] setStroke];
        [circlePath stroke];
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end

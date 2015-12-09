//
//  DonCollectionViewController.m
//  DonateApp
//
//  Created by Guang on 11/30/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DonCollectionViewController.h"

#import "DONUser.h"
#import "DONItem.h"
#import "DONCategory.h"
#import "QueryCell.h"
#import "DONItemViewController.h"
#import "DONCollectionViewDataModel.h"

@interface DonCollectionViewController ()

@property (strong, nonatomic) NSArray * items;
@property (nonatomic, strong) DONCollectionViewDataModel *dataModel;
@property (nonatomic, strong) UIView *temporaryBackground;
@end

@implementation DonCollectionViewController

static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
   //[self.collectionView registerClass:[QueryCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self setupNotifications];
    self.dataModel = [DONCollectionViewDataModel sharedInstance];
    self.dataModel.viewToUpdateHUD = self.collectionView;
    [self.dataModel loadAllItems];
    
    [self activeXibCell];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
}


-(void)viewDidLayoutSubviews
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.temporaryBackground = [[UIView alloc] init];
        
        UILabel *text2 = [[UILabel alloc] init];
        text2.textColor = [UIColor lightGrayColor];
        text2.font = [UIFont systemFontOfSize:14];
        text2.textAlignment = NSTextAlignmentCenter;
        text2.lineBreakMode = NSLineBreakByWordWrapping;
        text2.numberOfLines = 3;
        text2.text = @"Please note an internet connection is required for this application to function!";
        text2.frame = CGRectMake(30, 0, CGRectGetWidth(self.collectionView.frame) - 60, 150);
        [self.temporaryBackground addSubview:text2];
        
        UIImage *giveReceive = [[UIImage imageNamed:@"GiveReceive"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        backgroundImageView.tintColor = [UIColor lightGrayColor];
        backgroundImageView.image = giveReceive;
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        backgroundImageView.frame = CGRectMake(CGRectGetMaxX(self.collectionView.frame)/4, CGRectGetMaxY(self.collectionView.frame)/4, CGRectGetWidth(self.collectionView.frame)/2, CGRectGetWidth(self.collectionView.frame)/2);
        backgroundImageView.center = self.collectionView.center;

        [self.temporaryBackground addSubview:backgroundImageView];
        
        UILabel *text = [[UILabel alloc] init];
        text.textColor = [UIColor lightGrayColor];
        text.font = [UIFont systemFontOfSize:14];
        text.textAlignment = NSTextAlignmentCenter;
        text.lineBreakMode = NSLineBreakByWordWrapping;
        text.numberOfLines = 3;
        text.text = @"\"When we give cheerfully and accept gratefully, everyone is blessed.\n-Maya Angelou\"";
        text.frame = CGRectMake(30, CGRectGetMaxY(backgroundImageView.frame)-10, CGRectGetWidth(self.collectionView.frame)-60,150);
        [self.temporaryBackground addSubview: text];
        
        [self.collectionView insertSubview:self.temporaryBackground atIndex:0];
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Notifications
-(void)setupNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updatingItems) name:kWillUpdateItemsNotification object:nil];
    [center addObserver:self selector:@selector(updatedItems) name:kDidUpdateItemsNotification object:nil];
}

-(void)updatingItems
{
    // Turn the userinteraction OFF
    self.collectionView.userInteractionEnabled = NO;
}

-(void)updatedItems
{
    // turn the UserInteraction back ON
    self.collectionView.userInteractionEnabled = YES;
    self.items = self.dataModel.items;
    self.temporaryBackground.hidden = YES;
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}


#pragma mark <UICollectionViewDelegate>
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        QueryCell * cell = (QueryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        DONItem * item = self.items[indexPath.row];

        //cell.cellTitle.text = item.name;
        cell.image.file = item.imageFile;
        [cell.image loadInBackground];

        return cell;
}
 

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    if (collectionView == self.collectionView) {
        
        NSLog(@"I tapped collectionView");
        /* push to the map direction
        DONItem * selectedItem = self.items[indexPath.row];
        if (selectedItem.location) {
            CGFloat lat = selectedItem.location.latitude;
            CGFloat lon = selectedItem.location.longitude;
            NSString * coordinateString = [NSString stringWithFormat:@"%f,%f",lat,lon];
            NSLog(@"lat and long %@",coordinateString);
            // wirte a bool method also with animation indicat the cell lead to a map
            [self activeGoogleMapToLocationQuery:coordinateString];
        }   else if (selectedItem.pickupInstructions) {
            NSString * pareselocationString = [selectedItem.pickupInstructions stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            NSLog(@"location=%@",pareselocationString);
            [self activeGoogleMapToLocationQuery:pareselocationString];
        }
        */
        DONItem *item = self.items[indexPath.row];
        DONItemViewController *itemViewController =[[DONItemViewController alloc] initWithItem:item];
        [self.navigationController pushViewController:itemViewController animated:YES];
    }
}


#pragma mark cell Style

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


#pragma mark data stuff

-(void)getAllPdata{
    
    [self getdataFromParseWithBlock:^(BOOL success)
     {
         if (success)
         {
             //NSLog(@"Get the info %@ with the stuffff %@",self.userOnPage,self.items);
             //self.greeting.text = [NSString stringWithFormat:@" ☞ "];
         } else{
         }
     }];
}

-(NSMutableArray *)testingData:(NSArray *) realData{
    
    NSMutableArray * testData = [NSMutableArray new];
    for (int i = 0 ; i < 5 ; i++)
    {
        [testData addObject:realData[i]];
//        [testData addObject:realData[1]];
//        [testData addObject:realData[2]];
//        [testData addObject:realData[3]];
//        [testData addObject:realData[4]];
    }
    
    return testData;
}

-(void)getdataFromParseWithBlock:(void (^)(BOOL success))completationBlock{
    
    [DONItem allItemsWithCompletion:^(BOOL success, NSArray *allItems) {
        if (success) {
            self.items = [self testingData:allItems];
            [self.collectionView reloadData];
            completationBlock(YES);
            //NSLog(@"allItems %@",allItems);
            
        }else{
            NSLog(@"Error:");
        }
    }];
}
#pragma marker maps

-(void)activeGoogleMapToLocationQuery:(NSString *)itemLocation{
    
    NSURL * googleCallBack = [ NSURL URLWithString: @"comgooglemaps://" ];
    /*
     need to add a check statement if the user has googlmap not installed add the function that allow user to turn on its current location
     */
    NSString * saddr = @"40.705329,-74.0161583";

    NSString *googleMapsURLString = [NSString stringWithFormat:@"comgooglemaps://?saddr=%@&daddr=%@",saddr,itemLocation];
    
    if ([[UIApplication sharedApplication] canOpenURL: googleCallBack]) {
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:googleMapsURLString]];
    } else {
        NSLog(@"Can't use comgooglemaps://");
    }
}

@end

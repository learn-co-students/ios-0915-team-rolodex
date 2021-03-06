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
@property (nonatomic, strong) UILabel *placeholderTextTop;
@property (nonatomic, strong) UIView *temporaryBackground;
@property (nonatomic, strong) UILabel *placeholderTextBottom;
@end

@implementation DonCollectionViewController

static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self setupNotifications];
    self.dataModel = [DONCollectionViewDataModel sharedInstance];
    self.dataModel.viewToUpdateHUD = self.collectionView;
    
    [self activeXibCell];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.dataModel loadAllItems];
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
        self.placeholderTextTop = text2;
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
        self.placeholderTextBottom = text;
        [self.temporaryBackground addSubview: text];
        
        [self.collectionView insertSubview:self.temporaryBackground atIndex:0];
        
    });
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.dataModel reloadItems];
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
    self.items = [NSArray arrayWithArray:self.dataModel.items];
    if (self.items.count > 0 ) {
        self.temporaryBackground.hidden = YES;
    } else {
        self.temporaryBackground.hidden = NO;
        self.placeholderTextTop.text = @"No items found.";
        self.placeholderTextBottom.text = @"";
    }
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
    cell.cellTitle.text = item.name;

//    cell.cellTitle.textColor = [UIColor whiteColor];
    
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    [cell.contentView addSubview:bluredEffectView];
//    [bluredEffectView setFrame:cell.cellTitle.frame];
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        UIImage *greyImage = [self greyImage];
        cell.image.file = item.imageFile;
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.image.image = greyImage;
            [cell.image loadInBackground];
        });
    });

    
    return cell;
}

-(UIImage *)greyImage
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    if (collectionView == self.collectionView) {
        
        NSLog(@"I tapped collectionView");
        DONItem *item = self.items[indexPath.row];
        DONItemViewController *itemViewController =[[DONItemViewController alloc] initWithItem:item];
        [self.navigationController pushViewController:itemViewController animated:YES];
    }
}


#pragma mark cell Style

-(void)activeXibCell{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((self.view.frame.size.width/2), (self.view.frame.size.height/4));
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.headerReferenceSize = CGSizeZero;
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // add vertical
    self.collectionView.collectionViewLayout = flowLayout;
}


#pragma mark data stuff

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

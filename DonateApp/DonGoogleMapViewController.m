//
//  DonGoogleMapViewController.m
//  DonateApp
//
//  Created by Guang on 11/22/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DonGoogleMapViewController.h"
#import "DONItemViewController.h"
#import "DONItem.h"
#import "DONUser.h"
#import "DONCategory.h"
#import "DonInfowindow.h"
#import "DONCollectionViewDataModel.h"

#import "Masonry.h"

@import GoogleMaps;

@interface DonGoogleMapViewController () <GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *googleMapView;
@property (strong, nonatomic) GMSMapView * mapView;
@property (strong, nonatomic) NSArray * itemsOnMap;
//@property (weak, nonatomic) IBOutlet UIButton *backHomeButton;

@property (strong, nonatomic) UIView * mView;
@property (nonatomic, strong) GMSMarker *ignoreNextMarkerSelectionForThisMarker;

@end

@implementation DonGoogleMapViewController

{

}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self createMap];
    [self centerMap];

    [self itmeMapUpdate];
    
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    
    [self backHomeButtom];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itmeMapUpdate) name:kDidUpdateItemsNotification object:nil];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma marker map add and  marker
-(void)createMap{

    self.mapView = [GMSMapView mapWithFrame:self.googleMapView.bounds camera:[GMSCameraPosition new]];
    [self.googleMapView addSubview: self.mapView];
    [self centerMap];
}

-(void)centerMap
{
    CLLocationCoordinate2D currentLocation = [self getCurrentLocation];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.latitude longitude:currentLocation.longitude zoom:11];
    self.mapView.camera = camera;
    //[self backHomeButtom];
    [self positionMarkers];
}

-(void)positionMarkers{
    
    for (DONItem * eachItem in self.itemsOnMap) {
        NSLog(@"%@",eachItem);
        // [self addMakerWithLatitude:eachItem.location.latitude longitude:eachItem.location.longitude category:eachItem.categories];
        NSArray * test = [eachItem objectForKey:@"categories"];
        PFQuery * catQ = [PFQuery queryWithClassName:@"Category"];
        [catQ whereKey:@"objectId" equalTo: [test[0] valueForKey:@"objectId"]];
        [catQ findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            DONCategory * category = (DONCategory *)objects[0];
            NSLog(@"category name = %@ with image %@", category.name, category.imageFile);
            
            UIImage *localIconImage = [self imageByDrawingWhiteCircleBehindImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",category.name]] andResizingToSize:CGSizeMake(25, 25) withColor:[UIColor whiteColor]];
            
            //            __weak typeof(self) tmpself = self;
            //            [tmpself addMarkerWithItem:eachItem WithLatitude:eachItem.location.latitude longitude:eachItem.location.longitude discription:eachItem.itemDescription itemImage:localIconImage];
            //
            
            [self addMarkerWithItem:eachItem WithLatitude:eachItem.location.latitude longitude:eachItem.location.longitude discription:eachItem.itemDescription itemImage:localIconImage];
            
            
            /*
             __block UIImage *iconImage = [UIImage new];
             PFFile *iconImageFile = category.imageFile;
             __weak typeof(self) tmpself = self;
             //TODO: Create a weak reference to SELF to be used within this block (calling self in BLOCK created a ?retain cycle)
             */
            
        }];
    }
}

-(void)addMarkerWithItem:(DONItem *)item WithLatitude:(double)latitude
               longitude:(double)longitude discription:(NSString *)discription itemImage:(UIImage *)itemImage{

    GMSMarker * marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitude,longitude);
    marker.userData = item;
    marker.snippet = discription;
    marker.map = self.mapView;
    marker.icon = itemImage;
    marker.infoWindowAnchor = CGPointMake(0.8, -0);

}

-(CLLocationCoordinate2D)getCurrentLocation
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = location.coordinate;
//    NSString *str=[[NSString alloc] initWithFormat:@" latitude:%f longitude:%f",coordinate.latitude,coordinate.longitude];
//    NSLog(@"%@",str);
    
    return coordinate;
}


#pragma marker delegate
-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{

}

-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    NSLog(@"infoVieww!");
    
   // DonInfowindow * infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"DonInfowindow" owner:self options:nil] objectAtIndex:0];
    
    //[[NSOperationQueue mainQueue] addOperationWithBlock:^{
    ///infoWindow.itemImage.file = [marker.userData imageFile];
   // [infoWindow.itemImage loadInBackground];
    // }];
    
    
    
    
    
    
    
    DonInfowindow * infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"DonInfowindow" owner:self options:nil] objectAtIndex:0];
    
        //[[NSOperationQueue mainQueue] addOperationWithBlock:^{
    infoWindow.itemImage.file = [marker.userData imageFile];		      infoWindow.itemImage.file = [marker.userData imageFile];
       [infoWindow.itemImage loadInBackground];		
     
       // }];		
       // So Google maps only renders the marker window once, when we return it from this function.
       // If it changes after the fact (for instance, when the image loads), it does not get refreshed. :(
       // SO... when the image comes down, we need to fake the user reselecting the marker (by setting mapView.selectedMarker)
       // BUT... doing that triggers a call to this method again, which just leads to an infinite loop.
       // So... we let that happen once, but use the ignoreNextMarkerSelectionForThisMarker property to make sure we don't
       // loop forever.
   
   
       [infoWindow.itemImage loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
       if(mapView.selectedMarker == marker) {  // make sure the user hasn't tapped a different marker in the meantime
         if(self.ignoreNextMarkerSelectionForThisMarker != marker) {  // and we're not avoiding that infinite loop...
                   self.ignoreNextMarkerSelectionForThisMarker = marker;    // set this so we only redraw once

     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                           mapView.selectedMarker = marker;                     // re-select the marker
                       }];
               }
             }
     }];
    
    
    
    // still trying to process this.
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = infoWindow.title.frame;
    [infoWindow addSubview:effectView];
    [infoWindow sendSubviewToBack:effectView];
    
    infoWindow.title.text = marker.snippet;
    
    infoWindow.title.adjustsFontSizeToFitWidth = YES;
    [infoWindow.title sizeToFit];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(3, 6, 3, 3);
    infoWindow.title.frame = UIEdgeInsetsInsetRect(infoWindow.title.frame, insets);
    
    return infoWindow;
}


-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    NSLog(@"tapped into the infobox!");
    DONItemViewController *itemViewController =[[DONItemViewController alloc] initWithItem:marker.userData];
    [self.navigationController pushViewController:itemViewController animated:YES];
}


#pragma marker imageResize and other small methods

-(UIImage *)imageByDrawingWhiteCircleBehindImage:(UIImage *)image andResizingToSize:(CGSize)size withColor:(UIColor*)color
{
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
   circlePath.lineWidth = 1;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    [circlePath fill];
//    
//    [[UIColor colorWithWhite:0.2 alpha:0.7] setStroke];
//    [circlePath stroke];
//
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

/*
-(IBAction)backTolocationCamera:(id)sender{
    NSLog(@"home button tapped");
//    [self.backHomeButton setImage:[UIImage imageNamed:@"noun_12594_cc.png"] forState:UIControlStateNormal];
//    self.backHomeButton.frame = CGRectMake(0, 0, 30, 30);
//    
    //self.backHomeButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    //self.backHomeButton.imageView.clipsToBounds = YES;
   // [self.backHomeButton sendSubviewToFront:self.mapView];
    
    [self createMap];
}
*/

-(void)backHomeButtom{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"runHome.png"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(centerMap) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"homeLocation" forState:UIControlStateNormal];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.top.equalTo(self.googleMapView.mas_top);
        make.centerX.equalTo(self.googleMapView);
    }];
}


-(void)itmeMapUpdate{
    self.itemsOnMap = [DONCollectionViewDataModel sharedInstance].items;
    // add animation when reload
    // do not recreat the map but reload the data somehow
    [self.mapView clear];
    //[self createMap];
    [self positionMarkers];
    [self centerMap];
    self.mapView.delegate = self;
    
}

@end

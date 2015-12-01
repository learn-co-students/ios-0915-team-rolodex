//
//  DonGoogleMapViewController.m
//  DonateApp
//
//  Created by Guang on 11/22/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DonGoogleMapViewController.h"
#import "DONItem.h"
#import "DONUser.h"
#import "DONCategory.h"
#import "DonInfowindow.h"

@import GoogleMaps;

@interface DonGoogleMapViewController () <GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *googleMapView;
@property (strong, nonatomic) GMSMapView * mapView;
@property (strong, nonatomic) NSMutableArray * itemsOnMap;

@end

@implementation DonGoogleMapViewController

{
    //GMSMapView * mapView;
}


-(void)viewDidLoad {
    [super viewDidLoad];
    [self createMap];
    [self positionMarkers];

}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma marker map add and  marker
-(void)createMap{
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.7048872
                                                            longitude: -74.0123737
                                                                 zoom:12];
    self.mapView = [GMSMapView mapWithFrame:self.googleMapView.bounds camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    [self.googleMapView addSubview: self.mapView];

}

-(void)positionMarkers{
    
    [self getLocationswithCompletion:^(BOOL success){
        if (success) {
            for (DONItem * eachItem in self.itemsOnMap) {
               // [self addMakerWithLatitude:eachItem.location.latitude longitude:eachItem.location.longitude category:eachItem.categories];
                NSArray * test = [eachItem objectForKey:@"categories"];
                PFQuery * catQ = [PFQuery queryWithClassName:@"Category"];
                [catQ whereKey:@"objectId" equalTo: [test[0] valueForKey:@"objectId"]];
                [catQ findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    DONCategory * category = (DONCategory *)objects[0];
                    NSLog(@"category name = %@", category.name);
                    
                    
                    __block UIImage * iconImage = [UIImage new];
                    PFFile * iconImageFile = eachItem[@"imageFile"];
                    [iconImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                        if (!error) {
                            iconImage = [UIImage imageWithData:imageData];
                        }
                    }];
                    
                    [self addMakerWithLatitude:eachItem.location.latitude longitude:eachItem.location.longitude category:category.name itemName:eachItem.name discription:eachItem.itemDescription itemImage:iconImage];
                }];
             }
           }
        }];
}

-(void)addMakerWithLatitude:(double)latitude
                  longitude:(double)longitude
                   category:(NSString *)categoryName itemName:(NSString *)name
                discription:(NSString *)discription itemImage:(UIImage *)itemImage{
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitude,longitude);
    marker.title = name;
    marker.snippet = discription;
    //UIImage * iconImi = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",categoryName]];
    // CGSize size = CGSizeApplyAffineTransform(iconImi.size, CGAffineTransformMakeScale(0.5, 0.5));
    //marker.icon = iconImi;

    //marker.icon = itemImage;
    marker.map = self.mapView;
    marker.infoWindowAnchor = CGPointMake(0.6, 0.3);
}

#pragma marker delegate
-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{

}

-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    NSLog(@"infoVieww!");
    
    DonInfowindow * infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"DonInfowindow" owner:self options:nil] objectAtIndex:0];
    infoWindow.title.text = marker.snippet;
    [infoWindow.title sizeToFit];
    infoWindow.itemImage.image = [UIImage imageNamed:@"clara.jpg"];
    infoWindow.itemImage.layer.cornerRadius = 50;
    infoWindow.itemImage.layer.masksToBounds = YES;

    return infoWindow;
}

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    CGPoint point = [mapView.projection pointForCoordinate:marker.position];
    return NO;
}

#pragma marker get data
-(void)getLocationswithCompletion:(void (^)(BOOL success))completaionBlock;{
    
    self.itemsOnMap = [NSMutableArray new];
    [DONItem allItemsWithCompletion:^(BOOL success, NSArray *allItems) {
        if (success) {
            //NSLog(@"allItems ,%@",allItems);
            self.itemsOnMap = allItems.mutableCopy;
            completaionBlock(YES);
            for (DONItem * eachitem in allItems) {
                //NSLog(@"checking item #%ld of #%ld", [allItems indexOfObject:eachitem], allItems.count);
                PFGeoPoint * point = eachitem.location;
                NSLog(@"point: %@", point);
            }
        } else{
            NSLog(@"error, handling");
        }
    }];
}

@end

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
@import GoogleMaps;

@interface DonGoogleMapViewController () <GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *googleMapView;
@property (strong, nonatomic) GMSMapView * mapView;
@property (strong, nonatomic) NSArray * itemsOnMap;

@end

@implementation DonGoogleMapViewController

{
    CLLocationManager *locationManager;
}


-(void)viewDidLoad {
    [super viewDidLoad];
    [self createMap];
    [self itmeMapUpdate];
    //[self positionMarkers];
    locationManager = [[CLLocationManager alloc] init];
    // current location get!
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itmeMapUpdate) name:kDidUpdateItemsNotification object:nil];

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
    
    //[self getLocationswithCompletion:^(BOOL success){
     //   if (success) {
    
            for (DONItem * eachItem in self.itemsOnMap) {
                NSLog(@"%@",eachItem);
               // [self addMakerWithLatitude:eachItem.location.latitude longitude:eachItem.location.longitude category:eachItem.categories];
                NSArray * test = [eachItem objectForKey:@"categories"];
                PFQuery * catQ = [PFQuery queryWithClassName:@"Category"];
                [catQ whereKey:@"objectId" equalTo: [test[0] valueForKey:@"objectId"]];
                [catQ findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    DONCategory * category = (DONCategory *)objects[0];
                    NSLog(@"category name = %@ with image %@", category.name, category.imageFile);

                    UIImage *localIconImage = [self imageByDrawingWhiteCircleBehindImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",category.name]] andResizingToSize:CGSizeMake(20, 20)];
                    
                    __weak typeof(self) tmpself = self;
                    [tmpself addMarkerWithItem:eachItem WithLatitude:eachItem.location.latitude longitude:eachItem.location.longitude
                                   discription:eachItem.itemDescription itemImage:localIconImage];
                    
                    /*
                    __block UIImage *iconImage = [UIImage new];
                    PFFile *iconImageFile = category.imageFile;
                    __weak typeof(self) tmpself = self;

                    //TODO: Create a weak reference to SELF to be used within this block (calling self in BLOCK created a retain cycle)
                    
                    [iconImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                    
                        if (!error) {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                iconImage = [UIImage imageWithData:imageData];
                                UIImage * resizedIcon = [self image:iconImage scaledToSize:CGSizeMake(31,31)];
                                [tmpself addMarkerWithItem:eachItem WithLatitude:eachItem.location.latitude longitude:eachItem.location.longitude
                                            discription:eachItem.itemDescription itemImage:resizedIcon];
                            }];
                        }
                    }];
                    */
                    //[self addMakerWithLatitude:eachItem.location.latitude longitude:eachItem.location.longitude category:category.name itemName:eachItem.name discription:eachItem.itemDescription itemImage:iconImage];
                }];
             }
       //    }
     //   }];
}

-(void)addMarkerWithItem:(DONItem *)item WithLatitude:(double)latitude
               longitude:(double)longitude discription:(NSString *)discription itemImage:(UIImage *)itemImage{
    
    GMSMarker * marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitude,longitude);
    marker.userData = item;
    marker.snippet = discription;
    marker.map = self.mapView;
    marker.icon = itemImage;
    marker.infoWindowAnchor = CGPointMake(0.6, 0.3);
}
//
//-(CLLocationCoordinate2D) getLocation{
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    [locationManager requestWhenInUseAuthorization];
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    locationManager.distanceFilter = kCLDistanceFilterNone;
//    [locationManager startUpdatingLocation];
//    CLLocation *location = [locationManager location];
//    CLLocationCoordinate2D coordinate = [location coordinate];
//    return coordinate;
//}


#pragma marker delegate
-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{

}

-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    NSLog(@"infoVieww!");
    
    DonInfowindow * infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"DonInfowindow" owner:self options:nil] objectAtIndex:0];
    
    
    //[[NSOperationQueue mainQueue] addOperationWithBlock:^{
    infoWindow.itemImage.file = [marker.userData imageFile];
    [infoWindow.itemImage loadInBackground];
    // }];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = infoWindow.title.frame;
    [infoWindow addSubview:effectView];
    [infoWindow sendSubviewToBack:effectView];
    
    infoWindow.title.text = marker.snippet;
    
    infoWindow.title.adjustsFontSizeToFitWidth = YES;
    [infoWindow.title sizeToFit];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(5, 5, 5, 5);
    infoWindow.title.frame = UIEdgeInsetsInsetRect(infoWindow.title.frame, insets);
    
    //infoWindow.itemImage.image = [UIImage imageNamed:@"clara.jpg"];
    // infoWindow.itemImage.layer.cornerRadius = 50;
    // infoWindow.itemImage.layer.masksToBounds = YES;
    
    return infoWindow;
}

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    CGPoint point = [mapView.projection pointForCoordinate:marker.position];
    return NO;
}

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    NSLog(@"tapped into the infobox!");
    DONItemViewController *itemViewController =[[DONItemViewController alloc] initWithItem:marker.userData];
    [self.navigationController pushViewController:itemViewController animated:YES];
}


#pragma marker get data
/*
-(void)getLocationswithCompletion:(void (^)(BOOL success))completaionBlock;{
    
    self.itemsOnMap = [NSMutableArray new];
    [DONItem allItemsWithCompletion:^(BOOL success, NSArray *allItems) {
        if (success) {
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
*/
#pragma marker imageResize and other small methods

-(UIImage *)imageByDrawingWhiteCircleBehindImage:(UIImage *)image andResizingToSize:(CGSize)size
{
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
   circlePath.lineWidth = 1;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    [[UIColor whiteColor] setFill];
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

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //const float colorMasking[6] = {1.0, 1.0, 0.0, 0.0, 1.0, 1.0};
    //image = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(image.CGImage, colorMasking)];
    
    /*
    const float colorMasking[6] = {1.0, 1.0, 0.0, 0.0, 1.0, 1.0}; //{255.0, 255.0, 255.0, 255.0, 255.0, 255.0};
    CGImageRef imageRef = CGImageCreateWithMaskingColors(originalImage.CGImage, colorMasking);
    UIImage* finalImage = [UIImage imageWithCGImage:imageRef];
    */

    return image;
}

-(void)itmeMapUpdate{
    self.itemsOnMap = [DONCollectionViewDataModel sharedInstance].items;
    [self positionMarkers];
}

@end

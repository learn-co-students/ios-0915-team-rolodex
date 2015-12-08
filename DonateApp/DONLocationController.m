//
//  DONLocationController.m
//  DonateApp
//
//  Created by Jon on 11/25/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONLocationController.h"
@interface DONLocationController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) void (^locationCompletion)(CLLocation *location, BOOL success);
@property (nonatomic, strong) CLLocation *lastUpdatedLocation;
@end

@implementation DONLocationController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.geocoder = [[CLGeocoder alloc] init];
        self.locationManager =[CLLocationManager new];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
    }
    return self;
}

+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)getCurrentUserLocationWithCompletion:(void (^)(CLLocation *location, BOOL success))completion
{
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    self.locationCompletion = completion;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager failed with error: %@", error);
    if (self.locationCompletion) {
        self.locationCompletion(nil, NO);
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self.locationManager stopUpdatingLocation];
    
    if (locations[0]) {
        NSLog(@"Got a location for the user");
        if (self.locationCompletion) {
            self.locationCompletion(locations[0], YES);
        }
    } else {
        NSLog(@"Error finding location for user");
        if (self.locationCompletion) {
            self.locationCompletion(nil, NO);
        }
    }
    
    self.lastUpdatedLocation = locations[0];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Changed auth status to %d", status);
}

+(CLLocation *)locationForGeoPoint:(PFGeoPoint *)geoPoint
{
    return [[CLLocation alloc] initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
}

+(void)cityAndStateForGeoPoint:(PFGeoPoint *)geoPoint withCompletion:(void (^)(NSString *string))completion
{
    CLLocation *location = [DONLocationController locationForGeoPoint:geoPoint];
    
    DONLocationController *controller = [DONLocationController sharedInstance];
    [controller.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (!error) {
            CLPlacemark *placemark = placemarks[0];
            NSString *city = placemark.locality;
            NSString *state = placemark.administrativeArea;
            NSString *string = [NSString stringWithFormat:@"%@, %@", city, state];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(string);
            });
        } else {
            NSLog(@"Error in geocoder: %@", error);
        }
        
    }];
}

#pragma mark Location Authorizations
-(BOOL)locationServicesEnabled
{
    return [self authorizationStatusEqualTo:kCLAuthorizationStatusAuthorizedWhenInUse] || [self authorizationStatusEqualTo:kCLAuthorizationStatusAuthorizedAlways];
}

- (BOOL)needsAuthorization
{
    return [self authorizationStatusEqualTo:kCLAuthorizationStatusNotDetermined];
}

- (BOOL)authorizationStatusEqualTo:(CLAuthorizationStatus)status
{
    return [CLLocationManager authorizationStatus] == status;
}

@end

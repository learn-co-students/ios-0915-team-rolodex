//
//  DONLocationController.m
//  DonateApp
//
//  Created by Jon on 11/25/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONLocationController.h"
@interface DONLocationController ()
@property (nonatomic, strong) CLGeocoder *geocoder;
@end

@implementation DONLocationController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.geocoder = [[CLGeocoder alloc] init];
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

+(void)cityAndStateForGeoPoint:(PFGeoPoint *)geoPoint withCompletion:(void (^)(NSString *string))completion
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
    
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


@end

//
//  DONLocationController.h
//  DonateApp
//
//  Created by Jon on 11/25/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface DONLocationController : NSObject
+(instancetype)sharedInstance;
-(BOOL)locationServicesEnabled;
-(void)getCurrentUserLocationWithCompletion:(void (^)(CLLocation *location, BOOL success))completion;
+(CLLocation *)locationForGeoPoint:(PFGeoPoint *)geoPoint;
+(void)cityAndStateForGeoPoint:(PFGeoPoint *)geoPoint withCompletion:(void (^)(NSString *string))completion;
@end

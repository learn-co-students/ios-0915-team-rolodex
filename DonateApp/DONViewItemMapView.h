//
//  DONViewItemMapView.h
//  DonateApp
//
//  Created by Jon on 11/25/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFGeoPoint.h"
@import GoogleMaps;

@interface DONViewItemMapView : UIView
-(instancetype)initWithLocation:(PFGeoPoint *)location;
@property (nonatomic, strong, readonly) CLLocation *location;
@property (nonatomic, strong, readonly) GMSMapView *mapView;
@end

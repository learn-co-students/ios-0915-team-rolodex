//
//  DONViewItemMapView.m
//  DonateApp
//
//  Created by Jon on 11/25/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONViewItemMapView.h"
#import "DONLocationController.h"
#import "Masonry.h"

@interface DONViewItemMapView () <GMSMapViewDelegate>
@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) CLLocation *location;

@end

@implementation DONViewItemMapView

-(instancetype)initWithLocation:(PFGeoPoint *)location
{
    self = [super init];
    if (!self) return nil;
    self.location = [DONLocationController locationForGeoPoint:location];;
    
    [self setupViews];
    
    return self;
}

-(void)setupViews
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:self.location.coordinate zoom:16.7];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.delegate = self;
    self.mapView.userInteractionEnabled = NO;
    [self placeMarkerAtLatitude:self.location.coordinate.latitude longitude:self.location.coordinate.longitude];
    [self addSubview:self.mapView];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self setupCustomZoom];
}

-(void)setupCustomZoom
{
    BOOL locationServicesEnabled = [[DONLocationController sharedInstance] locationServicesEnabled];
    
    if (locationServicesEnabled) {
        DONLocationController *myController = [DONLocationController sharedInstance];
        CLLocation *location = myController.lastUpdatedLocation;
        if (location) {
            CLLocation *userLocation = location;
            CLLocation *itemLocation = self.location;
            CGFloat distanceBetweenLocations = [itemLocation distanceFromLocation:userLocation];
            CGFloat requiredZoom = [self zoomRequiredForDistance:distanceBetweenLocations];
            [self.mapView animateToZoom:requiredZoom];
        }
    }
}

-(CGFloat)zoomRequiredForDistance:(CGFloat)distance
{
    NSLog(@"Calculating zoom for distance %0.5f", distance);
    CGFloat screenWidthInPoints = [[UIScreen mainScreen] bounds].size.width;
    CGFloat earthCircumferenceInMeters = 40000 * 1000;
    CGFloat googleMapsZoomZeroPointsForWorld = 256;
    CGFloat calculatedZoom = log2f(distance/screenWidthInPoints/earthCircumferenceInMeters*googleMapsZoomZeroPointsForWorld)*-1;
    NSLog(@"%0.5f", calculatedZoom);
    
    return calculatedZoom - 2.0f;
}

- (void)placeMarkerAtLatitude:(double)latitude longitude:(double)longitude
{
    dispatch_async(dispatch_get_main_queue(), ^{
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(latitude, longitude);
        marker.map = self.mapView;
        UIImage *locationIconImage = [UIImage imageNamed:@"Location Icon"];
        marker.icon = locationIconImage;
    });
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CALayer *topBorder = [CALayer layer];
    topBorder.borderColor = [UIColor lightGrayColor].CGColor;
    topBorder.borderWidth = 0.5f;
    topBorder.frame = CGRectMake(-1, -1, CGRectGetWidth(self.frame)+2, 1);
    topBorder.shadowColor = [UIColor blackColor].CGColor;
    topBorder.shadowRadius = 2.0f;
    topBorder.shadowOpacity = 0.5f;
    topBorder.shadowOffset = CGSizeMake(0, 1);
    [self.layer addSublayer:topBorder];
}


@end

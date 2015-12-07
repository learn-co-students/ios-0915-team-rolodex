//
//  DONViewItemMapView.m
//  DonateApp
//
//  Created by Jon on 11/25/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONViewItemMapView.h"
@import GoogleMaps;
#import "DONLocationController.h"
#import "Masonry.h"
@interface DONViewItemMapView () <GMSMapViewDelegate>
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) GMSMapView *mapView;

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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:self.location.coordinate zoom:12];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.delegate = self;
    
    [self placeMarkerAtLatitude:self.location.coordinate.latitude longitude:self.location.coordinate.longitude];
    
    [self addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
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

-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{   NSLog(@" you tapped me on the map");
    
    if (self.location) {
        CGFloat lat = coordinate.latitude;
        CGFloat lon = coordinate.longitude;
        NSString * coordinateString = [NSString stringWithFormat:@"%f,%f",lat,lon];
        NSLog(@"lat and long %@",coordinateString);
        // wirte a bool method also with animation indicat the cell lead to a map
        [self activeGoogleMapToLocationQuery:coordinateString];
    }/*
        else if (selectedItem.pickupInstructions) {
        NSString * pareselocationString = [selectedItem.pickupInstructions stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSLog(@"location=%@",pareselocationString);
        [self activeGoogleMapToLocationQuery:pareselocationString];
      */
    
    else {
        [[UIApplication sharedApplication] openURL:
        [NSURL URLWithString:[self amapAppURL]]];
    }
}

#pragma marker map direction

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
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[self amapAppURL]]];
    }
}

-(NSString *)gmapAppURL
{
    CGFloat latitude = self.mapView.camera.target.latitude;
    CGFloat longitude = self.mapView.camera.target.longitude;
    CGFloat zoom = self.mapView.camera.zoom;
    return [NSString stringWithFormat:@"comgooglemaps://?q=%0.6f,%0.6f&zoom=%0.6f", latitude, longitude, zoom];
}
                                                   
-(NSString *)amapAppURL
{
    CGFloat latitude = self.mapView.camera.target.latitude;
    CGFloat longitude = self.mapView.camera.target.longitude;
    CGFloat zoom = self.mapView.camera.zoom;
    return [NSString stringWithFormat:@"http://maps.apple.com/?q=%0.6f,%0.6f&z=%0.6f", latitude, longitude, zoom];
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

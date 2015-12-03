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
{
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[self gmapAppURL]]];
    } else {
        [[UIApplication sharedApplication] openURL:
        [NSURL URLWithString:[self amapAppURL]]];
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

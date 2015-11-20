//
//  MapViewController.m
//  DonateApp
//
//  Created by Guang on 11/20/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "MapViewController.h"
#import "Mapbox.h"

@interface MapViewController ()

@property (nonatomic, strong) MGLMapView *mapView;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL * styleURL = [NSURL URLWithString:@"asset://styles/light-v8.json"];
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:styleURL];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.7048872, -74.0123737)
                            zoomLevel:15
                             animated:NO];
    [self.view addSubview:self.mapView];
    
    
    self.mapView.delegate = self;
    
    // Declare the annotation `point` and set its coordinates, title, and subtitle
    MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(40.7048872, -74.0123737);
    point.title = @"Come pick me up";
    point.subtitle = @"I am a jacket in a good condition";
    
    // Add annotation `point` to the map
    [self.mapView addAnnotation:point];
    

}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation
{
    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:@"icon"];
    
    if (! annotationImage)
    {
        // Leaning Tower of Pisa by Stefan Spieler from the Noun Project
        UIImage *image = [UIImage imageNamed:@"clothing.png"];
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"icon"];
    }
    
    return annotationImage;
}


-(BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    return YES;
}

@end

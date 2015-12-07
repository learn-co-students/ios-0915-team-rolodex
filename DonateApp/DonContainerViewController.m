//
//  DonContainerViewController.m
//  DonateApp
//
//  Created by Guang on 11/30/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DonContainerViewController.h"
#import "DonGoogleMapViewController.h"
#import "DonCollectionViewController.h"

#define segueCollectionId @"collectionV"
#define segueMapId @"mapV"



@interface DonContainerViewController ()

@property (strong, nonatomic) NSString * currentSegueId;
@property (strong, nonatomic) DonGoogleMapViewController * googleMapView;
@property (strong, nonatomic) DonCollectionViewController * collectionView;
@property (assign, nonatomic) BOOL transitionInProgress;

@end

@implementation DonContainerViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.transitionInProgress = NO;
    self.currentSegueId = segueCollectionId;
    [self performSegueWithIdentifier:self.currentSegueId sender:nil];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it. Remove the second condition of the following
    // two if statements to get new VC instances instead.
    
    
    if ([segue.identifier isEqualToString:segueCollectionId]) {
        self.collectionView = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:segueMapId]) {
        self.googleMapView = segue.destinationViewController;
    }
    // If we're going to the first view controller.
    if ([segue.identifier isEqualToString:segueCollectionId]) {
        // If this is not the first time we're loading this.
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.collectionView];
        }
        else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationViewController];
            UIView* destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    }
    // By definition the second view controller will always be swapped with the
    // first one.
    else if ([segue.identifier isEqualToString:segueMapId]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.googleMapView];
    }
}

-(void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController{
    NSLog(@"swap method called");
    
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        self.transitionInProgress = NO;
    }];
}

-(void)swapViewControllers
{
    NSLog(@"swamViewController method");
    
    if (self.transitionInProgress) {
        return;
    }
    
    self.transitionInProgress = YES;
    self.currentSegueId = ([self.currentSegueId isEqualToString:segueCollectionId]) ?
    segueMapId : segueCollectionId;
    
    if (([self.currentSegueId isEqualToString:segueCollectionId]) && self.collectionView) {
        [self swapFromViewController:self.googleMapView toViewController:self.collectionView];
        return;
    }
    
    if (([self.currentSegueId isEqualToString:segueMapId]) && self.googleMapView) {
        [self swapFromViewController:self.collectionView toViewController:self.googleMapView];
        return;
    }
    
    [self performSegueWithIdentifier:self.currentSegueId sender:nil];
}




@end

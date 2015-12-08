//
//  DONUserProfileViewController.m
//  DonateApp
//
//  Created by Jon on 11/19/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONViewOtherUserProfileViewController.h"
#import "DONUser.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Masonry/Masonry.h>
#define MAS_SHORTHAND

@interface DONViewOtherUserProfileViewController ()
@property (nonatomic, strong) PFImageView *userPhotoImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *donatedItemsLabel;
@property (nonatomic, strong) UILabel *donatedItemsCaptionLabel;
@property (nonatomic, strong) UILabel *verifiedItemsLabel;
@property (nonatomic, strong) UILabel *verifiedItemsCaptionLabel;
@end

@implementation DONViewOtherUserProfileViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Fetching info for user: %@", self.user);
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@'s Profile", self.user.username];
    
    [self setupViews];
    [self constrainViews];
    [self setupViewProperties];
    [self setupViewData];
    
}

-(void)setupViews
{
    self.userPhotoImageView = [[PFImageView alloc] init];
    self.userNameLabel = [[UILabel alloc] init];
    self.donatedItemsLabel = [[UILabel alloc] init];
    self.donatedItemsCaptionLabel = [[UILabel alloc] init];
    self.verifiedItemsLabel = [[UILabel alloc] init];
    self.verifiedItemsCaptionLabel = [[UILabel alloc] init];
    
    [self.view addSubview:self.userPhotoImageView];
    [self.view addSubview:self.userNameLabel];
    [self.view addSubview:self.donatedItemsLabel];
    [self.view addSubview:self.donatedItemsCaptionLabel];
    [self.view addSubview:self.verifiedItemsLabel];
    [self.view addSubview:self.verifiedItemsCaptionLabel];
}

-(void)constrainViews
{
    [self.userPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(60);
        make.centerX.equalTo(self.view);
        make.height.and.width.equalTo(@128);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userPhotoImageView.mas_bottom).offset(5);
        make.centerX.equalTo(self.view);
    }];
    
    [self.donatedItemsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(50);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view.mas_centerX);
    }];
    
    [self.donatedItemsCaptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.donatedItemsLabel.mas_bottom);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view.mas_centerX);
    }];
    
    [self.verifiedItemsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(50);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_centerX);
    }];
    
    [self.verifiedItemsCaptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifiedItemsLabel.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_centerX);
    }];
}

-(void)setupViewProperties
{
    self.userPhotoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.userPhotoImageView.clipsToBounds = YES;
    self.userPhotoImageView.layer.borderWidth = 3.0f;
    self.userPhotoImageView.layer.borderColor = [UIColor whiteColor].CGColor;

    self.userNameLabel.font = [UIFont systemFontOfSize:36];
    self.userNameLabel.textColor = [UIColor whiteColor];
    
    [self whiteCenteredLabelWithSize:72 label:self.donatedItemsLabel];
    [self whiteCenteredLabelWithSize:72 label:self.verifiedItemsLabel];
    
    [self whiteCenteredLabelWithSize:14 label:self.donatedItemsCaptionLabel];
    [self whiteCenteredLabelWithSize:14 label:self.verifiedItemsCaptionLabel];
}

-(void)whiteCenteredLabelWithSize:(NSInteger)size label:(UILabel *)label
{
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
}

-(void)setupViewData
{
    self.userPhotoImageView.file = self.user.photoFile;
    [self.userPhotoImageView loadInBackground];
    
    self.userNameLabel.text = self.user.username;
    
    [DONUser allItemsForUser:self.user withCompletion:^(NSArray *items, BOOL success) {
        self.donatedItemsLabel.text = [NSString stringWithFormat:@"%lu", items.count];
    }];
    
    [DONUser allVerificationsForUser:self.user withCompletion:^(NSArray *items, BOOL success) {
        self.verifiedItemsLabel.text = [NSString stringWithFormat:@"%lu", items.count];
    }];
    
    self.donatedItemsCaptionLabel.text = @"total items donated";
    self.verifiedItemsCaptionLabel.text = @"total verifications";
}

-(void)viewDidLayoutSubviews
{
    // Round the corners
    CGFloat width = self.userPhotoImageView.frame.size.width;
    self.userPhotoImageView.layer.cornerRadius = width/2;
    
    // Background gradient
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[(id)[UIColor colorWithRed:23.0f/255.0f green:43.0f/255.0f blue:156.0f/255.0f alpha:1].CGColor,
                     (id)[UIColor colorWithRed:11.0f/255.0f green:185.0f/255.0f blue:219.0f/255.0f alpha:1].CGColor];
    layer.frame = CGRectMake(self.view.frame.origin.x,
                             self.view.frame.origin.y + self.navigationController.navigationBar.frame.size.height,
                             self.view.frame.size.width,
                             self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);
    
    [self.view.layer insertSublayer:layer atIndex:0];
}
@end

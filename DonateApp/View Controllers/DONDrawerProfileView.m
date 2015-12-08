//
//  DONDrawerProfileView.m
//  DonateApp
//
//  Created by Jon on 11/22/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONDrawerProfileView.h"
#import <ParseUI/ParseUI.h>

@interface DONDrawerProfileView ()
@property (nonatomic, strong) PFImageView *profilePictureImageView;
@property (nonatomic, strong) UIImageView *defaultProfileImageView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@end

@implementation DONDrawerProfileView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self setupViews];
    [self setupViewProperties];
    [self setupViewData];
    return self;
}

-(void)setupViews
{
    self.profilePictureImageView = [[PFImageView alloc] init];
    self.topLabel = [[UILabel alloc] init];
    self.bottomLabel = [[UILabel alloc] init];
    
    [self addSubview:self.profilePictureImageView];
    [self addSubview:self.topLabel];
    [self addSubview:self.bottomLabel];
}

-(void)setupViewProperties
{
    self.profilePictureImageView.frame = CGRectMake(0, 0, 60, 60);
    self.topLabel.frame = CGRectMake(CGRectGetMaxX(self.profilePictureImageView.frame) + 10, 5, self.bounds.size.width - CGRectGetMaxX(self.profilePictureImageView.frame) + 5, 25);
    self.bottomLabel.frame = CGRectMake(CGRectGetMaxX(self.profilePictureImageView.frame) + 10, 30, self.bounds.size.width - CGRectGetMaxX(self.profilePictureImageView.frame) + 5, 25);
    
    self.profilePictureImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.profilePictureImageView.clipsToBounds = YES;
    self.profilePictureImageView.layer.borderWidth = 1.0f;
    self.profilePictureImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profilePictureImageView.backgroundColor = [UIColor grayColor];
    CGFloat width = self.profilePictureImageView.frame.size.width;
    self.profilePictureImageView.layer.cornerRadius = width/2;
    
    self.topLabel.font = [UIFont systemFontOfSize:18];
    self.topLabel.textColor = [UIColor whiteColor];
    self.bottomLabel.font = [UIFont systemFontOfSize:15];
    self.bottomLabel.textColor = [UIColor lightGrayColor];
    
    self.defaultProfileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.defaultProfileImageView.center = self.profilePictureImageView.center;
    self.defaultProfileImageView.tintColor = [UIColor whiteColor];
    self.defaultProfileImageView.backgroundColor = [UIColor grayColor];
    self.defaultProfileImageView.clipsToBounds = YES;
    self.defaultProfileImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.profilePictureImageView addSubview:self.defaultProfileImageView];
    self.defaultProfileImageView.hidden = YES;
}

-(void)setupViewData
{
    UIImage *image;
    NSString *topText;
    NSString *bottomText;
    
    if (!self.user) {
        image = [UIImage imageNamed:@"DefaultProfilePicture"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.defaultProfileImageView.image = image;
        self.profilePictureImageView.image = nil;
        self.defaultProfileImageView.hidden = NO;
        
        topText = @"Sign up";
        bottomText = @"or sign in";
        self.topLabel.text = topText;
        self.bottomLabel.text = bottomText;
        
    } else {
        self.defaultProfileImageView.hidden = YES;
        self.profilePictureImageView.file = self.user.photo;
        [self.profilePictureImageView loadInBackground];
     
        topText = [NSString stringWithFormat:@"%@", self.user.username];
        self.topLabel.text = topText;
        
        [DONUser allItemsForCurrentUserWithCompletion:^(NSArray *items, BOOL success) {
            self.bottomLabel.text = [NSString stringWithFormat:@"%lu offered items", items.count];
        }];
    }
}

-(void)setUser:(DONUser *)user
{
    _user = user;
    [self setupViewData];
}

@end

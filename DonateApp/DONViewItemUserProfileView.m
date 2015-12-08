//
//  DONViewItemUserProfileView.m
//  DonateApp
//
//  Created by Jon on 11/23/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONViewItemUserProfileView.h"
#import <ParseUI/ParseUI.h>
#import "Masonry.h"

@interface DONViewItemUserProfileView ()
@property (nonatomic, strong) PFImageView *profilePictureImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIView *userNameBackground;
@end

@implementation DONViewItemUserProfileView

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
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameBackground = [[UIView alloc] init];
    [self addSubview:self.userNameBackground];
    [self addSubview:self.profilePictureImageView];
    [self addSubview:self.userNameLabel];
}

-(void)setupViewProperties
{
    self.alpha = 0.8f;
    [self.profilePictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.and.height.equalTo(@40);
        make.top.equalTo(self);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.profilePictureImageView.mas_right).offset(2);
        make.centerY.equalTo(self);
    }];
    
    [self.userNameBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel).offset(-10);
        make.width.equalTo(self.userNameLabel).offset(10+5);
        make.height.equalTo(self.userNameLabel).offset(3);
        make.centerY.equalTo(self);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.equalTo(self.profilePictureImageView);
        make.right.equalTo(self.userNameBackground);

    }];

    self.profilePictureImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.profilePictureImageView.clipsToBounds = YES;
    self.profilePictureImageView.backgroundColor = [UIColor grayColor];
    
    self.userNameLabel.font = [UIFont systemFontOfSize:16];
    self.userNameLabel.textColor = [UIColor blackColor];
    
    self.userNameBackground.backgroundColor = [UIColor grayColor];
}

-(void)setupViewData
{
    self.profilePictureImageView.file = self.user.photoFile;
    [self.profilePictureImageView loadInBackground];
    
    NSString *username = [NSString stringWithFormat:@"%@", self.user.username];
    self.userNameLabel.text = username;

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.profilePictureImageView.layer.borderWidth = 1.0f;
    self.profilePictureImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    CGFloat width = self.profilePictureImageView.frame.size.width;
    self.profilePictureImageView.layer.cornerRadius = width/2;
    
    self.userNameBackground.layer.cornerRadius = 5.0f;
}

-(void)setUser:(DONUser *)user
{
    _user = user;
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        [self setupViewData];
    }];
}
@end

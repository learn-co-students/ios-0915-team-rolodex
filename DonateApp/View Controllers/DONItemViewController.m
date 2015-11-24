//
//  DONItemViewController.m
//  DonateApp
//
//  Created by Jon on 11/23/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONItemViewController.h"
#import "DONViewItemUserProfileView.h"
#import "DONItemStatsView.h"
#import "Masonry.h"
#define MAS_SHORTHAND

@interface DONItemViewController ()
@property (nonatomic, strong) PFImageView *itemImageView;
@property (nonatomic, strong) DONViewItemUserProfileView *userProfileView;
@property (nonatomic, strong) DONItemStatsView *itemStatsView;
@property (nonatomic, strong) UIButton *claimButton;
@property (nonatomic, strong) UIButton *verifyButton;
@property (nonatomic, strong) UIView *itemDescriptionView;
@property (nonatomic, strong) UIView *itemMapView;
@property (nonatomic, strong) UIButton *reportErrorButton;
@end

@implementation DONItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Viewing Item";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.itemImageView = [[PFImageView alloc] init];
    self.userProfileView = [[DONViewItemUserProfileView alloc] init];
    self.itemStatsView = [[DONItemStatsView alloc] init];
    self.claimButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.itemDescriptionView = [[UIView alloc] init];
    self.itemMapView = [[UIView alloc] init];
    self.reportErrorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview:self.itemImageView];
    [self.view addSubview:self.userProfileView];
    [self.view addSubview:self.itemStatsView];
    [self.view addSubview:self.claimButton];
    [self.view addSubview:self.verifyButton];
    [self.view addSubview:self.itemDescriptionView];
    [self.view addSubview:self.itemMapView];
    [self.view addSubview:self.reportErrorButton];
    
    self.itemImageView.file = self.item.imageFile;
    [self.itemImageView loadInBackground];
    self.itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.userProfileView.user = self.item.listedBy;
    
    self.itemStatsView.item = self.item;
    
    [self.claimButton setBackgroundColor:[UIColor blueColor]];
    [self.verifyButton setBackgroundColor:[UIColor greenColor]];
    self.itemDescriptionView.backgroundColor = [UIColor orangeColor];
    self.itemMapView.backgroundColor = [UIColor grayColor];
    [self.reportErrorButton setBackgroundColor:[UIColor redColor]];
    
    [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self.view);
        make.height.equalTo(@300);
    }];
    
    [self.userProfileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.bottom.equalTo(self.itemImageView.mas_bottom).offset(-20);
        make.height.equalTo(@40);
    }];
    
    [self.itemStatsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemImageView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(40);
        make.width.equalTo(@100);
    }];
    
    [self.claimButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.itemStatsView.mas_right).offset(30);
        make.top.equalTo(self.itemImageView.mas_bottom).offset(5);
        make.width.equalTo(@140);
    }];
    
    [self.verifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.claimButton.mas_right).offset(5);
        make.top.equalTo(self.itemImageView.mas_bottom).offset(5);
        make.width.equalTo(@140);
    }];
    
    [self.itemDescriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.claimButton.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.equalTo(@150);
    }];
    
    [self.itemMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemDescriptionView.mas_bottom).offset(5);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@200);
    }];
    
    [self.reportErrorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemMapView.mas_bottom).offset(5);
        make.width.equalTo(@140);
        make.centerX.equalTo(self.view);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

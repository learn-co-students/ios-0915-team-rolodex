//
//  DONDrawerViewController.m
//  DonateApp
//
//  Created by Jon on 11/20/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONDrawerViewController.h"
#import "DONDrawerProfileView.h"
#import "DONUserProfileViewController.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "DONQueryCollectionViewController.h"

@interface DONDrawerViewController ()
@property (nonatomic, assign) DrawerSection drawerSectionType;
@property (nonatomic, assign) NSInteger contentInset;
@property (nonatomic, assign) NSInteger profileViewTopInset;
@property (nonatomic, assign) NSInteger profileViewBottomInset;
@end

@implementation DONDrawerViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithRed:100.0/255.0
                                                     green:100.0/255.0
                                                      blue:100.0/255.0
                                                     alpha:1.0];
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:55.0/255.0
                                                      green:55.0/255.0
                                                       blue:55.0/255.0
                                                      alpha:1]];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.contentInset = 15;
    self.profileViewTopInset = 25;
    self.profileViewBottomInset = 15;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 1;
    return 2;
}

#pragma mark - Table View UI Setup
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return (self.profileViewTopInset + self.profileViewBottomInset + 60);
    return 60.0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

// Force insets to begin at zero
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark Table View Cell Creation
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self userSignInOrUpCell];
    }
    
    UITableViewCell *cell = [self cellForDrawerSection:indexPath.row];
    return cell;
}

-(UITableViewCell *)cellForDrawerSection:(DrawerSection)section
{
    UIImage *cellImage;
    NSString *cellText;
    
    switch (section) {
        case DrawerSectionListItem: {
            cellImage = [UIImage imageNamed:@"ListItem"];
            cellText = @"List Item";
            break;
        } case DrawerSectionHelp: {
            cellImage = [UIImage imageNamed:@"Help"];
            cellText = @"Help";
            break;
        }
//        case DrawerSectionTempLogin: {
//            cellImage = nil;
//            cellText = @"Temp Login";
//        }
        default: {
            break;
        }
    }
    
    cellImage = [cellImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentInset, 20, 30, 30)];
    imageView.image = cellImage;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setTintColor:[UIColor whiteColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 15, 10, self.view.bounds.size.width - CGRectGetMaxX(imageView.frame), 40.0)];
    
    label.text = cellText;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell addSubview:imageView];
    [cell addSubview:label];
    
    cell.backgroundColor = self.tableView.backgroundColor;
    
    return cell;
}

-(UITableViewCell *)userSignInOrUpCell
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    DONDrawerProfileView *profileView = [[DONDrawerProfileView alloc] initWithFrame:CGRectMake(self.contentInset, self.profileViewTopInset, self.view.bounds.size.width - self.contentInset, 60)];
    profileView.backgroundColor = self.tableView.backgroundColor;
    cell.backgroundColor = self.tableView.backgroundColor;
    
    [cell addSubview:profileView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([DONUser currentUser]) {
        profileView.user = [DONUser currentUser];
    }
    
    return cell;
}

#pragma mark Table View Actions
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([DONUser currentUser]) {
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
                UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Jon" bundle:nil];
                DONUserProfileViewController *profileViewController = [profileStoryboard instantiateInitialViewController];
                [(UINavigationController *)self.mm_drawerController.centerViewController pushViewController:profileViewController animated:YES];
            }];
        } else {
             [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
                UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Laurent" bundle:nil];
                UIViewController *signupVC = [loginStoryboard instantiateInitialViewController];
                [self.mm_drawerController.centerViewController presentViewController:signupVC animated:YES completion:nil];
             }];
        }
    } else {
        switch (indexPath.row) {
            case DrawerSectionListItem: {
                if ([DONUser currentUser]) {
                    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
                        UIStoryboard *itemStoryboard = [UIStoryboard storyboardWithName:@"Mickey" bundle:nil];
                        DONUserProfileViewController *listItemViewController = [itemStoryboard instantiateInitialViewController];
                        [self.mm_drawerController.centerViewController presentViewController:listItemViewController animated:YES completion:nil];
                    }];
                } else {
                     [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
                         UINavigationController *centerNav = (UINavigationController *)self.mm_drawerController.centerViewController;
                         DonQueryCollectionViewController *centerVC = [centerNav.childViewControllers firstObject];
                         [centerVC displayLoginAlert];
                     }];
                }
                break;
            }
            case DrawerSectionHelp: {
                [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"HelpScreenStoryboard" bundle:nil];
                    DONUserProfileViewController *tempSigninvc = [mainStoryboard instantiateInitialViewController];
                    [(UINavigationController *)self.mm_drawerController.centerViewController pushViewController:tempSigninvc animated:YES];
                }];

                break;
            }
//            case DrawerSectionTempLogin: {
//                [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
//                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                    DONUserProfileViewController *tempSigninvc = [mainStoryboard instantiateInitialViewController];
//                 [(UINavigationController *)self.mm_drawerController.centerViewController pushViewController:tempSigninvc animated:YES];
//                }];
//
//                break;
//            }
            default: {
                break;
            }
        }
    }
}
@end

//
//  DONDrawerViewController.m
//  DonateApp
//
//  Created by Jon on 11/20/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONDrawerViewController.h"
@interface DONDrawerViewController ()
@property (nonatomic, assign) DrawerSection drawerSectionType;
@end

@implementation DONDrawerViewController
-(void)viewDidLoad
{
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
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 1;
    return 3;
}

#pragma mark - Table View UI Setup
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return 60.0;
    return 40.0;
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
        }
        case DrawerSectionInviteFriends: {
            cellImage = [UIImage imageNamed:@"InviteFriends"];
            cellText = @"Invite Friends";
            break;
        }
        case DrawerSectionHelp: {
            cellImage = [UIImage imageNamed:@"Help"];
            cellText = @"Help";
            break;
        }
        default: {
            break;
        }
    }
    
    cellImage = [cellImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 20, 20)];
    imageView.image = cellImage;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setTintColor:[UIColor whiteColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 15, 0, self.view.bounds.size.width - CGRectGetMaxX(imageView.frame), 40.0)];
    
    label.text = cellText;
    label.font = [UIFont systemFontOfSize:15];
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
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    topView.backgroundColor = self.tableView.backgroundColor;
    [cell addSubview:topView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end

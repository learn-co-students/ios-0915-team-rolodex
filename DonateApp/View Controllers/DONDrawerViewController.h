//
//  DONDrawerViewController.h
//  DonateApp
//
//  Created by Jon on 11/20/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DrawerSection)
{
    DrawerSectionListItem,
    DrawerSectionInviteFriends,
    DrawerSectionHelp,
    DrawerSectionTempLogin
};

@interface DONDrawerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

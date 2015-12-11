//
//  DONItemViewController.h
//  DonateApp
//
//  Created by Jon on 11/23/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DONItem.h"
#import <MessageUI/MessageUI.h>

@interface DONItemViewController : UIViewController <MFMailComposeViewControllerDelegate>
-(instancetype)initWithItem:(DONItem *)item;
@end

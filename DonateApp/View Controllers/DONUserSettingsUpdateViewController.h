//
//  DONUserSettingsUpdateViewController.h
//  DonateApp
//
//  Created by Jon on 11/19/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DONSettingsEnum.h"


@interface DONUserSettingsUpdateViewController : UIViewController
@property (nonatomic, strong) NSString *fieldToChange;
@property (nonatomic, strong) NSString *currentFieldValue;
@property (nonatomic, assign) UserInformationSettings validationType;
@end

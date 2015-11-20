//
//  SettingsEnum.m
//  DonateApp
//
//  Created by Jon on 11/19/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, SettingsSection )
{
    SettingsSectionUserInformation,
    SettingsSectionOtherInformation
};

typedef NS_ENUM(NSInteger, UserInformationSettings)
{
    UserInformationSettingsUsername,
    UserInformationSettingsPassword,
    UserInformationSettingsEmail,
    UserInformationSettingsPhoneNumber
};

typedef NS_ENUM(NSInteger, OtherInformationSettings)
{
    OtherInformationSettingsAbout,
    OtherInformationSettingsSignOut
};

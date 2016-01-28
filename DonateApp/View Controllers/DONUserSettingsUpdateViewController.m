//
//  DONUserSettingsUpdateViewController.m
//  DonateApp
//
//  Created by Jon on 11/19/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONUserSettingsUpdateViewController.h"
#import "DONUser.h"
#import "MBProgressHUD.h"

@interface DONUserSettingsUpdateViewController ()
@property (nonatomic, strong) DONUser *currentUser;
@property (weak, nonatomic) IBOutlet UILabel *currentFieldLabel;
@property (weak, nonatomic) IBOutlet UITextField *currentFieldTextField;
@property (weak, nonatomic) IBOutlet UILabel *updatedFieldLabel;

@property (weak, nonatomic) IBOutlet UITextField *updatedFieldTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitButtonTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *confirmationLabel;
@property (weak, nonatomic) IBOutlet UITextField *confirmationTextField;
@end

@implementation DONUserSettingsUpdateViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.currentUser = [DONUser currentUser];
    NSString *title = [NSString stringWithFormat:@"Change %@", self.fieldToChange];
    self.navigationItem.title = title;
    
    [self setupUI];
    [self updateLabels];
}

-(void)setupUI
{
    if (self.validationType == UserInformationSettingsPassword) {
        self.confirmationLabel.hidden = NO;
        self.confirmationTextField.hidden = NO;
        self.submitButtonTopConstraint.active = NO;
        [self.submitButton.topAnchor constraintEqualToAnchor:self.confirmationTextField.bottomAnchor constant:30].active = YES;
        
        self.updatedFieldTextField.secureTextEntry = YES;
        self.confirmationTextField.secureTextEntry = YES;
    }
    
    self.currentFieldTextField.userInteractionEnabled = NO;
}

-(void)updateLabels
{
    self.currentFieldLabel.text = [NSString stringWithFormat:@"Current %@", self.fieldToChange];
    self.currentFieldTextField.text = [NSString stringWithFormat:@"%@", self.currentFieldValue];

    self.updatedFieldLabel.text = [NSString stringWithFormat:@"New %@", self.fieldToChange];
    self.updatedFieldTextField.placeholder = [NSString stringWithFormat:@"%@", self.fieldToChange];
    
    self.confirmationLabel.text = [NSString stringWithFormat:@"Confirm %@", self.fieldToChange];
    self.confirmationTextField.placeholder = [NSString stringWithFormat:@"%@", self.fieldToChange];
}

- (IBAction)submitButtonTapped:(id)sender {
    BOOL validInput = NO;
    NSString *currentInput = self.updatedFieldTextField.text;
    NSString *errorMessage;
    
    switch (self.validationType) {
        case UserInformationSettingsUsername:
            validInput = [self validUsername:currentInput];
            errorMessage = @"Please enter at least 3 characters for your username.";
            break;
            
        case UserInformationSettingsPassword:
            if (![self validPassword:currentInput]) {
                errorMessage = @"Please enter at least 5 characters for your password.";
            } else if (![self validPasswordConfirmation:currentInput confirmation:self.confirmationTextField.text]) {
                errorMessage = @"Please make sure your password and confirmation match.";
            } else {
                validInput = YES;
            }
            break;
            
        case UserInformationSettingsEmail:
            validInput = [self validEmail:currentInput];
            errorMessage = @"Please enter a valid email address.";
            break;
            
        case UserInformationSettingsPhoneNumber:
            validInput = [self validPhoneNumber:currentInput];
            errorMessage = @"Please enter a valid phone number.";
            break;
    }
    
    if (!validInput) {
        [self displayAlertWithMessage:errorMessage];
    } else {
        [self updateParseInformation];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(BOOL)validUsername:(NSString *)username
{
    return username.length > 2;
}

-(BOOL)validEmail:(NSString *)email
{
    NSRegularExpression *emailRegex = [NSRegularExpression regularExpressionWithPattern:@"[^ ]+@[^ ]+\\.[^ ]+" options:0 error:nil];
    NSRange range = NSMakeRange(0, email.length);
    NSArray *matches = [emailRegex matchesInString:email options:0 range:range];
    
    return matches.count > 0;
}

-(BOOL)validPassword:(NSString *)password
{
    return password.length > 4;
}

-(BOOL)validPasswordConfirmation:(NSString *)password confirmation:(NSString *)confirmation
{
    return [password isEqualToString:confirmation];
}

-(BOOL)validPhoneNumber:(NSString *)phoneNumber
{
  NSString *regexString = @"^\\s*(?:\\+?(\\d{1,3}))?[-. (]*(\\d{3})[-. )]*(\\d{3})[-. ]*(\\d{4})(?: *x(\\d+))?\\s*$";
  NSRegularExpression *phoneRegex = [NSRegularExpression regularExpressionWithPattern:regexString options:0 error:nil];
  NSRange range = NSMakeRange(0, phoneNumber.length);
  NSArray *matches = [phoneRegex matchesInString:phoneNumber options:0 range:range];
  
  return matches.count > 0;
}

-(void)displayAlertWithMessage:(NSString *)message
{
    UIAlertController *display = [UIAlertController alertControllerWithTitle:@"Oh No!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Got It" style:UIAlertActionStyleDefault handler:nil];
    
    [display addAction:okAction];
    [self presentViewController:display animated:YES completion:nil];
}

-(void)updateParseInformation
{
    switch (self.validationType) {
        case UserInformationSettingsUsername:
            self.currentUser.username = self.updatedFieldTextField.text;
            break;
            
        case UserInformationSettingsPassword:
            self.currentUser.password = self.updatedFieldTextField.text;
            break;
            
        case UserInformationSettingsEmail:
            self.currentUser.email = self.updatedFieldTextField.text;
            break;
            
        case UserInformationSettingsPhoneNumber:
            self.currentUser.user_phone = self.updatedFieldTextField.text;
            break;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end

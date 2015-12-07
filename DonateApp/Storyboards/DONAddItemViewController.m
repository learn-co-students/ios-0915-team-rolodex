//
//  DONAddItemViewController.m
//  DonateApp
//
//  Created by synesthesia on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONAddItemViewController.h"
#import <CoreLocation/CoreLocation.h>





@interface DONAddItemViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation DONAddItemViewController

//-(void)viewDidAppear:(BOOL)animated{
//
//		[super viewDidAppear:animated];

//}

- (void)viewDidLoad {
		
		self.navigationItem.title = @"Donate Item";
		
		[super viewDidLoad];
		[self setConstraints];
		

		
		self.categorySelect.delegate = self;
		
		
		//initialize location manager and request authorization
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
		
		if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
				[self.locationManager requestWhenInUseAuthorization];
				[self.locationManager startUpdatingLocation];
		}
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTappedImageView)];
		self.selectedImageView.userInteractionEnabled = YES;
		[self.selectedImageView addGestureRecognizer:tapGesture];
		self.selectedImageView.backgroundColor = [UIColor blackColor];
		
		UITapGestureRecognizer *tappedBG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedBackgroundImage)];
		self.containerView.userInteractionEnabled = YES;
		[self.containerView addGestureRecognizer:tappedBG];
		
//		UITapGestureRecognizer *tappedFirstTagInScrollView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTappedFirstTagSelector)];
//		self.firstTag.userInteractionEnabled = YES;
//		[self.firstTag addGestureRecognizer:tappedFirstTagInScrollView];
//				UITapGestureRecognizer *tappedSecondTagInScrollView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTappedSecondTagSelector)];
//		self.secondTag.userInteractionEnabled = YES;
//		[self.secondTag addGestureRecognizer:tappedSecondTagInScrollView];
//				UITapGestureRecognizer *tappedThirdTagInScrollView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTappedThirdTagSelector)];
//		self.thirdTag.userInteractionEnabled = YES;
//		[self.thirdTag addGestureRecognizer:tappedThirdTagInScrollView];
//				UITapGestureRecognizer *tappedFourthTagInScrollView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTappedFourthTagSelector)];
//		self.fourthTag.userInteractionEnabled = YES;
//		[self.fourthTag addGestureRecognizer:tappedFourthTagInScrollView];
		
		UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelClicked)];
		[stopButton setTintColor:[UIColor blackColor]];
		self.navigationItem.leftBarButtonItem = stopButton;
		self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHideOrShow:) name:@"UIKeyboardWillShowNotification" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHideOrShow:) name:@"UIKeyboardWillHideNotification" object:nil];
		
    // Do any additional setup after loading the view.
}


-(void)setConstraints{
#pragma initialization
		
				//initialize storyboard objects
		self.scrollView = [[UIScrollView alloc]init];
		self.containerView = [[UIView alloc]init];
		self.selectedImageView = [[UIImageView alloc]init];
		
		self.useCurrentLocationSwitch = [[UISwitch alloc]init];
		self.useCurrentLocationLabel = [[UILabel alloc]init];
		self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
		self.itemNameTextField = [[UITextField alloc]init];
		self.itemDescriptionTextField= [[UITextField alloc]init];
		self.pickupInstructionsTextField= [[UITextField alloc]init];
//		self.categoriesTextField = [[UITextField alloc]init];
		
		
		//category select
		self.categorySelect = [[UIScrollView alloc] init];
		self.categoryStackView = [[UIStackView alloc]init];
//		self.categoryContentView = [[UIView alloc]init];




		self.firstTag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
		self.firstTag.image = [UIImage imageNamed:@"book"];
		
		self.secondTag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,160, 160)];
		self.secondTag.image = [UIImage imageNamed:@"clothinga"];
		
		self.thirdTag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
		self.thirdTag.image = [UIImage imageNamed:@"book"];
		
		self.fourthTag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,160, 160)];
		self.fourthTag.image = [UIImage imageNamed:@"clothinga"];
		
		self.fifthTag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
		self.fifthTag.image = [UIImage imageNamed:@"book"];
		
		self.sixthTag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
		self.sixthTag.image = [UIImage imageNamed:@"clothinga"];
		
		
		
		
//		self.firstTag = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"book"]];
//		self.secondTag = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clothinga"]];
//		self.thirdTag= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"book"]];
//		self.fourthTag= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clothinga"]];
//		
//		
//		
//		self.fifthTag= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"book"]];
//		self.sixthTag= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clothinga"]];
////		self.seventhTag= [[UIImageView alloc]init];
////		self.eigthTag= [[UIImageView alloc]init];
//
//		NSMutableArray *theImageTags = @[self.firstTag, self.secondTag, self.thirdTag, self.fourthTag, self.fifthTag, self.sixthTag];

		
#pragma view hierarchy

		[self.view addSubview: self.scrollView];
		[self.scrollView addSubview:self.containerView];
		
		//selectimage
		[self.containerView addSubview:self.selectedImageView];
		
		//category select scrollview
		[self.containerView addSubview:self.categorySelect];
		[self.categorySelect addSubview:self.categoryStackView];

		
		//textfields
		[self.containerView addSubview:self.itemNameTextField];
		[self.containerView addSubview:self.itemDescriptionTextField];
		[self.containerView addSubview:self.pickupInstructionsTextField];
//		[self.containerView addSubview:self.categoriesTextField];
		//switch
		[self.containerView addSubview:self.useCurrentLocationLabel];
		[self.containerView addSubview:self.useCurrentLocationSwitch];
		//save
		[self.containerView addSubview:self.saveButton];
		
		
		
		
		
#pragma setConstraints
				//SCROLLVIEW & CONTAINER
		[self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.edges.equalTo(self.view);
		}];
		
		self.containerView.backgroundColor = [UIColor colorWithRed:0.133 green:0.752 blue:0.392 alpha:0.5];
		
		[self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.edges.equalTo(self.scrollView);
				make.top.equalTo(self.selectedImageView);
				make.bottom.equalTo(self.saveButton);
				make.width.equalTo(self.view);
		}];
		
				//IMAGE & Placeholder
		
		UIImage *placeHolderThing = [UIImage imageNamed:@"addPhotoPlaceholder"];
		self.selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
		
		if (![self.selectedImageView.image isEqual:self.itemImage]) {
    self.selectedImageView.image = placeHolderThing;
		}
		[self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.right.equalTo (self.containerView);
				make.top.equalTo(self.containerView);
				make.height.equalTo(@200);
		}];
		
		
		
//categoryselect ScrollView
		
		self.categorySelect.backgroundColor = [UIColor whiteColor];
//		self.categorySelect.directionalLockEnabled = YES;

		
//		self.categoryStackView.layoutMarginsRelativeArrangement = YES;
		
		[self.categorySelect mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.equalTo(self.containerView).offset(25);
				make.right.equalTo(self.containerView).offset(-25);
				make.centerX.equalTo(self.containerView.mas_centerX);
//				make.bottom.equalTo(self.categoriesTextField).offset(-30);
				make.top.equalTo(self.selectedImageView.mas_bottom).offset(30);
				make.height.equalTo(@160);
		}];
		
		
		
		self.firstTag.contentMode = UIViewContentModeScaleAspectFit;
		[self.categoryStackView addArrangedSubview:self.firstTag];
		self.secondTag.contentMode = UIViewContentModeScaleAspectFit;
		[self.categoryStackView addArrangedSubview:self.secondTag];
		self.thirdTag.contentMode = UIViewContentModeScaleAspectFit;
		[self.categoryStackView addArrangedSubview:self.thirdTag];
		self.fourthTag.contentMode = UIViewContentModeScaleAspectFit;
		[self.categoryStackView addArrangedSubview:self.fourthTag];
		self.fifthTag.contentMode = UIViewContentModeScaleAspectFit;
		[self.categoryStackView addArrangedSubview:self.fifthTag];
		self.sixthTag.contentMode = UIViewContentModeScaleAspectFit;
		[self.categoryStackView addArrangedSubview:self.sixthTag];
		
		self.categoryStackView.backgroundColor =[UIColor whiteColor];
		self.categoryStackView.distribution = UIStackViewDistributionFillEqually;
		self.categoryStackView.axis =UILayoutConstraintAxisHorizontal;
		self.categoryStackView.alignment = UIStackViewAlignmentCenter;
		self.categoryStackView.spacing = 10;
		
		
//		NSInteger totalWidth = 0;
////		CGFloat heightOfOneImage = self.firstTag.frame.size.height;
////		
//		for (UIImageView *imageView in theImageTags) {
////
//				totalWidth += imageView.frame.size.width;
//		}
//
//		NSNumber *widthNumber = @(totalWidth);
////
//////		NSString *heightString = [NSString stringWithFormat:@"@%ld", totalWidth];
////
////		
		[self.categoryStackView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.top.bottom.equalTo(self.categorySelect);

				make.center.equalTo(self.categorySelect);
//				make.width.equalTo(@960);
////				make.edges.equalTo(@0);
//				make.width.equalTo(widthNumber);
//				make.right.equalTo(@700);
		}];
		
		
//		self.categorySelect.contentSize = CGSizeMake(self.categoryStackView.frame.size.width * 2, self.categoryStackView.frame.size.height);
//		self.categorySelect.pagingEnabled = YES;
//		self.categorySelect.scrollEnabled = YES;
		
		
		// create blank stackView
		// add it as subview, constrain it, etc
//		for (DONCategory *category in self.DONcategories) {
				// get image, set it to a view and put it in stackview
				// pin its edges with masonry
		
		
		
		
		
		
		
//textFields
		NSString *placeholderName = [NSString stringWithFormat:@"Item Name"];
		NSString *placeholderDescription = [NSString stringWithFormat:@"Item Description"];
		NSString *placeholderPickup = [NSString stringWithFormat:@"Instructions For Pickup"];
		NSString *placeholderCategory = [NSString stringWithFormat:@"What Category Describes Your Item"];

//		self.categoriesTextField.textColor = [UIColor blackColor];
//		self.categoriesTextField.placeholder = placeholderCategory;
//		self.categoriesTextField.textAlignment = NSTextAlignmentCenter;
//		self.categoriesTextField.borderStyle = UITextBorderStyleRoundedRect;
//		
//		[self.categoriesTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//				make.left.equalTo(self.containerView).offset(25);
//				make.right.equalTo(self.containerView).offset(-25);
//				make.centerX.equalTo(self.containerView.mas_centerX);
//				make.bottom.equalTo(self.itemNameTextField.mas_top).offset(-20);
//		}];

		self.itemNameTextField.textColor = [UIColor blackColor];
		self.itemNameTextField.placeholder = placeholderName;
		self.itemNameTextField.textAlignment = NSTextAlignmentCenter;
		self.itemNameTextField.borderStyle = UITextBorderStyleRoundedRect;
		
		[self.itemNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.equalTo(self.containerView).offset(25);
				make.right.equalTo(self.containerView).offset(-25);
				make.centerX.equalTo(self.containerView.mas_centerX);
				make.bottom.equalTo(self.itemDescriptionTextField.mas_top).offset(-20);
		}];
		
		self.itemDescriptionTextField.textColor = [UIColor blackColor];
		self.itemDescriptionTextField.placeholder = placeholderDescription;
		self.itemDescriptionTextField.textAlignment = NSTextAlignmentCenter;
		self.itemDescriptionTextField.borderStyle = UITextBorderStyleRoundedRect;
		
		[self.itemDescriptionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.equalTo(self.containerView).offset(25);
				make.right.equalTo(self.containerView).offset(-25);
				make.centerX.equalTo(self.containerView.mas_centerX);
				make.bottom.equalTo(self.pickupInstructionsTextField.mas_top).offset(-20);

		}];
		
		self.pickupInstructionsTextField.textColor =[UIColor blackColor];
		self.pickupInstructionsTextField.placeholder = placeholderPickup;
		self.pickupInstructionsTextField.textAlignment = NSTextAlignmentCenter;
		self.pickupInstructionsTextField.borderStyle = UITextBorderStyleRoundedRect;
		
		[self.pickupInstructionsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.equalTo(self.containerView).offset(25);
				make.right.equalTo(self.containerView).offset(-25);
				make.centerX.equalTo(self.containerView.mas_centerX);
				make.bottom.equalTo(self.useCurrentLocationLabel.mas_bottom).offset(-50);
		}];
		
		
		
		#pragma LocationSwitch

		[self.useCurrentLocationSwitch addTarget:self action:@selector(useCurrentLocationSwitchTapped) forControlEvents:UIControlEventTouchUpInside];
		
		self.useCurrentLocationLabel.textColor = [UIColor whiteColor];
		self.useCurrentLocationLabel.text = [NSString stringWithFormat:@"Use Current Location?"];
		
		[self.useCurrentLocationSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
				make.right.equalTo(self.containerView.mas_right).offset(-15);
				make.bottom.equalTo(self.saveButton.mas_top).offset(-25);
		}];
		
		[self.useCurrentLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.equalTo(self.containerView.mas_left).offset(25);
				make.bottom.equalTo(self.saveButton.mas_top).offset(-25);
		}];
		
		//save button
		self.saveButton.backgroundColor = [UIColor colorWithRed:0.133 green:0.752 blue:0.392 alpha:1.0];
		self.saveButton.userInteractionEnabled = YES;
		
		NSString *saveTitleLabel = @"SAVE"; NSString *savedTitleLabel = @"ITEM SAVED";
		[self.saveButton setTitle:saveTitleLabel forState:UIControlStateNormal];[self.saveButton setTitle:savedTitleLabel forState:UIControlStateHighlighted];
		self.saveButton.userInteractionEnabled = YES;
		
		[self.saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
		
		[self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.right.equalTo(self.containerView);
				make.top.equalTo(@600);
				make.height.equalTo(@60);
		}];
}


//#pragma categorySelections
//
//-(void)userTappedFirstTagSelector{
//		NSLog(@"firstTagTapped");
//		NSString *householdString = [NSString stringWithFormat:@"Household"];
//		if (![self.categories containsObject:houseHold]) {
//				[self.categories addObject:booksString];

//				NSLog(@"%@", [self.categories lastObject]);
//		self.firstTag.alpha = 0.5;
//}
//		else if ([self.categories containsObject:booksString]) {
//    [self.categories removeObject:booksString];
//		self.firstTag.alpha = 1.0;
//				NSLog(@"removed books from array");
//		}
//}
//-(void)userTappedSecondTagSelector{
//		NSLog(@"2ndTagTapped");
//		NSString *clothingString = [NSString stringWithFormat:@"Clothing"];
//		if (![self.categories containsObject:clothingString]) {
//				[self.categories addObject:clothingString];
//				self.secondTag.alpha = 0.5;
//		}
//		else if ([self.categories containsObject:clothingString]) {
//    [self.categories removeObject:clothingString];
//				self.secondTag.alpha = 1.0;
//				NSLog(@"removed clothing from array");
//		}
//}

//-(void)userTappedThirdTagSelector{
//		NSLog(@"3rdTagTapped");
//		NSString *furnitureString = [NSString stringWithFormat:@"Furniture"];
//		if (![self.categories containsObject:furnitureString]) {
//				[self.categories addObject:furnitureString];
//				self.thirdTag.alpha = 0.5;
//		}
//		else if ([self.categories containsObject:furnitureString]) {
//    [self.categories removeObject:furnitureString];
//				self.thirdTag.alpha = 1.0;
//				NSLog(@"removed furn from array");
//		}
//}
//-(void)userTappedFourthTagSelector{
//		NSLog(@"4thTagTapped");
//		NSString *musicString = [NSString stringWithFormat:@"Music"];
//
//		if (![self.categories containsObject:musicString]) {
//				[self.categories addObject:musicString];
//				self.fourthTag.alpha = 0.5;
//		}
//		else if ([self.categories containsObject:musicString]) {
//    [self.categories removeObject:musicString];
//				self.fourthTag.alpha = 1.0;
//				NSLog(@"removed musicString from array");
//		}
//}

//-(void)userTapped<##>TagSelector{




//		NSLog(@"<##>TagTapped");
//		NSString *<##>String = [NSString stringWithFormat:@"<##>"];
//		
//		if (![self.categories containsObject:<##>]) {
//				[self.categories addObject:<##>String];
//				self.<##>.alpha = 0.5;
//		}
//		else if ([self.categories containsObject:musicString]) {
//    [self.categories removeObject:<##>];
//				self.<##>.alpha = 1.0;
//				NSLog(@"removed from array");
//		}
//}








#pragma keyboard shifty

-(void)UIKeyboardWillHideOrShow:(NSNotification *)notification{

		CGRect finalConstraint = [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];

		if ([notification.name isEqualToString:@"UIKeyboardWillHideNotification"]) {finalConstraint = CGRectZero;}
				CGFloat scrollViewKeyboard = finalConstraint.size.height;
				NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
				
				[UIView animateWithDuration:duration animations:^{
						[self.scrollView setContentOffset:CGPointMake(0, scrollViewKeyboard) animated:YES];
						[self.view layoutIfNeeded];
				}];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//		NSLog(@"%@", [locations lastObject]);
		self.itemLocation = [locations lastObject];
//		NSLog(@"self.itemLocation = %@", self.itemLocation);
}

-(void)cancelClicked{
		[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
		[super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - textfields
 */
- (void)useCurrentLocationSwitchTapped{
PFGeoPoint *nilGeoPoint = [PFGeoPoint geoPointWithLatitude:1.0 longitude:-1.0];

		if (!self.useCurrentLocationSwitch.isOn) {
				[self.locationManager stopUpdatingLocation];
				self.locationPF = nilGeoPoint;
							NSLog(@"current location switch is NOT on, self.itemLocation= %@", self.itemLocation);
		}
}

-(void)saveButtonTapped{
		[self.locationManager stopUpdatingLocation];
		
		SCLAlertView *alert = [[SCLAlertView alloc]init];
		alert.customViewColor =  [UIColor colorWithRed:33.0/255.0 green:192.0/255.0 blue:100.0/255.0 alpha:1];
		alert.showAnimationType = FadeIn;
		alert.hideAnimationType = FadeOut;

		
		
		
		DONItem *item = (DONItem*)[PFObject objectWithClassName:@"DONItem"];
		
		
//		
//		if (self.selectedImageView.image == nil||NULL) {
//				
//		}
		
		if (self.itemImage !=nil||NULL) {
				NSData *imageData = UIImageJPEGRepresentation(self.itemImage, 0.8);
				self.itemImagePF = [PFFile fileWithName:@"photo.jpg" data:imageData];
		} else {
				[alert showWarning:self title:@"Image Required" subTitle:@"Please add an image" closeButtonTitle:@"OK" duration:0.0f];
		}
		
		self.categoryString = self.categoriesTextField.text;
		item[@"categoryString"] = self.categoryString;
		
		if (self.categoryString.length <3) {
				NSLog(@"self.categories is nil");
				[alert showWarning:self title:@"Category Required" subTitle:@"Please select an item category" closeButtonTitle:@"OK" duration:0.0f];
		}
		
		self.name =	self.itemNameTextField.text;
		item[@"name"] = self.name;

		if (self.name.length<3) {
				[alert showWarning:self title:@"Incomplete Name" subTitle:@"Please finish entering name" closeButtonTitle:@"OK" duration:0.0f];
		}
		
		self.itemDescription = self.itemDescriptionTextField.text;
		item[@"itemDescription"] = self.itemDescription;
		if (self.itemDescription.length <3) {
				[alert showWarning:self title:@"Incomplete Description" subTitle:@"Please complete description" closeButtonTitle:@"OK" duration:0.0f];
		}
		
		self.pickupInstructions =	self.pickupInstructionsTextField.text;
		item[@"pickupInstructions"] = self.pickupInstructions;
		if (self.pickupInstructions.length <3) {
				[alert showWarning:self title:@"Incomplete Instructions" subTitle:@"Please complete pickup instructions" closeButtonTitle:@"OK" duration:0.0f];
		}
		[alert alertIsDismissed:^{
				NSLog(@"SCLAlertView dismissed!");
		}];
		
		
		
		self.listedBy = [DONUser currentUser];
		if (self.listedBy) { item[@"listedBy"] = self.listedBy;}
		
		if (!self.locationPF) {self.locationPF = [PFGeoPoint geoPointWithLocation:self.itemLocation];}
		item[@"location"] = self.locationPF;
		self.views = @0;
		item[@"views"] = self.views;
		if (self.itemImage) {
    item[@"image"] = self.itemImagePF;
		}
		
		
		if (self.categoryString.length>=3 & self.name.length>=3 & self.itemDescription.length>=3 & self.pickupInstructions.length>=3 &(self.itemImage!=nil)) {

				[alert showWaiting:self title:@"Please Wait" subTitle:@"loading" closeButtonTitle:nil duration:3.0f];
				
				[item saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
						NSLog(@"succeeded? %d, with error: %@", succeeded, error.localizedDescription);
						if (succeeded) {
										//						[alert showNotice:self title:@"Success" subTitle:@"Item Uploaded" closeButtonTitle:@"Done" duration:0.2f];
								[self dismissViewControllerAnimated:YES completion:^{
										NSLog(@"VC dismissed");
								}];
						}
				}];
		}
		
		
}


-(void)userTappedBackgroundImage {
		[self.itemNameTextField resignFirstResponder];
		[self.itemDescriptionTextField resignFirstResponder];
		[self.pickupInstructionsTextField resignFirstResponder];
		[self.categoriesTextField resignFirstResponder];
				//		[self.view endEditing:TRUE];
}

 #pragma mark - imageUpload
-(void)userTappedImageView{
				//initialize picker controller
		UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
				//set self as delegated
		pickerController.delegate = self;
				//present picker controller
		[self presentViewController:pickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
		self.itemImage = info[UIImagePickerControllerOriginalImage];
		self.selectedImageView.image = self.itemImage;
				//for PNG
				//		NSData *imageData = UIImagePNGRepresentation(image);
				//    PFFile *imageFile = [PFFile fileWithName:@"photo.png" data:imageData];
		[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
		NSLog(@"user canceled image pick");
		[self dismissViewControllerAnimated:YES completion:nil];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */







@end

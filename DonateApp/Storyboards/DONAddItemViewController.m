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
		[super viewDidLoad];
//		[self validationAlerts];
		[self setConstraints];
		
		
//		//guang stuff
//		
//		[self searchBarCellStyle];
//		[self getCategoryWithBlock:^(BOOL success) {
//				NSLog(@"get the catoory");
//		}];
//		
//		self.collectionView.dataSource = self;
//		self.collectionView.delegate = self;
//		
//		//end guang stuff
//		
		
//		self.categorySelect.delegate = self;
		
		
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
		
		self.navigationItem.title = @"Donate Item";
		
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
		self.categoriesTextField = [[UITextField alloc]init];
		
		//guang objects
//		self.queryCollection = [[UICollectionView alloc]init];
//		self.collectionView = [[UICollectionView alloc]init];
//		self.searchCollectionView = [[UICollectionView alloc]init];
		
		
#pragma view hierarchy

		[self.view addSubview: self.scrollView];
		[self.scrollView addSubview:self.containerView];
				//selectimage
		[self.containerView addSubview:self.selectedImageView];
				//textfields
		
		[self.containerView addSubview:self.itemNameTextField];
		[self.containerView addSubview:self.itemDescriptionTextField];
		[self.containerView addSubview:self.pickupInstructionsTextField];
		[self.containerView addSubview:self.categoriesTextField];
		//switch
		[self.containerView addSubview:self.useCurrentLocationLabel];
		[self.containerView addSubview:self.useCurrentLocationSwitch];
		//save
		[self.containerView addSubview:self.saveButton];
		
		//guang
//		
//		[self.containerView addSubview:self.queryCollection];
//		[self.containerView addSubview:self.collectionView];
//		[self.containerView addSubview:self.searchCollectionView];
		
		
		
		
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
		
				//		UIImage *placeholderImage = [[UIImage imageNamed:@"addPhotoPlaceholder"] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 25, 50, 25)];
				//		placeholderImage = [placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		
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
		
//textFields
		NSString *placeholderName = [NSString stringWithFormat:@"Item Name"];
		NSString *placeholderDescription = [NSString stringWithFormat:@"Item Description"];
		NSString *placeholderPickup = [NSString stringWithFormat:@"Instructions For Pickup"];
		NSString *placeholderCategory = [NSString stringWithFormat:@"What Category Describes Your Item"];

		self.categoriesTextField.textColor = [UIColor blackColor];
		self.categoriesTextField.placeholder = placeholderCategory;
		self.categoriesTextField.textAlignment = NSTextAlignmentCenter;
		self.categoriesTextField.borderStyle = UITextBorderStyleRoundedRect;
		
		[self.categoriesTextField mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.equalTo(self.containerView).offset(25);
				make.right.equalTo(self.containerView).offset(-25);
				make.centerX.equalTo(self.containerView.mas_centerX);
				make.bottom.equalTo(self.itemNameTextField.mas_top).offset(-20);
		}];

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
//		NSString *booksString = [NSString stringWithFormat:@"Books"];
//		if (![self.categories containsObject:booksString]) {
//				[self.categories addObject:booksString];
//						NSLog(@"added books to array");
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
//

//
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//		
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
		
	
		
//		[self validationAlerts];
		[self.locationManager stopUpdatingLocation];
		self.listedBy = [DONUser currentUser];
		self.views = @0;
		
		if (self.selectedImageView.image !=nil) {
				NSData *imageData = UIImageJPEGRepresentation(self.itemImage, 0.8);
				self.itemImagePF = [PFFile fileWithName:@"photo.jpg" data:imageData];
		}
		
		DONItem *item = (DONItem*)[PFObject objectWithClassName:@"DONItem"];
				//		[item addCategory:self.category withCompletion:^(BOOL success) {NSLog(@" added category %@ to item", self.category);}];
		if (self.selectedImageView.image !=nil)
		{item[@"image"] = self.itemImagePF;}
		
		self.categoryString = self.categoriesTextField.text;
		item[@"categoryString"] = self.categoryString;
		self.name =	self.itemNameTextField.text;
		item[@"name"] = self.name;
		self.itemDescription = self.itemDescriptionTextField.text;
		item[@"itemDescription"] = self.itemDescription;
		self.pickupInstructions =	self.pickupInstructionsTextField.text;
		item[@"pickupInstructions"] = self.pickupInstructions;
		if (self.listedBy) { item[@"listedBy"] = self.listedBy;}
		if (!self.locationPF) {self.locationPF = [PFGeoPoint geoPointWithLocation:self.itemLocation];}
		item[@"location"] = self.locationPF;
		item[@"views"] = self.views;
		
		
		
		SCLAlertView *alert = [[SCLAlertView alloc]init];
		alert.customViewColor =  [UIColor colorWithRed:33.0/255.0 green:192.0/255.0 blue:100.0/255.0 alpha:1];
		alert.showAnimationType = FadeIn;
		alert.hideAnimationType = FadeOut;
		
		if (self.categoryString.length <3) {
				NSLog(@"self.categories is nil");
				[alert showWarning:self title:@"Category Required" subTitle:@"Please select an item category" closeButtonTitle:@"OK" duration:0.0f];
		}
		if (self.selectedImageView.image == nil) {
				NSLog(@"selectedImageView.image is nil");
				[alert showWarning:self title:@"Image Required" subTitle:@"Please add an image" closeButtonTitle:@"OK" duration:0.0f];
		}
		if (self.name.length<3) {
				[alert showWarning:self title:@"Incomplete Name" subTitle:@"Please finish entering name" closeButtonTitle:@"OK" duration:0.0f];
		}
		if (self.itemDescription.length <3) {
				[alert showWarning:self title:@"Incomplete Description" subTitle:@"Please complete description" closeButtonTitle:@"OK" duration:0.0f];
		}
		if (self.pickupInstructions.length <3) {
				[alert showWarning:self title:@"Incomplete Instructions" subTitle:@"Please complete pickup instructions" closeButtonTitle:@"OK" duration:0.0f];
		}
		[alert alertIsDismissed:^{
				NSLog(@"SCLAlertView dismissed!");
		}];
		
		

		
		
		if (self.categoryString.length>=3 & self.name.length>=3 & self.itemDescription.length>=3 & self.pickupInstructions.length>=3 &(self.selectedImageView.image !=nil)) {

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





#pragma guangStuff

//-(void)collectionView:(UICollectionView ​*)collectionView didSelectItemAtIndexPath:(NSIndexPath *​)indexPath  {
//		
//		
//		if (collectionView == self.searchCollectionView) {
//				NSLog(@"I tapped searchCollectionView");
//				self.searchSelectionLabel.text = [self.allCategory[indexPath.row] name];
//				
//				UILabel * selectedlabel = [ UILabel new ];
//				selectedlabel = self.stackedViewLables.arrangedSubviews[indexPath.row];
//				selectedlabel.hidden = ! selectedlabel.hidden;
//		}
//}
//
//#pragma mark stackView methods
//		//for the search feature when tap icon the names shows up under
//
//-(void)makeTheStackOfcats{
//		self.stackedViewLables.backgroundColor = [UIColor blackColor];
//		for (DONCategory * eachCat in self.allCategory) {
//				UILabel * catLabel = [[UILabel alloc] init];
//				catLabel.text = eachCat.name;
//				catLabel.textColor = [UIColor whiteColor];
//				catLabel.backgroundColor = [UIColor blackColor];
//				catLabel.hidden = YES;
//				[self.stackedViewLables addArrangedSubview:catLabel];
//		}
//}
//
//
//-(void)searchBarCellStyle{
//		UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//		flowLayout.itemSize = CGSizeMake(60, 60);
//		flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // add vertical
//		self.searchCollectionView.collectionViewLayout = flowLayout;
//}
//
//#pragma mark  data
//
//-(void)getCategoryWithBlock:(void (^)(BOOL success))completationBlock{
//		
//		[DONCategory allCategoriesWithCompletion:^(BOOL success, NSArray *categories){
//				if (success){
//						self.allCategory = [NSMutableArray new];
//						self.allCategory = categories.mutableCopy;
//						NSLog(@"self.allCategory %@",self.allCategory);
//						[self.searchCollectionView reloadData];
//				}
//		}];
//}
//
//
//
//



@end

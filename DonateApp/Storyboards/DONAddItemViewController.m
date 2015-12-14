//
//  DONAddItemViewController.m
//  DonateApp
//
//  Created by synesthesia on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONAddItemViewController.h"


@interface DONAddItemViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView *placeholderImageView;

@end

@implementation DONAddItemViewController


static NSString * const reuseIdentifier = @"cell";



//set
//write up readme


- (void)viewDidLoad {
		
		self.categoriesForItem = [NSMutableArray new];
		self.navigationItem.title = @"Donate Item";
		
		[super viewDidLoad];
		
		
		UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
		[layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
		layout.minimumInteritemSpacing = 5.0;
		layout.itemSize = CGSizeMake(65, 65);
		CGRect defaultRect = CGRectMake(0, 0, 65, 65);
		
		
		self.collectionView = [[UICollectionView alloc]initWithFrame:defaultRect collectionViewLayout:layout];
		self.collectionView.dataSource = self;
		self.collectionView.delegate = self;
		self.collectionView.allowsMultipleSelection = YES;
		self.collectionView.userInteractionEnabled = YES;
		
		[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
		self.collectionView.backgroundColor = [UIColor whiteColor];
		
		self.firstTag = [[UIImageView alloc] initWithFrame:defaultRect];
		self.firstTag.image = [UIImage imageNamed:@"books"];
		self.secondTag = [[UIImageView alloc] initWithFrame:defaultRect];
		self.secondTag.image = [UIImage imageNamed:@"furniture"];
		self.thirdTag = [[UIImageView alloc] initWithFrame:defaultRect];
		self.thirdTag.image = [UIImage imageNamed:@"clothing"];
		self.fourthTag = [[UIImageView alloc] initWithFrame:defaultRect];
		self.fourthTag.image = [UIImage imageNamed:@"music"];
		self.fifthTag = [[UIImageView alloc] initWithFrame:defaultRect];
		self.fifthTag.image = [UIImage imageNamed:@"electronics"];
		self.sixthTag = [[UIImageView alloc] initWithFrame:defaultRect];
		self.sixthTag.image = [UIImage imageNamed:@"games"];
		self.seventhTag = [[UIImageView alloc] initWithFrame:defaultRect];
		self.seventhTag.image = [UIImage imageNamed:@"household"];
		self.eighthTag = [[UIImageView alloc] initWithFrame:defaultRect];
		self.eighthTag.image = [UIImage imageNamed:@"misc"];
		
		self.firstTagString = [NSString stringWithFormat:@"books"];
		self.secondTagString = [NSString stringWithFormat:@"furniture"];
		self.thirdTagString = [NSString stringWithFormat:@"clothing"];
		self.fourthTagString = [NSString stringWithFormat:@"music"];
		self.fifthTagString = [NSString stringWithFormat:@"electronics & appliances"];
		self.sixthTagString = [NSString stringWithFormat:@"games & hobbies"];
		self.seventhTagString = [NSString stringWithFormat:@"home & garden"];
		self.eighthTagString = [NSString stringWithFormat:@"misc"];
		
		self.categories = [NSArray mutableCopy];
		self.categories = @[self.firstTagString, self.secondTagString, self.thirdTagString, self.fourthTagString, self.fifthTagString, self.sixthTagString,self.seventhTagString,self.eighthTagString];
		self.categoriesImageViews = @[self.firstTag, self.secondTag, self.thirdTag, self.fourthTag, self.fifthTag, self.sixthTag, self.seventhTag, self.eighthTag];
		
		
		[self setConstraints];
		
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
		
		
		UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelClicked)];
		[stopButton setTintColor:[UIColor blackColor]];
		self.navigationItem.leftBarButtonItem = stopButton;
		self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHideOrShow:) name:@"UIKeyboardWillShowNotification" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHideOrShow:) name:@"UIKeyboardWillHideNotification" object:nil];
		
    // Do any additional setup after loading the view.
    
    self.placeholderImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.placeholderImageView];
    [self.placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.selectedImageView).insets(UIEdgeInsetsMake(40, 40, 40, 40));
    }];
    self.placeholderImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.placeholderImageView.image = [UIImage imageNamed:@"addPhotoPlaceholder"];
    
}


-(void)setConstraints{
#pragma initialization
		
				//initialize storyboard objects
		
		
		
		self.useCurrentLocationSwitch = [[UISwitch alloc]init];
		self.useCurrentLocationLabel = [[UILabel alloc]init];
		self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
//		self.itemNameTextField = [[UITextField alloc]init];
//		self.itemDescriptionTextField= [[UITextField alloc]init];
//		self.pickupInstructionsTextField= [[UITextField alloc]init];

#pragma view hierarchy
		
		//make scrollview view
		self.scrollView = [[UIScrollView alloc]init];
		[self.view addSubview: self.scrollView];
		[self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.right.bottom.equalTo(self.view);
				make.top.equalTo(self.mas_topLayoutGuideBottom);
		}];
		//make containerView
		self.containerView = [[UIView alloc]init];
		[self.scrollView addSubview:self.containerView];
		
		[self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.edges.equalTo(self.scrollView);
				make.bottom.equalTo(self.scrollView.mas_bottom);
		
				// remove this dummy value later
				make.height.equalTo(@750);
		}];
		
		//make imageView
		 self.selectedImageView = [[UIImageView alloc]init];
		[self.containerView addSubview:self.selectedImageView];
		
		[self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.top.left.right.equalTo(self.containerView);

				
		}];
		
		
		self.collectionContainerView = [[UIView alloc]init];
		[self.containerView addSubview:self.collectionContainerView];
		
		[self.collectionContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(self.selectedImageView.mas_bottom).offset(20);
				make.left.right.width.equalTo(self.containerView);
				make.height.equalTo(@100);
//				make.bottom.equalTo(self.itemNameTextField.mas_top);
//				make.height.width.equalTo(@65);
		}];
		
		[self.collectionContainerView addSubview:self.collectionView];
		
		[self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(self.selectedImageView.mas_bottom);
		}];
		
		
	
//				//textfields
//		[self.containerView addSubview:self.itemNameTextField];
//		[self.containerView addSubview:self.itemDescriptionTextField];
//		[self.containerView addSubview:self.pickupInstructionsTextField];
//		
//				//switch
//		[self.containerView addSubview:self.useCurrentLocationLabel];
//		[self.containerView addSubview:self.useCurrentLocationSwitch];
//				//save
//		[self.containerView addSubview:self.saveButton];
//		
//		self.containerView.backgroundColor = [UIColor colorWithRed:0.133 green:0.752 blue:0.392 alpha:0.5];
//		self.view.backgroundColor = [UIColor grayColor];
//		self.collectionContainerView.backgroundColor = [UIColor blackColor];
//		self.scrollView.backgroundColor = [UIColor whiteColor];
//		
		
#pragma setConstraints
				//SCROLLVIEW & CONTAINER
//		[self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//				make.edges.equalTo(self.view);
//		}];
//		
//				//collectionview
//		[self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//				make.height.equalTo(@65);
//				make.left.equalTo(self.collectionContainerView).offset(25);
//				make.right.equalTo(self.collectionContainerView).offset(-25);
//				make.centerX.equalTo(self.collectionContainerView.mas_centerX);
//				make.top.equalTo(self.selectedImageView.mas_bottom).offset(20);
//		}];
//		
//		[self.collectionContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
//				make.left.right.top.equalTo(self.scrollView);
//						//				make.top.equalTo(self.selectedImageView);
//				make.bottom.equalTo(self.collectionView.mas_bottom);
//						//				make.bottom.equalTo(self.containerView.mas_top);
//						//				make.height.equalTo(@300);
//				make.width.equalTo(self.view);
//		}];
//		
//		
//		[self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
////				make.left.right.bottom.equalTo(self.scrollView);
//				make.left.right.equalTo(self.scrollView);
//				make.bottom.equalTo(self.view);
//				make.top.equalTo(self.collectionContainerView.mas_bottom);
//				
////				make.top.equalTo(self.collectionContainerView.mas_bottom);
////				make.height.equalTo(@250);
////						//				make.bottom.equalTo(self.saveButton);
////				make.width.equalTo(self.view);
////		}];
//		
//				//IMAGE & Placeholder
//		self.selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
//		
//		[self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//				make.left.right.equalTo (self.collectionContainerView);
//				make.top.equalTo(self.collectionContainerView);
//				make.width.equalTo(self.view);
//				make.height.equalTo(@250);
//				
//		}];
//		
//		
//
//		
//		self.collectionView.scrollEnabled = YES;
//		
//		self.collectionView.showsHorizontalScrollIndicator = YES;
//		
//		
//				//textFields
//		NSString *placeholderName = [NSString stringWithFormat:@"Item Name"];
//		NSString *placeholderDescription = [NSString stringWithFormat:@"Item Description"];
//		NSString *placeholderPickup = [NSString stringWithFormat:@"Instructions For Pickup"];
//		
//		self.itemNameTextField.textColor = [UIColor blackColor];
//		self.itemNameTextField.placeholder = placeholderName;
//		self.itemNameTextField.textAlignment = NSTextAlignmentCenter;
//		self.itemNameTextField.borderStyle = UITextBorderStyleRoundedRect;
//		
//		[self.itemNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//				make.top.equalTo(self.collectionContainerView.mas_bottom);
//				make.left.equalTo(self.containerView).offset(25);
//				make.right.equalTo(self.containerView).offset(-25);
//				make.centerX.equalTo(self.containerView.mas_centerX);
//				make.bottom.equalTo(self.itemDescriptionTextField.mas_top).offset(-20);
//		}];
//		
//		self.itemDescriptionTextField.textColor = [UIColor blackColor];
//		self.itemDescriptionTextField.placeholder = placeholderDescription;
//		self.itemDescriptionTextField.textAlignment = NSTextAlignmentCenter;
//		self.itemDescriptionTextField.borderStyle = UITextBorderStyleRoundedRect;
//		
//		[self.itemDescriptionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//				make.left.equalTo(self.containerView).offset(25);
//				make.right.equalTo(self.containerView).offset(-25);
//				make.centerX.equalTo(self.containerView.mas_centerX);
//				make.bottom.equalTo(self.pickupInstructionsTextField.mas_top).offset(-20);
//				
//		}];
//		
//		self.pickupInstructionsTextField.textColor =[UIColor blackColor];
//		self.pickupInstructionsTextField.placeholder = placeholderPickup;
//		self.pickupInstructionsTextField.textAlignment = NSTextAlignmentCenter;
//		self.pickupInstructionsTextField.borderStyle = UITextBorderStyleRoundedRect;
//		
//		[self.pickupInstructionsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//				make.left.equalTo(self.containerView).offset(25);
//				make.right.equalTo(self.containerView).offset(-25);
//				make.centerX.equalTo(self.containerView.mas_centerX);
//				make.bottom.equalTo(self.useCurrentLocationLabel.mas_bottom).offset(-50);
//		}];
//		
//		
		
#pragma LocationSwitch
//		
//		[self.useCurrentLocationSwitch addTarget:self action:@selector(useCurrentLocationSwitchTapped) forControlEvents:UIControlEventTouchUpInside];
//		
//		self.useCurrentLocationLabel.textColor = [UIColor blackColor];
//		self.useCurrentLocationLabel.text = [NSString stringWithFormat:@"Use Current Location?"];
//		
//		[self.useCurrentLocationSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
//				make.right.equalTo(self.containerView.mas_right).offset(-15);
//				make.bottom.equalTo(self.saveButton.mas_top).offset(-25);
//		}];
//		
//		[self.useCurrentLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//				make.left.equalTo(self.containerView.mas_left).offset(25);
//				make.bottom.equalTo(self.saveButton.mas_top).offset(-25);
//		}];
//		
//				//save button
//		self.saveButton.backgroundColor = [UIColor colorWithRed:0.133 green:0.752 blue:0.392 alpha:1.0];
//		self.saveButton.userInteractionEnabled = YES;
//		
//		NSString *saveTitleLabel = @"SAVE"; NSString *savedTitleLabel = @"ITEM SAVED";
//		[self.saveButton setTitle:saveTitleLabel forState:UIControlStateNormal];[self.saveButton setTitle:savedTitleLabel forState:UIControlStateHighlighted];
//		self.saveButton.userInteractionEnabled = YES;
//		
//		[self.saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
//		
//		[self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
//				make.left.right.equalTo(self.containerView);
//				make.bottom.equalTo(self.scrollView.mas_bottom).offset(-20);
//				make.height.equalTo(@60);
//		}];
}

//
//
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
		return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
		return self.categories.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{



		NSLog(@"cellForItemAtIndexPath getting called: \n\n\n\n");
		UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
		cell.userInteractionEnabled = YES;
		[[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

		UIImageView *imageView =self.categoriesImageViews[indexPath.row];
		imageView.userInteractionEnabled = YES;
		[cell.contentView addSubview:imageView];
		cell.contentView.userInteractionEnabled = YES;

		return cell;
}

//
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//
//		NSLog(@"We're calling didselectItemAtIndexPath");
//		
//		[self.categoriesForItem addObject:self.categories[indexPath.row]];
//		
//		
//		
//		UIImageView *currentImageView = self.categoriesImageViews[indexPath.row];
//		
//		currentImageView.alpha = 0.5;
//		
//		
//
//}
//
//
//		 
//-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//
//		
//		
//		[self.categoriesForItem removeObject:self.categories[indexPath.row]];
//	
//		
//		UIImageView *currentImageView = self.categoriesImageViews[indexPath.row];
//		
//		currentImageView.alpha = 1.0;
//		
//}
//
//
//

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
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
////		NSLog(@"%@", [locations lastObject]);
//		self.itemLocation = [locations lastObject];
////		NSLog(@"self.itemLocation = %@", self.itemLocation);
//}
//
//-(void)cancelClicked{
//		[self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)didReceiveMemoryWarning {
//		[super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)useCurrentLocationSwitchTapped{
//
//		if (self.useCurrentLocationSwitch.isOn) {
//		self.locationPF = [PFGeoPoint geoPointWithLocation:self.itemLocation];
//		
//		[self.locationManager stopUpdatingLocation];
//		NSLog(@"current location switch is on, self.itemLocation= %@", self.itemLocation);
//		}
//		
//		else if (!self.useCurrentLocationSwitch.isOn) {
//				self.locationPF = nil;
//		}
//}
////
//-(void)saveButtonTapped{
//		[self.locationManager stopUpdatingLocation];
//		
//		SCLAlertView *alert = [[SCLAlertView alloc]init];
//		alert.customViewColor =  [UIColor colorWithRed:33.0/255.0 green:192.0/255.0 blue:100.0/255.0 alpha:1];
//		alert.showAnimationType = FadeIn;
//		alert.hideAnimationType = FadeOut;
//
//		
//		
//		
//		DONItem *item = (DONItem*)[PFObject objectWithClassName:@"DONItem"];
//		
//		
//		
//		if (self.itemImage !=nil||NULL) {
//				NSData *imageData = UIImageJPEGRepresentation(self.itemImage, 0.8);
//				self.itemImagePF = [PFFile fileWithName:@"photo.jpg" data:imageData];
//		} else {
//								[self presentAlertController:@"Item Image"];
////				[alert showWarning:self title:@"Image Required" subTitle:@"Please add an image" closeButtonTitle:@"OK" duration:0.0f];
//		}
//		
//		
//		self.name =	self.itemNameTextField.text;
//		item[@"name"] = self.name;
//
//		if (self.name.length<3) {
//						[self presentAlertController:@"Item Name"];
////				[alert showWarning:self title:@"Incomplete Name" subTitle:@"Please finish entering name" closeButtonTitle:@"OK" duration:0.0f];
//		}
//		
//		self.itemDescription = self.itemDescriptionTextField.text;
//		item[@"itemDescription"] = self.itemDescription;
//		if (self.itemDescription.length <3) {
//		
//				[self presentAlertController:@"Item Description"];
////				[alert showWarning:self title:@"Incomplete Description" subTitle:@"Please complete description" closeButtonTitle:@"OK" duration:0.0f];
//		}
//		self.pickupInstructions =	self.pickupInstructionsTextField.text;
//		item[@"pickupInstructions"] = self.pickupInstructions;
//		if (self.pickupInstructions.length <3) {
//				
//				[self presentAlertController:@"Pickup Instructions"];
//				
////				[alert showWarning:self title:@"Incomplete Instructions" subTitle:@"Please complete pickup instructions" closeButtonTitle:@"OK" duration:0.0f];
//		}
//		[alert alertIsDismissed:^{
//				NSLog(@"SCLAlertView dismissed!");
//		}];
//		
//		
//		self.listedBy = [DONUser currentUser];
//		if (self.listedBy) { item[@"listedBy"] = self.listedBy;}
//		
//		if (self.locationPF) {
//		item[@"location"] = self.locationPF;}
//		self.views = @0;
//		item[@"views"] = self.views;
//		if (self.itemImage) {
//    item[@"image"] = self.itemImagePF;
//		}
//		if (!self.categoriesForItem.count) {
//				[self.categoriesForItem addObject:self.eighthTagString];
//		}
//		NSLog(@"self.categoriesForItem contains %@", [self.categoriesForItem lastObject]);
//		
//		if ( self.name.length>=3 & self.itemDescription.length>=3 & self.pickupInstructions.length>=3 &(self.itemImage!=nil)) {
//
//				[alert showWaiting:self title:@"Success" subTitle:@"Uploading your donation, please wait" closeButtonTitle:nil duration:3.0f];
//				
//				
//				
//				
//				[DONCategory categoryWithName:self.categoriesForItem[0] withCompletion:^(BOOL success, DONCategory *category) {
//								item[@"categories"] = @[category];
//						
//				[item saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//				NSLog(@"succeeded? %d, with error: %@", succeeded, error.localizedDescription);
//						if (succeeded) {
//
//								[self dismissViewControllerAnimated:YES completion:^{
//		
//								}];
//						}
//				}];
//		}];
//}
//}
//
//
//-(void)userTappedBackgroundImage {
//		[self.itemNameTextField resignFirstResponder];
//		[self.itemDescriptionTextField resignFirstResponder];
//		[self.pickupInstructionsTextField resignFirstResponder];
//				//		[self.view endEditing:TRUE];
//}
//
// #pragma mark - imageUpload
//-(void)userTappedImageView{
//				//initialize picker controller
//		UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
//				//set self as delegated
//		pickerController.delegate = self;
//				//present picker controller
//		[self presentViewController:pickerController animated:YES completion:nil];
//}
//
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//		self.itemImage = info[UIImagePickerControllerOriginalImage];
//		self.selectedImageView.image = self.itemImage;
//				//for PNG
//				//		NSData *imageData = UIImagePNGRepresentation(image);
//				//    PFFile *imageFile = [PFFile fileWithName:@"photo.png" data:imageData];
//		[self dismissViewControllerAnimated:YES completion:nil];
//    self.placeholderImageView.hidden = YES;
//}
//
//-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//		NSLog(@"user canceled image pick");
//		[self dismissViewControllerAnimated:YES completion:nil];
//}
///*
// #pragma mark - Navigation
// 
// // In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// // Get the new view controller using [segue destinationViewController].
// // Pass the selected object to the new view controller.
// }
// */
//
//
////for when UIAlertView in SCLAlertView becomes unresponsive
//-(UIAlertController *)presentAlertController:(NSString *)fieldName {
//		
//
//		
//		NSString *alertMessage = [NSString stringWithFormat:@"%@ field is incomplete",fieldName];
//		
//		self.alertController = [UIAlertController alertControllerWithTitle:@"Missing Field" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
//		
//		self.alertController.view.tintColor = [UIColor grayColor];
//		self.alertController.view.layer.borderWidth = 2.0;
//		self.alertController.view.layer.borderColor = [UIColor darkGrayColor].CGColor;
//		self.alertController.view.layer.cornerRadius = 5.0;
//		self.alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//		
//		[self.alertController addAction:self.alertAction];
//		
//		[self presentViewController:self.alertController animated:YES completion:nil];
//		
//		return self.alertController;
//
//}
//




@end

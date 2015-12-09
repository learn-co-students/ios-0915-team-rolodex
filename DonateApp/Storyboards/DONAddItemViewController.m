//
//  DONAddItemViewController.m
//  DonateApp
//
//  Created by synesthesia on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONAddItemViewController.h"


@interface DONAddItemViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation DONAddItemViewController
		//-(void)viewDidAppear:(BOOL)animated{
		//
		//		[super viewDidAppear:animated];

		//}


static NSString * const reuseIdentifier = @"cell";

//make new pfitem *itemInProgress and modify it with John's methods with vc methods


-(void)collectionViewIsh{
		
		

		UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
		[layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
		layout.minimumInteritemSpacing = 5.0;
		layout.itemSize = CGSizeMake(120, 120);
		CGRect defaultRect = CGRectMake(0, 0, 120, 120);

		
		self.collectionView = [[UICollectionView alloc]initWithFrame:defaultRect collectionViewLayout:layout];
		self.collectionView.dataSource = self;
		self.collectionView.delegate = self;
		self.collectionView.allowsMultipleSelection = YES;
		self.collectionView.userInteractionEnabled = YES;
		
		[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
		self.collectionView.backgroundColor = [UIColor whiteColor];
		
		self.firstTag = [[UIImageView alloc] initWithFrame:defaultRect];
		self.firstTag.image = [UIImage imageNamed:@"book"];
		
		self.secondTag = [[UIImageView alloc] initWithFrame:defaultRect];
		self.secondTag.image = [UIImage imageNamed:@"furniture"];
		
		self.thirdTag = [[UIImageView alloc] initWithFrame:defaultRect];
		self.thirdTag.image = [UIImage imageNamed:@"clothing"];
		
		self.fourthTag = [[UIImageView alloc] initWithFrame:defaultRect];
		self.fourthTag.image = [UIImage imageNamed:@"music"];
		
		self.fifthTag = [[UIImageView alloc] initWithFrame:defaultRect];
		self.fifthTag.image = [UIImage imageNamed:@"electronics"];
		
		self.sixthTag = [[UIImageView alloc] initWithFrame:defaultRect];
		self.sixthTag.image = [UIImage imageNamed:@"game"];
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
		self.eighthTagString = [NSString stringWithFormat:@"other"];
		
		self.categories = [NSArray mutableCopy];
		self.categories = @[self.firstTagString, self.secondTagString, self.thirdTagString, self.fourthTagString, self.fifthTagString, self.sixthTagString,self.seventhTagString,self.eighthTagString];
		self.categoriesImageViews = @[self.firstTag, self.secondTag, self.thirdTag, self.fourthTag, self.fifthTag, self.sixthTag, self.seventhTag, self.eighthTag];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
		return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
		return self.categories.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

		UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
		cell.userInteractionEnabled = YES;
		[[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

		UIImageView *imageView =self.categoriesImageViews[indexPath.row];
		imageView.userInteractionEnabled = YES;
		[cell.contentView addSubview:imageView];
		cell.contentView.userInteractionEnabled = YES;
//
//		
//		[self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//		[self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
//		
		return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

		NSLog(@"We're calling didselectItemAtIndexPath");
		
		[self.categoriesForItem addObject:self.categories[indexPath.row]];
		
		
		UIImageView *currentImageView = self.categoriesImageViews[indexPath.row];
		
		currentImageView.alpha = 0.5;
		
		
		
		
		
		NSLog(@"self.categoriesForItem is: %@",[self.categoriesForItem lastObject]);
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
		
		NSLog(@"We're calling didselectItemAtIndexPath");
		
		[self.categoriesForItem removeObject:self.categories[indexPath.row]];
		NSLog(@"self.categoriesForItem is: %@",[self.categoriesForItem lastObject]);
		
		UIImageView *currentImageView = self.categoriesImageViews[indexPath.row];
		
		currentImageView.alpha = 1.0;
		
}





- (void)viewDidLoad {
		
		self.categoriesForItem = [NSMutableArray new];
		self.navigationItem.title = @"Donate Item";
		
		[super viewDidLoad];
		[self collectionViewIsh];

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
}


-(void)setConstraints{
#pragma initialization
		
				//initialize storyboard objects
		self.scrollView = [[UIScrollView alloc]init];
		self.containerView = [[UIView alloc]init];
		self.topContainerView = [[UIView alloc]init];
		self.selectedImageView = [[UIImageView alloc]init];
		
		self.useCurrentLocationSwitch = [[UISwitch alloc]init];
		self.useCurrentLocationLabel = [[UILabel alloc]init];
		self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
		self.itemNameTextField = [[UITextField alloc]init];
		self.itemDescriptionTextField= [[UITextField alloc]init];
		self.pickupInstructionsTextField= [[UITextField alloc]init];
		
		
		

//
#pragma view hierarchy

		[self.view addSubview: self.scrollView];
		[self.scrollView addSubview:self.containerView];
		[self.scrollView addSubview:self.topContainerView];
		//selectimage
		[self.topContainerView addSubview:self.selectedImageView];
		
		//collectionView
		[self.topContainerView addSubview:self.collectionView];

		//textfields
		[self.containerView addSubview:self.itemNameTextField];
		[self.containerView addSubview:self.itemDescriptionTextField];
		[self.containerView addSubview:self.pickupInstructionsTextField];

		//switch
		[self.containerView addSubview:self.useCurrentLocationLabel];
		[self.containerView addSubview:self.useCurrentLocationSwitch];
		//save
		[self.containerView addSubview:self.saveButton];
		
		self.containerView.backgroundColor = [UIColor colorWithRed:0.133 green:0.752 blue:0.392 alpha:0.5];
		self.topContainerView.backgroundColor = [UIColor whiteColor];
		
		
#pragma setConstraints
				//SCROLLVIEW & CONTAINER
		[self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.edges.equalTo(self.view);
		}];
		
		[self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.right.top.equalTo(self.scrollView);
//				make.top.equalTo(self.selectedImageView);
				make.bottom.equalTo(self.collectionView.mas_bottom);
//				make.bottom.equalTo(self.containerView.mas_top);
//				make.height.equalTo(@300);
				make.width.equalTo(self.view);
		}];
		
		
		[self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.right.bottom.equalTo(self.scrollView);
				make.top.equalTo(self.topContainerView.mas_bottom);
								make.height.equalTo(@300);
//				make.bottom.equalTo(self.saveButton);
				make.width.equalTo(self.view);
		}];
		
				//IMAGE & Placeholder
		
		UIImage *placeHolderThing = [UIImage imageNamed:@"addPhotoPlaceholder"];
		self.selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
		
		if (![self.selectedImageView.image isEqual:self.itemImage]) {
    self.selectedImageView.image = placeHolderThing;
		}
		[self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.right.equalTo (self.topContainerView);
				make.top.equalTo(self.topContainerView);
				make.height.equalTo(@200);
		}];
		
		
		//collectionview
		[self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.height.equalTo(@120);
				make.left.equalTo(self.topContainerView).offset(25);
				make.right.equalTo(self.topContainerView).offset(-25);
				make.centerX.equalTo(self.topContainerView.mas_centerX);
				make.top.equalTo(self.selectedImageView.mas_bottom).offset(20);
	}];
	
		self.collectionView.scrollEnabled = YES;
		
		self.collectionView.showsHorizontalScrollIndicator = YES;
		
		
//textFields
		NSString *placeholderName = [NSString stringWithFormat:@"Item Name"];
		NSString *placeholderDescription = [NSString stringWithFormat:@"Item Description"];
		NSString *placeholderPickup = [NSString stringWithFormat:@"Instructions For Pickup"];

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
				make.bottom.equalTo(self.scrollView.mas_bottom);
				make.height.equalTo(@60);
		}];
}









#pragma keyboard shifty

-(void)UIKeyboardWillHideOrShow:(NSNotification *)notification{

		CGRect finalConstraint = [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];

		if ([notification.name isEqualToString:@"UIKeyboardWillHideNotification"]) {finalConstraint = CGRectZero;}
				CGFloat scrollViewKeyboard = finalConstraint.size.height;
		
				NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
				
				[UIView animateWithDuration:duration animations:^{
						[self.scrollView setContentOffset:CGPointMake(0, scrollViewKeyboard-25) animated:YES];
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
		if(self.categoriesForItem){
				item[@"categories"] = self.categoriesForItem;
		}

		
		if ((self.categoriesForItem.count>0) & self.name.length>=3 & self.itemDescription.length>=3 & self.pickupInstructions.length>=3 &(self.itemImage!=nil)) {

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

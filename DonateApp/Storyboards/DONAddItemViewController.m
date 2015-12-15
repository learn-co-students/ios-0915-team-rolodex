		//
		//  DONAddItemViewController.m
		//  DonateApp
		//
		//  Created by synesthesia on 11/18/15.
		//  Copyright © 2015 Rolodex. All rights reserved.
		//

#import "DONAddItemViewController.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@interface DONAddItemViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView *placeholderImageView;



@end

@implementation DONAddItemViewController


static NSString * const reuseIdentifier = @"cell";


- (void)viewDidLoad {
		
		[self _registerForKeyboardNotifications];
		
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
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentCameraAlertController)];
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
		
		
    // Do any additional setup after loading the view.
		
		self.placeholderImageView = [[UIImageView alloc] init];
		[self.selectedImageView addSubview:self.placeholderImageView];
		[self.placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
				if (IS_IPHONE_6 || IS_IPHONE_6P) {
						make.edges.equalTo(self.selectedImageView).insets(UIEdgeInsetsMake(40, 40, 40, 40));
				} else {
						make.edges.equalTo(self.selectedImageView).insets(UIEdgeInsetsMake(20, 20, 20, 20));
				}
		}];
		self.placeholderImageView.contentMode = UIViewContentModeScaleAspectFit;
		self.placeholderImageView.image = [UIImage imageNamed:@"addPhotoPlaceholder"];
		
}

-(void)viewDidLayoutSubviews
{
		[super viewDidLayoutSubviews];
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
				self.defaultOffset = self.scrollView.contentOffset;
		});
		
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
		
#pragma view hierarchy
		
		[self.view addSubview: self.scrollView];
		[self.scrollView addSubview:self.containerView];

		[self.scrollView addSubview:self.topContainerView];
				//selectimage

		[self.topContainerView addSubview:self.selectedImageView];
		[self.topContainerView addSubview:self.collectionView];
		[self.containerView addSubview:self.itemNameTextField];
		[self.containerView addSubview:self.itemDescriptionTextField];
		[self.containerView addSubview:self.pickupInstructionsTextField];
		
				//switch
		[self.containerView addSubview:self.useCurrentLocationLabel];
		[self.containerView addSubview:self.useCurrentLocationSwitch];
				//save
		[self.containerView addSubview:self.saveButton];
		
				//		self.containerView.backgroundColor = [UIColor colorWithRed:0.133 green:0.752 blue:0.392 alpha:0.5];
				//		self.topContainerView.backgroundColor = [UIColor colorWithRed:0.133 green:0.752 blue:0.392 alpha:0.5];
				//		self.topContainerView.backgroundColor = [UIColor whiteColor];
		
		
#pragma setConstraints
				//SCROLLVIEW & CONTAINER
		[self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.edges.equalTo(self.view);
		}];
		
		[self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.right.top.equalTo(self.containerView);
				if (IS_IPHONE_6 || IS_IPHONE_6P) {
						make.height.equalTo(@250);
				} else {
						make.height.equalTo(@200);
				}
				make.bottom.equalTo(self.collectionView.mas_bottom);
						//				make.bottom.equalTo(self.containerView.mas_top);
		}];
		
		
		[self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.edges.equalTo(self.scrollView);
						//				make.top.equalTo(self.mas_topLayoutGuideBottom);
				CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
				NSLog(@"%0.3f",navBarHeight);
				make.height.equalTo(self.view).with.offset(-navBarHeight-20);
				
						//				make.bottom.equalTo(self.saveButton);
		}];
		
				//IMAGE & Placeholder
		self.selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
		
		[self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.right.equalTo (self.topContainerView);
				make.top.equalTo(self.topContainerView);
				make.width.equalTo(self.view);
						//				make.height.equalTo(@250);
				
		}];
		
		
				//collectionview
		[self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.height.equalTo(@65);
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
		
		self.itemNameTextField.layer.cornerRadius = 8.0f;
		self.itemNameTextField.layer.borderWidth = 1.0f;
		self.itemNameTextField.layer.borderColor = [UIColor blackColor].CGColor;
		self.itemNameTextField.borderStyle = UITextBorderStyleRoundedRect;
		self.itemNameTextField.textColor = [UIColor blackColor];
		self.itemNameTextField.placeholder = placeholderName;
		self.itemNameTextField.textAlignment = NSTextAlignmentCenter;
		self.itemNameTextField.borderStyle = UITextBorderStyleRoundedRect;
		
		[self.itemNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(self.topContainerView.mas_bottom).offset(20);
				make.left.equalTo(self.containerView).offset(25);
				make.right.equalTo(self.containerView).offset(-25);
				make.centerX.equalTo(self.containerView.mas_centerX);
				make.bottom.equalTo(self.itemDescriptionTextField.mas_top).offset(-20);
		}];
		
		self.itemDescriptionTextField.layer.cornerRadius = 8.0f;
		self.itemDescriptionTextField.layer.borderWidth = 1.0f;
		self.itemDescriptionTextField.layer.borderColor = [UIColor blackColor].CGColor;
		self.itemDescriptionTextField.borderStyle = UITextBorderStyleRoundedRect;
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
		self.pickupInstructionsTextField.layer.cornerRadius = 8.0f;
		self.pickupInstructionsTextField.layer.borderWidth = 1.0f;
		self.pickupInstructionsTextField.layer.borderColor = [UIColor blackColor].CGColor;
		self.pickupInstructionsTextField.borderStyle = UITextBorderStyleRoundedRect;
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
		
		
		self.useCurrentLocationSwitch.layer.borderColor = [UIColor blackColor].CGColor;
		
		self.useCurrentLocationLabel.textColor = [UIColor blackColor];
		self.useCurrentLocationLabel.text = [NSString stringWithFormat:@"Use Current Location?"];
				//		self.useCurrentLocationLabel.layer.borderColor = [UIColor blackColor].CGColor;
		
		self.useCurrentLocationLabel.layer.cornerRadius = 8.0f;
		
		[self.useCurrentLocationSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
				make.right.equalTo(self.containerView.mas_right).offset(-15);
				make.top.equalTo(self.useCurrentLocationLabel);
		}];
		
		[self.useCurrentLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.equalTo(self.containerView.mas_left).offset(25);
				make.top.equalTo(self.pickupInstructionsTextField.mas_bottom).offset(20);
		}];
		
		self.saveButton.backgroundColor = [UIColor colorWithRed:0.133 green:0.752 blue:0.392 alpha:1.0];
		self.saveButton.userInteractionEnabled = YES;
		
		NSString *saveTitleLabel = @"SAVE"; NSString *savedTitleLabel = @"ITEM SAVED";
		[self.saveButton setTitle:saveTitleLabel forState:UIControlStateNormal];[self.saveButton setTitle:savedTitleLabel forState:UIControlStateHighlighted];
		self.saveButton.userInteractionEnabled = YES;
		
		[self.saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
		
		[self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.right.equalTo(self.containerView);
				make.bottom.equalTo(self.containerView.mas_bottom).priorityHigh();
				make.height.equalTo(@60);
		}];
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
		
		return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
		
		[self.categoriesForItem addObject:self.categories[indexPath.row]];
		
		UIImageView *currentImageView = self.categoriesImageViews[indexPath.row];
		currentImageView.image = [currentImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		
		currentImageView.tintColor = [UIColor colorWithRed:33.0/255.0 green:192.0/255.0 blue:100.0/255.0 alpha:1.0];
		
}



-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
		
		[self.categoriesForItem removeObject:self.categories[indexPath.row]];
		UIImageView *currentImageView = self.categoriesImageViews[indexPath.row];
		currentImageView.image = [currentImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		currentImageView.alpha = 0.74f;
		currentImageView.tintColor = [UIColor blackColor];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
		self.itemLocation = [locations lastObject];
		//use case for network timeout???
//		if (![locations lastObject]) {
//    self.itemLocation = nil;
//		}
}

-(void)cancelClicked{
		[self dismissViewControllerAnimated:YES completion:nil];
}


- (void)useCurrentLocationSwitchTapped{
		
		if (self.useCurrentLocationSwitch.isOn) {
				self.locationPF = [PFGeoPoint geoPointWithLocation:self.itemLocation];
				
				[self.locationManager stopUpdatingLocation];
				NSLog(@"current location switch is on, self.itemLocation= %@", self.itemLocation);
		}
		
		if (!self.useCurrentLocationSwitch.isOn) {
				self.locationPF = nil;
		}
}

-(void)saveButtonTapped{
		[self.locationManager stopUpdatingLocation];
		
		SCLAlertView *alert = [[SCLAlertView alloc]init];
		alert.customViewColor =  [UIColor colorWithRed:33.0/255.0 green:192.0/255.0 blue:100.0/255.0 alpha:1];
		alert.showAnimationType = FadeIn;
		alert.hideAnimationType = FadeOut;
		
		
		
		
		DONItem *item = (DONItem*)[PFObject objectWithClassName:@"DONItem"];
		
		
		
		if (self.itemImage !=nil||NULL) {
				NSData *imageData = UIImageJPEGRepresentation(self.itemImage, 0.8);
				self.itemImagePF = [PFFile fileWithName:@"photo.jpg" data:imageData];
		} else {
				[self presentAlertController:@"Item Image"];
						//				[alert showWarning:self title:@"Image Required" subTitle:@"Please add an image" closeButtonTitle:@"OK" duration:0.0f];
		}
		
		
		self.name =	self.itemNameTextField.text;
		item[@"name"] = self.name;
		
		if (self.name.length<3) {
				[self presentAlertController:@"Item Name"];
						//				[alert showWarning:self title:@"Incomplete Name" subTitle:@"Please finish entering name" closeButtonTitle:@"OK" duration:0.0f];
		}
		
		self.itemDescription = self.itemDescriptionTextField.text;
		item[@"itemDescription"] = self.itemDescription;
		if (self.itemDescription.length <3) {
				
				[self presentAlertController:@"Item Description"];
						//				[alert showWarning:self title:@"Incomplete Description" subTitle:@"Please complete description" closeButtonTitle:@"OK" duration:0.0f];
		}
		self.pickupInstructions =	self.pickupInstructionsTextField.text;
		item[@"pickupInstructions"] = self.pickupInstructions;
		if (self.pickupInstructions.length <3) {
				
				[self presentAlertController:@"Pickup Instructions"];
				
						//				[alert showWarning:self title:@"Incomplete Instructions" subTitle:@"Please complete pickup instructions" closeButtonTitle:@"OK" duration:0.0f];
		}
		[alert alertIsDismissed:^{
				NSLog(@"SCLAlertView dismissed!");
		}];
		
		
		self.listedBy = [DONUser currentUser];
		if (self.listedBy) { item[@"listedBy"] = self.listedBy;}
		
		if (self.locationPF) {
				item[@"location"] = self.locationPF;}
		self.views = @0;
		item[@"views"] = self.views;
		if (self.itemImage) {
    item[@"image"] = self.itemImagePF;
		}
		if (!self.categoriesForItem.count) {
				[self.categoriesForItem addObject:self.eighthTagString];
		}
		NSLog(@"self.categoriesForItem contains %@", [self.categoriesForItem lastObject]);
		
		if ( self.name.length>=3 & self.itemDescription.length>=3 & self.pickupInstructions.length>=3 &(self.itemImage!=nil)) {
				
				[alert showWaiting:self title:@"Saving" subTitle:@"Please Wait" closeButtonTitle:nil duration:3.0f];
				
				
				
				
				[DONCategory categoryWithName:self.categoriesForItem[0] withCompletion:^(BOOL success, DONCategory *category) {
						item[@"categories"] = @[category];
						
						[item saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
								NSLog(@"succeeded? %d, with error: %@", succeeded, error.localizedDescription);
								if (succeeded) {
										
										[self dismissViewControllerAnimated:YES completion:^{
												
										}];
								}
						}];
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

-(void)userTappedImageViewForCamera{
		
}


-(void)userTappedImageView{

		NSLog(@"usertappedImageView HAPPENEDD!!");
		
		UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
		pickerController.delegate = self;
		[self presentViewController:pickerController animated:YES completion:nil];
}
-(void)userTappedCamera{
		
		
		UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
		pickerController.delegate = self;
		pickerController.allowsEditing = YES;
		pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentViewController:pickerController animated:YES completion:nil];
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
	
		
		self.itemImage = info[UIImagePickerControllerOriginalImage];
		self.selectedImageView.image = self.itemImage;
				//for PNG
				//		NSData *imageData = UIImagePNGRepresentation(image);
				//    PFFile *imageFile = [PFFile fileWithName:@"photo.png" data:imageData];
		[self dismissViewControllerAnimated:YES completion:nil];
		self.placeholderImageView.hidden = YES;
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


		//for when UIAlertView in SCLAlertView becomes unresponsive
-(UIAlertController *)presentAlertController:(NSString *)fieldName {
		
		
		
		NSString *alertMessage = [NSString stringWithFormat:@"%@ field is incomplete",fieldName];
		
		self.alertController = [UIAlertController alertControllerWithTitle:@"Missing Field" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
		
		self.alertController.view.tintColor = [UIColor grayColor];
		self.alertController.view.layer.borderWidth = 2.0;
		self.alertController.view.layer.borderColor = [UIColor darkGrayColor].CGColor;
		self.alertController.view.layer.cornerRadius = 5.0;
		self.alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
		
		[self.alertController addAction:self.alertAction];
		
		[self presentViewController:self.alertController animated:YES completion:nil];
		
		return self.alertController;
		
}

-(void)presentCameraAlertController {
		
		UIAlertController *alertControllerCamera = [UIAlertController alertControllerWithTitle:@"Use Camera?" message:@"Take a Photo or Select From Camera Roll" preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *alertActionCamera;
  UIAlertAction *alertActionLibrary;
		
		
		
		alertControllerCamera.view.tintColor = [UIColor grayColor];
		alertControllerCamera.view.layer.borderWidth = 2.0;
		alertControllerCamera.view.layer.borderColor = [UIColor darkGrayColor].CGColor;
		alertControllerCamera.view.layer.cornerRadius = 5.0;
		
		
		alertActionCamera = [UIAlertAction actionWithTitle:@"Use Camera"
																								 style:UIAlertActionStyleDefault
																							 handler:^(UIAlertAction * _Nonnull action) {
																									 
																									 [self userTappedCamera];
																									 
																							 }];
		
		alertActionLibrary = [UIAlertAction actionWithTitle:@"Use Camera Roll"
																									style:UIAlertActionStyleDefault
																								handler:^(UIAlertAction * _Nonnull action) {
																										
																										NSLog(@"User Camera ROLLLL selected!");
																										
																										[self userTappedImageView];
																										
																								}];
		
		[alertControllerCamera addAction:alertActionCamera];
		[alertControllerCamera addAction:alertActionLibrary];

		[self presentViewController:alertControllerCamera animated:YES completion:nil];

}

- (UIView *)currentFirstResponder {
		if ([self.itemNameTextField isFirstResponder]) {
				return self.itemNameTextField;
		}
		if ([self.itemDescriptionTextField isFirstResponder]) {
				return self.itemDescriptionTextField;
		}
		if ([self.pickupInstructionsTextField isFirstResponder]) {
				return self.pickupInstructionsTextField;
		}
		return nil;
}



- (void)_registerForKeyboardNotifications {
		[[NSNotificationCenter defaultCenter] addObserver:self
																						 selector:@selector(_keyboardWillShow:)
																								 name:UIKeyboardWillShowNotification
																							 object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
																						 selector:@selector(_keyboardWillHide:)
																								 name:UIKeyboardWillHideNotification
																							 object:nil];
}

- (void)_keyboardWillShow:(NSNotification *)notification {
		NSDictionary *userInfo = [notification userInfo];
		CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
		CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
		UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
		
		CGRect keyboardFrame = [self.view convertRect:endFrame fromView:self.view.window];
		CGFloat visibleKeyboardHeight = CGRectGetMaxY(self.view.bounds) - CGRectGetMinY(keyboardFrame);
		
		[self setVisibleKeyboardHeight:visibleKeyboardHeight
								 animationDuration:duration
									animationOptions:curve << 16];
}

- (void)_keyboardWillHide:(NSNotification *)notification {
		NSDictionary *userInfo = [notification userInfo];
		CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
		UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
		[self setVisibleKeyboardHeight:0.0
								 animationDuration:duration
									animationOptions:curve << 16];
}

- (void)setVisibleKeyboardHeight:(CGFloat)visibleKeyboardHeight
							 animationDuration:(NSTimeInterval)animationDuration
								animationOptions:(UIViewAnimationOptions)animationOptions {
		
		dispatch_block_t animationsBlock = ^{
				self.visibleKeyboardHeight = visibleKeyboardHeight;
		};
		
		if (animationDuration == 0.0) {
				animationsBlock();
		} else {
				[UIView animateWithDuration:animationDuration
															delay:0.0
														options:animationOptions | UIViewAnimationOptionBeginFromCurrentState
												 animations:animationsBlock
												 completion:nil];
		}
}

- (void)setVisibleKeyboardHeight:(CGFloat)visibleKeyboardHeight {
		if (self.visibleKeyboardHeight != visibleKeyboardHeight) {
				_visibleKeyboardHeight = visibleKeyboardHeight;
				[self _updateViewContentOffsetAnimated:NO];
		}
}

- (void)_updateViewContentOffsetAnimated:(BOOL)animated {
		
		CGPoint currentOffset = self.scrollView.contentOffset;
		if (currentOffset.y > self.defaultOffset.y + 30) {
				currentOffset = self.defaultOffset;
		} else {
				currentOffset = CGPointMake(0, currentOffset.y + self.visibleKeyboardHeight);
		}
		[self.scrollView setContentOffset:currentOffset animated:animated];
}

@end

//
//  DONSignUpScreenViewController.swift
//  DonateAppLaurent
//
//  Created by Laurent Farci on 19/11/15.
//  Copyright © 2015 Laurent Farci. All rights reserved.
//

import UIKit
import SCLAlertView
import MBProgressHUD
import MMDrawerController
import Parse

class DONSignUpScreenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
        @IBOutlet weak var profilePhotoImageView: UIImageView!
        @IBOutlet weak var userEmailAddressTextField: UITextField!
        @IBOutlet weak var userPasswordTextField: UITextField!
        @IBOutlet weak var userUserNameTextField: UITextField!

        
        // White Status Bar
        override func preferredStatusBarStyle() -> UIStatusBarStyle
        {
            return UIStatusBarStyle.LightContent
        }
        
        override func viewDidLoad()
        {
            super.viewDidLoad()
            
            // Change the color of the placeholder in the text fields
            let attributedFirstNamePlaceholder = NSAttributedString(string: "USERNAME", attributes: [ NSForegroundColorAttributeName: UIColor.whiteColor() ])
            userUserNameTextField.attributedPlaceholder = attributedFirstNamePlaceholder

            let attributedEmailPlaceholder = NSAttributedString(string: "EMAIL ADDRESS", attributes: [ NSForegroundColorAttributeName: UIColor.whiteColor() ])
            userEmailAddressTextField.attributedPlaceholder = attributedEmailPlaceholder
            
            let attributedPasswordPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [ NSForegroundColorAttributeName: UIColor.whiteColor() ])
            userPasswordTextField.attributedPlaceholder = attributedPasswordPlaceholder
            
            // Recognize tap gesture
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("screenTapped"))
            self.view.addGestureRecognizer(tapGestureRecognizer)
            
//            userPasswordRepeatTextField.returnKeyType = UIReturnKeyType.Done
//            userPasswordRepeatTextField.delegate = self
            
           // self.view.contentMode = UIViewContentMode.BottomRight;
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "loginRiver")!)

            
            
        }
        
        // Dismiss Keyboard when tapped out of the text fields
        func screenTapped()
        {
           self.view.endEditing(true)
        }
        
        // Keyboard 'Next' (Return key) behavior
        func textFieldShouldReturn(textField: UITextField) -> Bool
        {
            if (textField == userUserNameTextField) {
                userEmailAddressTextField.becomeFirstResponder()
            } else if (textField == userEmailAddressTextField) {
                userPasswordTextField.becomeFirstResponder()
            } else if (textField == userPasswordTextField) {

                signUpButtonTapped(true)
            }
            return true
        }
        
        
        override func viewDidLayoutSubviews()
        {
            self.edgesForExtendedLayout = UIRectEdge()
        }
        
        
        @IBAction func selectProfilePhotoButtonTapped(sender: AnyObject)
        {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(myPickerController, animated: true, completion: nil)
        }
        
        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
        {
            profilePhotoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        @IBAction func closeButtonTapped(sender: AnyObject) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        

        
        @IBAction func signUpButtonTapped(sender: AnyObject) {
            
            view.endEditing(true)
            
            let userEmail = userEmailAddressTextField.text
            let userPassword = userPasswordTextField.text
            let userUserName = userUserNameTextField.text

            
            if(userEmail!.isEmpty || userPassword!.isEmpty || userUserName!.isEmpty)
            {
                // Display error message
                SCLAlertView().showNotice("Oops", subTitle: "All fields are required to be filled in.")
                return
            }
            
            
            let myUser:PFUser = PFUser()
            myUser.username = userUserName
            myUser.password = userPassword
            myUser.email = userEmail
            myUser.setObject(userUserName!, forKey: "first_name")
          
            
            if let profileImageData = profilePhotoImageView.image
            {
                let profileImageDataJPEG = UIImageJPEGRepresentation(profileImageData, 1)
                
                let profileImageFile = PFFile(data: profileImageDataJPEG!)
                myUser.setObject(profileImageFile!, forKey: "photo")
            }
            
            // Show activity indicator
            let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spiningActivity.labelText = "Sending"
            spiningActivity.detailsLabelText = "Please wait"
            
            myUser.signUpInBackgroundWithBlock { (success, error) -> Void in
                
                // Hide activity indicator
                spiningActivity.hide(true)
                
                var userMessage = "Registration was successful. Thank you!"
                
                if(!success)
                {
                    //userMessage = "Could not register at this time please try again later."
                    userMessage = error!.localizedDescription
                }
                
                
                let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle:UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
                    
                    if(success)
                    {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
                
                myAlert.addAction(okAction)
                self.presentViewController(myAlert, animated: true, completion: nil)
                
            }
        }
    
}

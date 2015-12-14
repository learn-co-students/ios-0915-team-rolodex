//
//  DONWelcomeScreenViewController.swift
//  DonateAppLaurent
//
//  Created by Laurent Farci on 19/11/15.
//  Copyright © 2015 Laurent Farci. All rights reserved.
//

import UIKit
import Parse
import SCLAlertView
import AVFoundation
import AVKit
import MBProgressHUD
import MMDrawerController
//import DONAppDelegate



class DONWelcomeScreenViewController: UIViewController {
    
    
    // Variables for video background
    var player      = AVPlayer()
    var movietitle  = "video"
    var movietype   = "mp4"
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var appiconOutlet: UIImageView!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var skipButton: UIButton!
    // Make the status bar White
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    // Dismiss Keyboard when tapped out of the text fields
    func screenTapped()
    {
        self.view.endEditing(true)
    }
    
    @IBAction func skipButtonTapped(sender: UIButton) {
        // Navigate to Protected page
        self.displayMainScreen()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue("UserTappedSkip", forKey: "UserSkip")
        userDefaults.synchronize()
    }
    
    func displayMainScreen() {
        let appDelegate:DONAppDelegate = UIApplication.sharedApplication().delegate as! DONAppDelegate
        if let vc = appDelegate.window.rootViewController {
            if (vc.dynamicType != self.dynamicType) {
                if let drawerController = self.presentingViewController as? MMDrawerController,
                    let centerNavController = drawerController.centerViewController as? UINavigationController {
                        centerNavController.visibleViewController?.dismissViewControllerAnimated(true, completion: nil)
                }
                
            } else {
                appDelegate.buildUserInterface()
            }
        }
}
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    /*
    // Video Background
    func playVideo() ->Bool
    {
        // Defining the path to the video file - change name here
        let path    = NSBundle.mainBundle().pathForResource(movietitle, ofType:movietype)
        let url     = NSURL.fileURLWithPath(path!)
        player      = AVPlayer(URL: url)
        
        let avPlayerLayer = AVPlayerLayer(player: player)
        
        avPlayerLayer.frame = self.view.bounds
        avPlayerLayer.videoGravity = "AVLayerVideoGravityResizeAspectFill"
        
        self.view.layer.insertSublayer(avPlayerLayer, atIndex: 0)
        
        player.volume   = 0
        player.play()
        
        print("should play")
        
        // Invoke after player is created and AVPlayerItem is specified
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "playerItemDidReachEnd:",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: player.currentItem)
        
        return true
    }
*/
    
    func playerItemDidReachEnd(notification: NSNotification)
    {
        player.seekToTime(kCMTimeZero)
        player.play()
    }
    
    
    // Declaration for the text entry fields
    @IBOutlet weak var userEmailAddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    
    // Login Button
    @IBAction func signInButtonTapped(sender: AnyObject)
    {
        view.endEditing(true)
        
        let userEmail = userEmailAddressTextField.text?.lowercaseString
        let userPassword = userPasswordTextField.text?.lowercaseString
        
        if(userEmail!.isEmpty || userPassword!.isEmpty)
        {
            return
        }
        
        // Display activity animation
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "Sending"
        spiningActivity.detailsLabelText = "Please wait"
        spiningActivity.userInteractionEnabled = false
        
        
        PFUser.logInWithUsernameInBackground(userEmail!, password: userPassword!) { (user:PFUser?, error:NSError?) -> Void in
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            if(user != nil)
            {
                
                // Remember the sign in state
                let userName:String? = user?.username
                
                NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "user_name")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                self.displayMainScreen()
                
            } else {
                
                // Display error message
                SCLAlertView().showNotice("Oopss", subTitle: error!.localizedDescription)
            }
        }
    }
    
    // Keyboard 'Next' (Return key) behavior
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == userEmailAddressTextField) {
            userPasswordTextField.becomeFirstResponder()
        } else if (textField == userPasswordTextField) {
            userPasswordTextField.resignFirstResponder()
            signInButtonTapped(true)
        }
        return true
    }
    
    func userHasSkippedLogin() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.valueForKey("UserSkip") != nil ? true : false
    }
    
    func displayedModally() -> Bool {
        return self.presentingViewController != nil ? true : false
    }
    
    func shouldSkipLogin() -> Bool {
        let userIsLoggedIn = PFUser.currentUser() != nil
        let userIntendsToSkipLogin = self.userHasSkippedLogin() && !self.displayedModally()
        
        return userIsLoggedIn || userIntendsToSkipLogin
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        if self.shouldSkipLogin() {
            self.displayMainScreen()
        }
        
        // Change the color of the placeholder in the text fields
        let attributedEmailPlaceholder = NSAttributedString(string: "EMAIL ADDRESS", attributes: [ NSForegroundColorAttributeName: UIColor.whiteColor() ])
        userEmailAddressTextField.attributedPlaceholder = attributedEmailPlaceholder
        
        let attributedPasswordPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [ NSForegroundColorAttributeName: UIColor.whiteColor() ])
        userPasswordTextField.attributedPlaceholder = attributedPasswordPlaceholder
        
        // Login Button Format
        loginButtonOutlet.layer.cornerRadius = 3
        loginButtonOutlet.clipsToBounds          = true
        appiconOutlet.layer.cornerRadius = 5
        appiconOutlet.clipsToBounds          = true
        
        let myColor : UIColor = UIColor( red: 0, green: 0, blue:0, alpha: 1.0 )
        
        userEmailAddressTextField.layer.borderColor = myColor.CGColor
        userPasswordTextField.layer.borderColor = myColor.CGColor
        
        // Recognize tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("screenTapped"))
        self.visualEffectView.addGestureRecognizer(tapGestureRecognizer)
        
        //firstResponderDelay()

    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        //Timer to show keyboard
        //NSThread.sleepForTimeInterval(0.5)
        //userEmailAddressTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        //self.playVideo()
    }
}

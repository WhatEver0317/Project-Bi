//
//  SignUp2ViewController.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/15.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit

class SignUp2ViewController: SharedViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    // MARK: - Properties
    
    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var addPortraitButton: UIButton!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    
    @IBOutlet weak var topSpacingConstraint: NSLayoutConstraint!
    
    // MARK: - Constants
    
    // MARK: - Variables
    var fullName:String { return self.fullNameTextField.text }
    var company:String { return self.companyTextField.text }
    var position:String { return self.positionTextField.text }
    var portrait:UIImageView = UIImageView()
    
    let contactInfoHead = ContactInfoHead()
    let contactInfo = ContactInfo()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize
        commonInitialization()
        
        // Setup Notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardNotification:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardNotification:"), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide addPortraitButton
        if addPortraitButton.hidden {
            addPortraitButton.hidden = false
        } else {
            addPortraitButton.hidden = true
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    // MARK: - Delegates
    
    // UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        let resizedImageData = UIImageJPEGRepresentation(image, kPortraitCompressionQuality)
        let resizedImage = UIImage(data: resizedImageData)
        
        portraitImageView.makeCircularImage(resizedImage!, withSize: kSignupPortraitImageSize)
        portrait = portraitImageView
        println(UIImagePNGRepresentation(self.portrait.image).length)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // MARK: - Event Responses
    
    // AddPortraitButton pressed
    @IBAction func addPortraitButton(sender: UIButton) {
        setupImagePicker()
    }
    
    @IBAction func signupButtonPressed(sender: TKTransitionSubmitButton) {
        dismissKeyboard()
        if ( count(fullName) == 0 ) {
            GlobalHUD.showErrorHUDForView(self.view, withMessage: "Full name must be set.", animated: true, hide: true, delay: 1.5)
            return
        }
        
        // Get username and password
        if let email = standardUserDefaults.valueForKey(kSignupEmail) as? String {
            if let password = standardUserDefaults.valueForKey(kSignupPassword) as? String {

                ParseHelper.signupUserWithEmail(email, andPassword: password, completion: { (success, error) -> Void in
                    if (!success || error != nil) {

                        if error == nil {
                            let message = "Error! Please try again."
                            self.showAlertMessageViewWithTitle("Error", message: message)
                            return
                        }
                        
                        self.showAlertMessageViewWithTitle("Error", message: error!)
                        return
                    } else {
                        
                        self.contactInfoHead.contactInfoHeadDic["objectID"] = ParseHelper.currentUser().objectId!
                        self.contactInfoHead.contactInfoHeadDic["email"] = email
                        self.contactInfoHead.contactInfoHeadDic["fullName"] = self.fullName
                        self.contactInfoHead.contactInfoHeadDic["company"] = self.company
                        self.contactInfoHead.contactInfoHeadDic["position"] = self.position
                        self.contactInfoHead.portrait = UIImagePNGRepresentation(self.portrait.image)
                        self.contactInfoHead.updateVariables(self.contactInfoHead.contactInfoHeadDic)
                        
                        println("after sign up, before update parse: \(self.contactInfoHead.contactInfoHeadDic)")
                        
                        // Update user data in Parse
                        ParseHelper.updateUserDataInParseWithContactInfo(self.contactInfo, andContactInfoHead: self.contactInfoHead, completion: { (success, error) -> Void in
                            println("update parse after sign up: \(error)")
                            // Logout user and ask for email verification, then ask user to log in
                            ParseHelper.logoutUser({ (success, error) -> Void in
                                
                                self.showAlertMessageViewWithTitle("Email address verification", message: "We have sent you an email that contains a link - you must click this link and then log in.")
                            })
                        })
                    }
                })
            } else {
                GlobalHUD.showErrorHUDForView(self.view, withMessage: "Please try again.", animated: true, hide: true, delay: 1.5)
                return
            }
        } else {
            GlobalHUD.showErrorHUDForView(self.view, withMessage: "Please try again.", animated: true, hide: true, delay: 1.5)
            return
        }
    }
    
    
    // Change layout for iphone4s to iphone5s while the keyboard is displaying
    func keyboardNotification(notification: NSNotification)
    {
        // Check device screen's height
        if kScreenHeight >= 667.0 {
            return
        }
        
        // Layout views
        let isShowing = notification.name == UIKeyboardWillShowNotification
        if let userInfo = notification.userInfo {
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            self.topSpacingConstraint?.constant = isShowing ? -170.0 : 0.0
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: { self.view.layoutIfNeeded() },
                completion: nil)
        }
    }
    
    
    // MARK: - Getters & Setters
    
    // MARK: - Private Methods
    
    private func setupImagePicker()
    {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    private func commonInitialization()
    {
        portrait.makeCircularImage(kDefaultPortraitImage!, withSize: kSignupPortraitImageSize)
        
        self.navigationController!.navigationBar.topItem?.title = "Back"
        
        addPortraitButton.hidden = true
        
        setupGesture()
        
        fullNameTextField.autocorrectionType = UITextAutocorrectionType.No
        companyTextField.autocorrectionType = UITextAutocorrectionType.No
        positionTextField.autocorrectionType = UITextAutocorrectionType.No
        
        contactInfoHead.fetchContactInfoHeadDataFromUserDefaults { (success) -> Void in
            
        }
        println("view did load, fetch data: \(self.contactInfoHead.contactInfoHeadDic)")
    }
    
    private func showAlertMessageViewWithTitle(title:String, message:String)
    {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let closeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion:nil)
        }
        
        alertController.addAction(closeAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

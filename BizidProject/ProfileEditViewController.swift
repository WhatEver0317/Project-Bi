//
//  ProfileEditViewController.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/26.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var contactInfoTableView: UITableView!
    
    @IBOutlet weak var topSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let contactInfo = ContactInfo()
    let contactInfoHead = ContactInfoHead()
    
    var contactInfoArray:[ContactDictionary] = ContactInfoArray()
    var contactInfoHeadDic:ContactDictionary = ContactDictionary()
    var portrait: UIImage = kDefaultPortraitImage!
    private var cellsArray = [EditableContactInfoTableViewCell]()
    private var rollbackOfContactInfoHeadDic = ContactDictionary()
    private var rollbackOfContactInfoDic = ContactDictionary()
    private var rollbackOfPortrait: UIImage = kDefaultPortraitImage!
    private var changeLayout = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProperties()
        
        setupKeyboardNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.navigationController?.presentedViewController == nil {
            self.navigationController?.popToRootViewControllerAnimated(false)
        }
    }
    
    // MARK: - Delegates
    // UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactInfoArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(kContactInfoDetailCell, forIndexPath: indexPath) as! EditableContactInfoTableViewCell
        
        cell.valueTextField.delegate = self
        
        let dictionary = contactInfoArray[indexPath.row]
        if let key = dictionary.getFirstKey() {
            cell.thumbnailImageView.image = UIImage(named: key)
            cell.descriptionLabel.text = key
            cell.valueTextField.text = dictionary[key]
            cellsArray.append(cell)
        }
        
        return cell
    }
    
    // UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        println("before resize: \(UIImagePNGRepresentation(image).length)")
        
        let resizedImageData = UIImageJPEGRepresentation(image, kPortraitCompressionQuality)
        let resizedImage = UIImage(data: resizedImageData)
        
        portraitImageView.makeCircularImage(resizedImage!, withSize: kSignupPortraitImageSize)
        portrait = portraitImageView.image!
        println("after resize: \(UIImagePNGRepresentation(self.portrait).length)")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == 101 || textField.tag == 102 {
            changeLayout = false
        } else {
            changeLayout = true
            NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillShowNotification, object: nil)
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    

    // MARK: - Events
    
    // AddPortraitButton pressed
    @IBAction func addPortraitButton(sender: UIButton) {
        setupImagePicker()
    }
    
    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
        // Check network status
        let reachability = Reachability.reachabilityForInternetConnection()
        if !(reachability.isReachable()) {
            reachability.networkError(self)
            return
        }
        
        // Update contact head data
        contactInfoHeadDic["position"] = positionTextField.text
        contactInfoHeadDic["company"] = companyTextField.text
        contactInfoHead.contactInfoHeadDic = contactInfoHeadDic
        contactInfoHead.updateVariables(contactInfoHeadDic)
        
        // Update portrait
        contactInfoHead.portrait = UIImagePNGRepresentation(portrait)
        
        // Update contact
        var contactInfoDicTemp = contactInfo.contactInfoDic
        for cell in cellsArray {
            if let key = cell.descriptionLabel.text {
                contactInfoDicTemp[key] = cell.valueTextField.text
            }
        }
        contactInfo.contactInfoDic = contactInfoDicTemp
        contactInfo.updateVariables(contactInfoDicTemp)
        println("test for didSet: " + contactInfo.cellPhone)
        
        // Update data in UserDefaults
        self.contactInfo.saveContactDataToUserDefaults({ (success) -> Void in
            if !success {
                GlobalHUD.showErrorHUDForView(self.view, withMessage: "Saving failed. Please try again.", animated: true, hide: true, delay: 1.5)
                return
            }
        })
        
        self.contactInfoHead.saveContactInfoHeadDataToUserDefaults({ (success) -> Void in
            if !success {
                GlobalHUD.showErrorHUDForView(self.view, withMessage: "Saving failed. Please try again.", animated: true, hide: true, delay: 1.5)
                self.contactInfo.rollbackContactInfoData(self.rollbackOfContactInfoDic)
                return
            }
        })
        
        // Update data in Parse
        ParseHelper.updateUserDataInParseWithContactInfo(contactInfo, andContactInfoHead: contactInfoHead) { (success, error) -> Void in
            if !success {
                GlobalHUD.showErrorHUDForView(self.view, withMessage: "Saving failed. Please try again.", animated: true, hide: true, delay: 1.5)
                // Rollback data after saving failed in Parse
                self.contactInfoHead.rollbackContactInfoHeadData(self.rollbackOfContactInfoHeadDic, portrait: UIImagePNGRepresentation(self.rollbackOfPortrait))
                self.contactInfo.rollbackContactInfoData(self.rollbackOfContactInfoDic)
                return
            }
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    // Change layout for iphone4s to iphone5s while the keyboard is displaying
    func keyboardNotification(notification: NSNotification)
    {
        if changeLayout {
            // Layout views
            let isShowing = notification.name == UIKeyboardWillShowNotification
            if let userInfo = notification.userInfo {
                let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
                let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
                self.topSpacingConstraint?.constant = isShowing ? -180.0 : 0.0
                self.bottomSpacingConstraint.constant = isShowing ? 190.0 : 0.0
                UIView.animateWithDuration(duration,
                    delay: NSTimeInterval(0),
                    options: animationCurve,
                    animations: { self.view.layoutIfNeeded() },
                    completion: nil)
                
                println(contactInfoTableView.frame.origin.y)
            } else {
                if contactInfoTableView.frame.origin.y > 100 {
                    self.topSpacingConstraint?.constant = isShowing ? -180.0 : 0.0
                    self.bottomSpacingConstraint.constant = isShowing ? 190.0 : 0.0
                    UIView.animateWithDuration(0.2, animations: { self.view.layoutIfNeeded() }, completion: nil)
                }
            }
        }
        changeLayout = true
    }
    
    
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
    
    func setupProperties()
    {
        contactInfo.contactInfoArrayToDic(contactInfoArray)
        
        let contactInfoDic = contactInfo.contactInfoDic
        rollbackOfContactInfoHeadDic = contactInfoHeadDic
        rollbackOfContactInfoDic = contactInfoDic
        
        contactInfoTableView.delegate = self
        contactInfoTableView.dataSource = self
        positionTextField.delegate = self
        companyTextField.delegate = self
        
        portraitImageView.makeCircularImage(portrait, withSize: kDetailPortraitSize)
        fullNameLabel.text = contactInfoHeadDic["fullName"]
        positionTextField.text = contactInfoHeadDic["position"]
        companyTextField.text = contactInfoHeadDic["company"]
    }
    
    func setupKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardNotification:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardNotification:"), name:UIKeyboardWillHideNotification, object: nil)
        
        // For tableview to hide keyboard
        let tapGuestureRecognizer = UITapGestureRecognizer(target: self, action: "tableViewTapped")
        self.tableView.addGestureRecognizer(tapGuestureRecognizer)
    }
    
    func tableViewTapped()
    {
        self.view.endEditing(true)
    }

}

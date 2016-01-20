//
//  ProfileViewController.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/26.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    // MARK: - Properties
    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var contactInfoTableView: UITableView!
    
    // MARK: - Constants
    
    // MARK: - Variables
    let contactInfoHead = ContactInfoHead()
    let contactInfo = ContactInfo()
    
    var portrait:UIImage = kDefaultPortraitImage!
    var contactInfoHeadDic:ContactDictionary = ContactDictionary()
    var contactInfoArray:[ContactDictionary] = ContactInfoArray()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactInfoTableView.delegate = self
        contactInfoTableView.dataSource = self
        
        //create a new button
        let button: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        //set image for button
        button.setImage(UIImage(named: "QR Code.png"), forState: UIControlState.Normal)
        //add function for button
        button.addTarget(self, action: "qrcodeButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        //set frame
        button.frame = CGRectMake(0, 0, 25, 25)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        contactInfoHead.fetchPortraitDataFromUserDefaults { (success) -> Void in
            if !success {
                GlobalHUD.showErrorHUDForView(self.view, withMessage: "Getting data failed. Please login again.", animated: true, hide: true, delay: 2.0)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        contactInfoHead.fetchContactInfoHeadDataFromUserDefaults { (success) -> Void in
            if !success {
                GlobalHUD.showErrorHUDForView(self.view, withMessage: "Getting data failed. Please login again.", animated: true, hide: true, delay: 2.0)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        contactInfo.fetchMyContactDataFromUserDefaults { (success) -> Void in
            if !success {
                GlobalHUD.showErrorHUDForView(self.view, withMessage: "Getting data failed. Please login again.", animated: true, hide: true, delay: 2.0)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        portrait = UIImage(data: contactInfoHead.portrait)!
        contactInfoHeadDic = contactInfoHead.contactInfoHeadDic
        contactInfoArray = contactInfo.contactInfoDicToArray()
        
        portraitImageView.makeCircularImage(portrait, withSize: kDetailPortraitSize)
        fullNameLabel.text = contactInfoHeadDic["fullName"]
        positionLabel.text = contactInfoHeadDic["position"]
        companyLabel.text = contactInfoHeadDic["company"]
        
        contactInfoTableView.reloadData()
    }
    
    // MARK: - Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactInfoArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(kContactInfoDetailCell, forIndexPath: indexPath) as! DetailTableViewCell
        
        let dictionary = contactInfoArray[indexPath.row]
        if let key = dictionary.getFirstKey() {
            cell.thumbnailImageView.image = UIImage(named: key)
            cell.descriptionLabel.text = key
            cell.valueLabel.text = dictionary[key]
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Event Responses
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kToProfileEditView {
            var destination = segue.destinationViewController as? UIViewController
            if let navigationController = destination as? UINavigationController {
                destination = navigationController.visibleViewController
            }
            
            if let profileEditVC = destination as? ProfileEditViewController {
                profileEditVC.contactInfoHeadDic = contactInfoHeadDic
                profileEditVC.contactInfoArray = contactInfoArray
                profileEditVC.portrait = portrait
                
                println(contactInfoHeadDic["fullName"])
            }
        }
        
    }
    
    func qrcodeButtonPressed()
    {
        performSegueWithIdentifier(kToQRCode, sender: self)
    }
    
    // MARK: - Getters & Setters
    
    // MARK: - Private Methods (not include)
    
    
    

}

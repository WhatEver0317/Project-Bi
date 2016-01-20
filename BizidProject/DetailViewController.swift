//
//  DetailViewController.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/22.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var contactInfoTableView: UITableView!
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    var contactInfoArray:[ContactDictionary] = ContactInfoArray()
    var contactInfoHead:ContactDictionary = ContactDictionary()
    var portrait: UIImage = kDefaultPortraitImage!
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactInfoTableView.delegate = self
        contactInfoTableView.dataSource = self
        
        portraitImageView.makeCircularImage(portrait, withSize: kDetailPortraitSize)
        fullNameLabel.text = contactInfoHead["fullName"]  // ************ may dump here
        positionLabel.text = contactInfoHead["position"]  // ************ may dump here
        companyLabel.text = contactInfoHead["company"]    // ************ may dump here
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.navigationController?.presentedViewController == nil {
            self.navigationController?.popToRootViewControllerAnimated(false)
        }
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
    
    // MARK: - Getters & Setters

}

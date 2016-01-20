//
//  MoreTableViewController.swift
//  BizidProject
//
//  Created by GaoYuan on 15/10/1.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    @IBAction func logout(sender: UIButton) {
        
        ParseHelper.logoutUser { (success, error) -> Void in
            if success == true {
                ContactInfoHead.clearContactInfoHeadDataInUserDefaults()
                ContactInfo.clearContactInfoDataInUserDefaults()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

}

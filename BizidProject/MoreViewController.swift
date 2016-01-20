//
//  MoreViewController.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/10.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

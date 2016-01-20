////
////  AddFriendBySearchAlertController.swift
////  BizidProject
////
////  Created by GaoYuan on 15/9/14.
////  Copyright (c) 2015年 Yuan Gao. All rights reserved.
////
//
//import UIKit
//
//protocol AddFriendBySearchAlertDelegate {
//    func addFriendBySearchEmail(email:String)
//}
//
//
//
//class AddFriendBySearchAlertController: UIAlertController {
//    
//    var delegate:AddFriendBySearchAlertDelegate?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//        // create add action
//        self.addTextFieldWithConfigurationHandler { (inputAddressTextField) -> Void in
//            inputAddressTextField.placeholder = "E-Mail"
//        }
//        
//        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
//            let inputEmail = (self.textFields![0] as! UITextField).text as String
//            
//            // update CoreData and Cloud by using E-Mail(unique key)
//            self.delegate?.addFriendBySearchEmail(inputEmail)
//        }
//        self.addAction(addAction)
//        
//        // create cancel action
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
//        
//        self.addAction(cancelAction)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}

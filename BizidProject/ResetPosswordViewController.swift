//
//  ResetPosswordViewController.swift
//  BizidProject
//
//  Created by GaoYuan on 15/10/1.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit

class ResetPosswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        if count(emailTextField.text) == 0 {
            GlobalHUD.showErrorHUDForView(self.view, withMessage: "You must enter your email to recieve new possword.", animated: true, hide: true, delay: 2)
            return
        } else {
            ParseHelper.resetUserPosswordWithEmail(emailTextField.text, completion: { (success, error) -> Void in
                if success {
                    let alertController = UIAlertController(title: "Email sent", message: "We have sent you an email that contains a link - you must click this link to reset your password.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let closeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    
                    alertController.addAction(closeAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    GlobalHUD.showErrorHUDForView(self.view, withMessage: error, animated: true, hide: true, delay: 2)
                }
            })
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}

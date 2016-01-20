//
//  LoginViewController.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/9.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit

class LoginViewController: SharedViewController, MBProgressHUDDelegate {

    
    // MARK: - Constants
    
    
    // MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField! {
        didSet { emailTextField.becomeFirstResponder() }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Variables
    
    var email:String { return self.emailTextField.text.lowercaseString }
    var password:String { return self.passwordTextField.text }
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Log in"
        
        setupGesture()
    }
    
    
    
    // MARK: - Delegates
    // MARK: - TextField Delegates
    
    
    
    
    // MARK: - Event Responses
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        dismissKeyboard()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        
        dismissKeyboard()
        
        // Check illegal input
        if ( count(email) == 0 ) {
            GlobalHUD.showErrorHUDForView(self.view, withMessage: "Email must be set.", animated: true, hide: true, delay: 1.5)
            return
        } else if ( count(password) == 0 ) {
            GlobalHUD.showErrorHUDForView(self.view, withMessage: "Password must be set.", animated: true, hide: true, delay: 1)
            return
        }
        
        // Log in user and show HUD
//        GlobalHUD.showLoginHUDAddedToView(self.view, animated: true)
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), { () -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                ParseHelper.loginUserWithEmail(self.email, andPassword: self.password) { (success, error) -> Void in
                    if success == true {
                        if ParseHelper.userEmailVerified() {
                            
                            if let animatedButton = sender as? TKTransitionSubmitButton {
                                animatedButton.animate(1, completion: { () -> () in
                                    self.dismissViewControllerAnimated(true, completion:nil)
                                })
                            } else {
                                self.dismissViewControllerAnimated(true, completion:nil)
                            }
                        } else {
                            
                            let alertController = UIAlertController(title: "Email address verification", message: "We have sent you an email that contains a link - you must click this link and then log in again.", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            let closeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
                                ParseHelper.logoutUser({ (success, error) -> Void in })
                            }
                            let resendAction = UIAlertAction(title: "Resend", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
                                ParseHelper.resendVerificationEmail()
                            }
                            
                            alertController.addAction(closeAction)
                            alertController.addAction(resendAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                            
                        }
//                        GlobalHUD.hideLoginHUDForView(self.view, animated: true)
                    } else {
//                        GlobalHUD.hideLoginHUDForView(self.view, animated: true)
                        GlobalHUD.showErrorHUDForView(self.view, withMessage: error, animated: true, hide: true, delay: 2)
                    }

                }
            })
        })
    }
    
    
    
    // MARK: - Getters & Setters
    
    // MARK: - Private Methods

    
    
    


}

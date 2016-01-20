//
//  SignUpViewController.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/9.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit

class SignUp1ViewController: SharedViewController {
    
    
    // MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    
    
    
    // MARK: - Constants
    
    // MARK: - Variables
    var email:String { return self.emailTextField.text.lowercaseString }
    var password:String { return self.passwordTextField.text }
    var repassword:String { return self.repasswordTextField.text }
    
    let contactInfoHead = ContactInfoHead()
    
//    let contactInfoHead = ContactInfoHead()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGesture()
    }
    // MARK: - Delegates
    
    // MARK: - Event Responses
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        dismissKeyboard()
        
        if ( count(email) == 0 ||
            count(password) == 0 ||
            count(repassword) == 0 ) {
                GlobalHUD.showErrorHUDForView(self.view, withMessage: "Please complete this page.", animated: true, hide: true, delay: 1.5)
                return false
        } else {
            if password == repassword {
                
                // Save username and password to UserDefaults
                standardUserDefaults.removeObjectForKey(kSignupEmail)
                standardUserDefaults.removeObjectForKey(kSignupPassword)
                standardUserDefaults.setObject(email, forKey: kSignupEmail)
                standardUserDefaults.setObject(password, forKey: kSignupPassword)
                standardUserDefaults.synchronize()
                
                return true
            } else {
                GlobalHUD.showErrorHUDForView(self.view, withMessage: "The passwords are different.", animated: true, hide: true, delay: 1.5)
                return false
            }
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == kToSignUp2) {
//            var destination = segue.destinationViewController as? UIViewController
//            
//            if let navigationController = destination as? SharedNavigationController {
//                destination = navigationController.visibleViewController
//            }
//            
//            if let signUp2VC = destination as? SignUp2ViewController {
//                
//            }
//            
//        }
//    }
    // MARK: - Getters & Setters
    
    // MARK: - Private Methods (not include)
    

}

//
//  EntryScreenViewController.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/9.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit

class CoordinatorViewController: UIViewController {

    
    // MARK: - Properties
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    // MARK: - Life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Network initial check
        let reachability = Reachability.reachabilityForInternetConnection()
        if !(reachability.isReachable()) {
            reachability.networkError(self)
        }
        
        // Determining entrance screen
        if !( ParseHelper.userLoggedIn() && ParseHelper.userEmailVerified() ) {
            // Initial local data
            ContactInfoHead.clearContactInfoHeadDataInUserDefaults()
            ContactInfo.clearContactInfoDataInUserDefaults()
            
            // Go to welcome page
            let storyboard = UIStoryboard(name: kMainStoryboard, bundle: nil)
            if let viewController = storyboard.instantiateViewControllerWithIdentifier("WelcomeNavigation") as? UINavigationController {
                self.presentViewController(viewController, animated: true, completion: nil)
            }
        } else {
            ParseHelper.initializeUserDataInUserDefaults({ (success, error) -> Void in
                if success {
                    println("initallize core date successfully")
                }
            })
            ParseHelper.initializeCoreDataOfContacts({ (success, error) -> Void in
                if success {
                    self.performSegueWithIdentifier(kToMainTabBar, sender: self)
                    println("initallize core date successfully")
                } else {
                    GlobalHUD.showErrorHUDForView(self.view, withMessage: "Login failed. Please try again.", animated: true, hide: true, delay: 2)
                    // Go to welcome page
                    let storyboard = UIStoryboard(name: kMainStoryboard, bundle: nil)
                    if let viewController = storyboard.instantiateViewControllerWithIdentifier("WelcomeNavigation") as? UINavigationController {
                        self.presentViewController(viewController, animated: true, completion: nil)
                    }
                }
            })
            
        }
    }
    
    // MARK: - Delegates
    
    // MARK: - Event Responses
    
    // MARK: - Getters & Setters
    
    // MARK: - Private Methods (not include)
    
    
    
    
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }


}
